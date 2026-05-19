import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/promocion_draft.dart';
import 'promociones_providers.dart';

class PromocionFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> guardar(PromocionDraft draft) async {
    state = const AsyncLoading();
    String? id;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(promocionesRepositoryProvider);
      if (draft.esEdicion) {
        await repo.actualizar(draft.id!, draft);
        id = draft.id;
      } else {
        id = await repo.crear(draft);
      }
    });
    return state.hasError ? null : id;
  }
}

final promocionFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<PromocionFormController, void>(
      PromocionFormController.new,
    );
