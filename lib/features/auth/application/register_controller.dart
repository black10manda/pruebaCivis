import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

class RegisterController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password);
    });
    return !state.hasError;
  }
}

final registerControllerProvider =
    AutoDisposeAsyncNotifierProvider<RegisterController, void>(
      RegisterController.new,
    );
