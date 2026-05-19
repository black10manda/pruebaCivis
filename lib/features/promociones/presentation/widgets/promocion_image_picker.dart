import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromocionImagePicker extends StatelessWidget {
  const PromocionImagePicker({
    super.key,
    required this.imagen,
    required this.imagenUrl,
    required this.onSeleccionar,
    required this.onQuitar,
  });

  final File? imagen;
  final String? imagenUrl;
  final VoidCallback onSeleccionar;
  final VoidCallback onQuitar;

  bool get _tieneImagen => imagen != null || imagenUrl != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSeleccionar,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imagen != null)
                Image.file(imagen!, fit: BoxFit.cover)
              else if (imagenUrl != null)
                Image.network(
                  imagenUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _Empty(onTap: onSeleccionar),
                )
              else
                _Empty(onTap: onSeleccionar),
              if (_tieneImagen) ...[
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: _RoundIconButton(
                    icon: Icons.close_rounded,
                    onTap: onQuitar,
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  right: 10.w,
                  child: _ChipAction(
                    icon: Icons.swap_horiz_rounded,
                    label: 'Cambiar',
                    onTap: onSeleccionar,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary.withValues(alpha: 0.06),
            cs.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 26.sp,
                color: cs.primary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Agregar imagen',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Opcional · JPG o PNG',
              style: TextStyle(
                fontSize: 12.sp,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(7.w),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
      ),
    );
  }
}

class _ChipAction extends StatelessWidget {
  const _ChipAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: const Color(0xFF111827)),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
