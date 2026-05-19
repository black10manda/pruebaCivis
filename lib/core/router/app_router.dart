import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/promociones/presentation/lista_promociones_screen.dart';
import '../../shared/constants.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;

      final loggedIn = auth.valueOrNull != null;
      final loggingIn = state.matchedLocation == AppRoutes.login;

      if (!loggedIn) return loggingIn ? null : AppRoutes.login;
      if (loggingIn) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ListaPromocionesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Ruta no encontrada: ${state.uri}')),
    ),
  );
});

class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _ref.listen<AsyncValue<dynamic>>(
      authStateProvider,
      (_, _) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref _ref;
}
