import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'promociones_providers.dart';

class EnvioController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> enviar(String promocionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(promocionesRepositoryProvider).marcarEnviada(promocionId);
    });
    return !state.hasError;
  }
}

final envioControllerProvider =
    AutoDisposeAsyncNotifierProvider<EnvioController, void>(
  EnvioController.new,
);

final enviandoIdProvider = StateProvider<String?>((ref) => null);
