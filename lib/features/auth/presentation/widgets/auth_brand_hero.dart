import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Encabezado de marca para pantallas de autenticación:
/// fondo con gradiente primario, logo y nombre de la app.
class AuthBrandHero extends StatelessWidget {
  const AuthBrandHero({super.key, this.title = 'Promociones'});

  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.primary],
              ),
            ),
          ),
        ),
        Positioned(
          top: -40.r,
          right: -30.r,
          child: _Blob(size: 180.r, opacity: 0.08),
        ),
        Positioned(
          bottom: 30.r,
          left: -50.r,
          child: _Blob(size: 140.r, opacity: 0.06),
        ),
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56.h),
                  Container(
                    width: 72.w,
                    height: 72.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Icon(
                      Icons.campaign_outlined,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
