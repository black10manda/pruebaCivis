import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/promocion.dart';

/// Encabezado visual de la card de promoción: imagen (o placeholder) +
/// pill de estado clickeable + pill de "Enviada" cuando aplica.
class PromocionCardHero extends StatelessWidget {
  const PromocionCardHero({
    super.key,
    required this.promocion,
    this.onToggleActivo,
  });

  final Promocion promocion;
  final VoidCallback? onToggleActivo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: promocion.imagenUrl != null
              ? _NetworkImage(url: promocion.imagenUrl!)
              : _PlaceholderArt(titulo: promocion.titulo),
        ),
        Positioned(
          top: 12.h,
          right: 12.w,
          child: _EstadoPill(
            activo: promocion.activo,
            onTap: onToggleActivo,
          ),
        ),
        if (promocion.yaEnviada)
          Positioned(
            top: 12.h,
            left: 12.w,
            child: const _EnviadaPill(),
          ),
      ],
    );
  }
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: cs.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, _, _) => Container(
        color: cs.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Placeholder cuando no hay imagen: gradiente de marca + inicial estilizada.
class _PlaceholderArt extends StatelessWidget {
  const _PlaceholderArt({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inicial = titulo.trim().isEmpty
        ? '?'
        : titulo.trim().substring(0, 1).toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary,
            Color.lerp(cs.primary, Colors.black, 0.3) ?? cs.primary,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Center(
            child: Text(
              inicial,
              style: TextStyle(
                fontSize: 56.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: -2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoPill extends StatelessWidget {
  const _EstadoPill({required this.activo, this.onTap});

  final bool activo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = activo ? const Color(0xFF16A34A) : const Color(0xFF6B7280);
    final label = activo ? 'Activa' : 'Pausada';

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
              letterSpacing: 0.1,
            ),
          ),
          if (onTap != null) ...[
            SizedBox(width: 4.w),
            Icon(
              activo
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 14.sp,
              color: const Color(0xFF111827).withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );

    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              child: Tooltip(
                message: activo ? 'Pausar promoción' : 'Reactivar promoción',
                child: content,
              ),
            ),
    );
  }
}

class _EnviadaPill extends StatelessWidget {
  const _EnviadaPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 12.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            'Enviada',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
