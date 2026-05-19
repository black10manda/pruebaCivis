import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../shared/constants.dart';
import '../domain/promocion.dart';
import '../domain/promocion_draft.dart';

class PromocionesRepository {
  PromocionesRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _storage = storage,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestoreCollections.promociones);

  Stream<List<Promocion>> watchAll() {
    return _col
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Promocion.fromFirestore).toList());
  }

  Future<Promocion?> obtener(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return Promocion.fromFirestore(doc);
  }

  Future<String> subirImagen(File imagen) async {
    final segmento = imagen.uri.pathSegments.last;
    final filename = '${DateTime.now().millisecondsSinceEpoch}_$segmento';
    final ref = _storage
        .ref()
        .child(StoragePaths.promocionesImagenes)
        .child(filename);
    final task = await ref.putFile(imagen);
    return task.ref.getDownloadURL();
  }

  Future<String> crear(PromocionDraft draft) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw StateError('Usuario no autenticado');
    }

    String? imagenUrl = draft.imagenUrl;
    if (draft.imagen != null) {
      imagenUrl = await subirImagen(draft.imagen!);
    }

    final docRef = await _col.add({
      'titulo': draft.titulo,
      'descripcion': draft.descripcion,
      'fecha': Timestamp.fromDate(draft.fecha),
      'imagenUrl': imagenUrl,
      'activo': draft.activo,
      'enviadaEn': null,
      'creadoPor': userId,
      'creadoEn': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> actualizar(String id, PromocionDraft draft) async {
    String? imagenUrl = draft.imagenUrl;
    if (draft.imagen != null) {
      imagenUrl = await subirImagen(draft.imagen!);
    }

    await _col.doc(id).update({
      'titulo': draft.titulo,
      'descripcion': draft.descripcion,
      'fecha': Timestamp.fromDate(draft.fecha),
      'imagenUrl': imagenUrl,
      'activo': draft.activo,
    });
  }

  Future<void> cambiarActivo(String id, bool activo) async {
    await _col.doc(id).update({'activo': activo});
  }

  Future<void> marcarEnviada(String id) async {
    await _col.doc(id).update({'enviadaEn': FieldValue.serverTimestamp()});
  }

  Future<void> eliminar(String id) async {
    await _col.doc(id).delete();
  }
}
