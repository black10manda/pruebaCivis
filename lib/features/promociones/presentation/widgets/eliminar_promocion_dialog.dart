import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Diálogo de confirmación para eliminar una promoción.
/// Uso: `final ok = await EliminarPromocionDialog.show(context, titulo: '...');`
class EliminarPromocionDialog extends StatelessWidget {
  const EliminarPromocionDialog._({required this.titulo});

  final String titulo;

  static const Color _destructive = Color(0xFFDC2626);

  static Future<bool> show(BuildContext context, {required String titulo}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => EliminarPromocionDialog._(titulo: titulo),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _destructive.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 26.sp,
                color: _destructive,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Eliminar promoción',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 8.h),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Se eliminará '),
                  TextSpan(
                    text: '"$titulo"',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const TextSpan(text: '. Esta acción no se puede deshacer.'),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: cs.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(48.h),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.8),
                      ),
                      foregroundColor: cs.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: _destructive,
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Eliminar',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
