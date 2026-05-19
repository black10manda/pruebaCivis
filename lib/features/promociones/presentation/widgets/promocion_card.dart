import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_button.dart';
import '../../domain/promocion.dart';
import 'promocion_card_hero.dart';

class PromocionCard extends StatelessWidget {
  const PromocionCard({
    super.key,
    required this.promocion,
    this.onTap,
    this.onEnviar,
    this.onToggleActivo,
    this.enviando = false,
  });

  final Promocion promocion;
  final VoidCallback? onTap;
  final VoidCallback? onEnviar;
  final VoidCallback? onToggleActivo;
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
                PromocionCardHero(
                  promocion: promocion,
                  onToggleActivo: onToggleActivo,
                ),
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
