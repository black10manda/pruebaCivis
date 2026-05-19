import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/application/auth_providers.dart';
import '../../application/promociones_providers.dart';

/// Header del panel: saludo personalizado + KPIs + cerrar sesión.
class PromocionesHeader extends ConsumerWidget {
  const PromocionesHeader({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final email = user?.email ?? '';
    final nombre = email.split('@').first;

    final activas = ref.watch(promocionesActivasCountProvider);
    final inactivas = ref.watch(promocionesInactivasCountProvider);
    final enviadas = ref.watch(promocionesEnviadasCountProvider);
    final total = activas + inactivas;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 12.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola,',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      nombre.isEmpty ? 'Bienvenido' : nombre,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Cerrar sesión',
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: cs.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  foregroundColor: cs.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  label: 'Activas',
                  value: activas,
                  color: cs.primary,
                  icon: Icons.bolt_rounded,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _KpiCard(
                  label: 'Enviadas',
                  value: enviadas,
                  color: const Color(0xFF16A34A),
                  icon: Icons.send_rounded,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _KpiCard(
                  label: 'Total',
                  value: total,
                  color: cs.onSurface,
                  icon: Icons.campaign_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: color),
          ),
          SizedBox(height: 12.h),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
