import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/auth_providers.dart';
import 'logout_confirm_dialog.dart';
import 'solicitante_sheet.dart';

/// Drawer derecho con datos del usuario y acción de cerrar sesión.
class AccountDrawer extends ConsumerWidget {
  const AccountDrawer({super.key});

  static const Color _destructive = Color(0xFFDC2626);

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final authRepository = ref.read(authRepositoryProvider);
    Navigator.of(context).pop();
    final ok = await LogoutConfirmDialog.show(context);
    if (ok) {
      await authRepository.signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final email = user?.email ?? '';
    final nombre = email.split('@').first;
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();

    return Drawer(
      backgroundColor: cs.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cs.primary,
                          Color.lerp(cs.primary, Colors.black, 0.28) ??
                              cs.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Text(
                      inicial,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    nombre.isEmpty ? 'Cuenta' : nombre,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: cs.outlineVariant.withValues(alpha: 0.6),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
              child: _MenuTile(
                icon: Icons.person_outline_rounded,
                label: 'Datos del Solicitante',
                onTap: () {
                  Navigator.of(context).pop();
                  SolicitanteSheet.show(context);
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
              child: Material(
                color: _destructive.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _handleLogout(context, ref),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _destructive.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            size: 18.sp,
                            color: _destructive,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: _destructive,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: cs.primary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
