import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromocionStatusCard extends StatelessWidget {
  const PromocionStatusCard({
    super.key,
    required this.activo,
    required this.onChanged,
  });

  final bool activo;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = activo
        ? const Color(0xFF16A34A)
        : cs.outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: activo
            ? const Color(0xFF16A34A).withValues(alpha: 0.05)
            : cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: activo
              ? const Color(0xFF16A34A).withValues(alpha: 0.4)
              : cs.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              activo ? Icons.bolt_rounded : Icons.pause_rounded,
              size: 18.sp,
              color: accent,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activo ? 'Promoción activa' : 'Promoción pausada',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  activo
                      ? 'Visible y disponible para envío'
                      : 'Oculta de los envíos',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: activo,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }
}
