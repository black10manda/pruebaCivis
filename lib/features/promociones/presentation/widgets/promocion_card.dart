import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_button.dart';
import '../../domain/promocion.dart';

class PromocionCard extends StatelessWidget {
  const PromocionCard({
    super.key,
    required this.promocion,
    this.onTap,
    this.onEnviar,
    this.enviando = false,
  });

  final Promocion promocion;
  final VoidCallback? onTap;
  final VoidCallback? onEnviar;
  final bool enviando;

  bool get _puedeEnviar =>
      promocion.activo && !promocion.yaEnviada && onEnviar != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fecha = DateFormat('d MMM y', 'es').format(promocion.fecha);
    final atenuado = !promocion.activo;

    return Opacity(
      opacity: atenuado ? 0.72 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Hero(promocion: promocion),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promocion.titulo,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.3,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        promocion.descripcion,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: cs.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 14.h),
                      _MetaRow(fecha: fecha, enviadaEn: promocion.enviadaEn),
                      if (_puedeEnviar) ...[
                        SizedBox(height: 16.h),
                        AppButton(
                          label: enviando ? 'Enviando…' : 'Enviar promoción',
                          icon: enviando ? null : Icons.send_rounded,
                          onPressed: onEnviar,
                          isLoading: enviando,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.promocion});

  final Promocion promocion;

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
          child: _EstadoPill(activo: promocion.activo),
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
  const _EstadoPill({required this.activo});

  final bool activo;

  @override
  Widget build(BuildContext context) {
    final color = activo ? const Color(0xFF16A34A) : const Color(0xFF6B7280);
    final label = activo ? 'Activa' : 'Pausada';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
      ),
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
        ],
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.fecha, required this.enviadaEn});

  final String fecha;
  final DateTime? enviadaEn;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontSize: 12.sp,
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 13.sp,
          color: cs.onSurfaceVariant,
        ),
        SizedBox(width: 6.w),
        Text(fecha, style: style),
        if (enviadaEn != null) ...[
          SizedBox(width: 10.w),
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.send_rounded,
            size: 13.sp,
            color: cs.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Text(
            'Enviada ${DateFormat('d MMM', 'es').format(enviadaEn!)}',
            style: style,
          ),
        ],
      ],
    );
  }
}
