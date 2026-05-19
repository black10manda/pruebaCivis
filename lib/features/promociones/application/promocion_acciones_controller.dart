import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'promociones_providers.dart';

class PromocionAccionesController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> toggleActivo(String id, bool activo) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(promocionesRepositoryProvider).cambiarActivo(id, activo);
    });
    return !state.hasError;
  }

  Future<bool> eliminar(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(promocionesRepositoryProvider).eliminar(id);
    });
    return !state.hasError;
  }
}

final promocionAccionesControllerProvider =
    AutoDisposeAsyncNotifierProvider<PromocionAccionesController, void>(
      PromocionAccionesController.new,
    );
