import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/application/auth_providers.dart';

/// Header del panel: saludo en una línea + botón de menú (abre endDrawer).
class PromocionesHeader extends ConsumerWidget {
  const PromocionesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final email = user?.email ?? '';
    final nombre = email.split('@').first;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hola, ',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurfaceVariant,
                      letterSpacing: -0.3,
                    ),
                  ),
                  TextSpan(
                    text: nombre.isEmpty ? 'Bienvenido' : nombre,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: 'Menú',
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            icon: const Icon(Icons.menu_rounded),
            style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest.withValues(
                alpha: 0.6,
              ),
              foregroundColor: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
