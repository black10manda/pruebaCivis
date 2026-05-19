import 'package:cloud_firestore/cloud_firestore.dart';

class Promocion {
  const Promocion({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.activo,
    required this.creadoPor,
    required this.creadoEn,
    this.imagenUrl,
    this.enviadaEn,
  });

  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final bool activo;
  final String creadoPor;
  final DateTime creadoEn;
  final String? imagenUrl;
  final DateTime? enviadaEn;

  bool get yaEnviada => enviadaEn != null;

  factory Promocion.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return Promocion(
      id: doc.id,
      titulo: data['titulo'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      fecha: _toDate(data['fecha']) ?? DateTime.now(),
      activo: data['activo'] as bool? ?? true,
      imagenUrl: data['imagenUrl'] as String?,
      enviadaEn: _toDate(data['enviadaEn']),
      creadoPor: data['creadoPor'] as String? ?? '',
      creadoEn: _toDate(data['creadoEn']) ?? DateTime.now(),
    );
  }

  Promocion copyWith({
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    bool? activo,
    String? imagenUrl,
    DateTime? enviadaEn,
  }) {
    return Promocion(
      id: id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      activo: activo ?? this.activo,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      enviadaEn: enviadaEn ?? this.enviadaEn,
      creadoPor: creadoPor,
      creadoEn: creadoEn,
    );
  }

  static DateTime? _toDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
