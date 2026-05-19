import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/promociones_providers.dart';

class PromocionesEmpty extends StatelessWidget {
  const PromocionesEmpty({
    super.key,
    required this.filtro,
    required this.onCrear,
  });

  final FiltroPromociones filtro;
  final VoidCallback onCrear;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final (titulo, descripcion) = switch (filtro) {
      FiltroPromociones.todas => (
        'Aún no hay promociones',
        'Crea tu primera promoción y empieza a enviarla a tus clientes.',
      ),
      FiltroPromociones.activas => (
        'Sin promociones activas',
        'Activa una promoción existente o crea una nueva para verla aquí.',
      ),
      FiltroPromociones.inactivas => (
        'Sin promociones inactivas',
        'Todas tus promociones están activas en este momento.',
      ),
    };

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withValues(alpha: 0.18),
                    cs.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: Icon(
                Icons.campaign_rounded,
                size: 44.sp,
                color: cs.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: cs.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            if (filtro == FiltroPromociones.todas) ...[
              SizedBox(height: 24.h),
              FilledButton.icon(
                onPressed: onCrear,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear promoción'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
