import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

class LoginController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signIn(
            email: email,
            password: password,
          );
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

final loginControllerProvider =
    AutoDisposeAsyncNotifierProvider<LoginController, void>(
  LoginController.new,
);
