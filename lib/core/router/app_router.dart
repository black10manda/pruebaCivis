import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/promociones/domain/promocion.dart';
import '../../features/promociones/presentation/lista_promociones_screen.dart';
import '../../features/promociones/presentation/promocion_form_screen.dart';
import '../../shared/constants.dart';
import '../widgets/splash_screen.dart';

const String _splashPath = '/';

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);

  return GoRouter(
    initialLocation: _splashPath,
    refreshListenable: notifier,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final loc = state.matchedLocation;

      if (auth.isLoading) {
        return loc == _splashPath ? null : _splashPath;
      }

      final loggedIn = auth.valueOrNull != null;

      if (loc == _splashPath) {
        return loggedIn ? AppRoutes.home : AppRoutes.login;
      }

      final esPantallaAuth =
          loc == AppRoutes.login || loc == AppRoutes.register;
      if (!loggedIn) return esPantallaAuth ? null : AppRoutes.login;
      if (esPantallaAuth) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: _splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ListaPromocionesScreen(),
        routes: [
          GoRoute(
            path: 'nueva',
            builder: (context, state) => const PromocionFormScreen(),
          ),
          GoRoute(
            path: 'editar',
            builder: (context, state) {
              final promocion = state.extra as Promocion?;
              return PromocionFormScreen(promocion: promocion);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Ruta no encontrada: ${state.uri}'))),
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
