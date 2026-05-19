import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../data/promociones_repository.dart';
import '../domain/promocion.dart';

enum FiltroPromociones { todas, activas, inactivas }

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final promocionesRepositoryProvider = Provider<PromocionesRepository>((ref) {
  return PromocionesRepository(
    firestore: ref.watch(firestoreProvider),
    storage: ref.watch(firebaseStorageProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final promocionesStreamProvider = StreamProvider<List<Promocion>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) {
    return Stream.value(const <Promocion>[]);
  }
  return ref.watch(promocionesRepositoryProvider).watchAll();
});

final filtroPromocionesProvider = StateProvider<FiltroPromociones>((ref) {
  return FiltroPromociones.todas;
});

final promocionesFiltradasProvider = Provider<AsyncValue<List<Promocion>>>((
  ref,
) {
  final filtro = ref.watch(filtroPromocionesProvider);
  final async = ref.watch(promocionesStreamProvider);
  return async.whenData((list) {
    return switch (filtro) {
      FiltroPromociones.todas => list,
      FiltroPromociones.activas => list.where((p) => p.activo).toList(),
      FiltroPromociones.inactivas => list.where((p) => !p.activo).toList(),
    };
  });
});

final promocionesActivasCountProvider = Provider<int>((ref) {
  return ref
      .watch(promocionesStreamProvider)
      .maybeWhen(
        data: (list) => list.where((p) => p.activo).length,
        orElse: () => 0,
      );
});

final promocionesInactivasCountProvider = Provider<int>((ref) {
  return ref
      .watch(promocionesStreamProvider)
      .maybeWhen(
        data: (list) => list.where((p) => !p.activo).length,
        orElse: () => 0,
      );
});
