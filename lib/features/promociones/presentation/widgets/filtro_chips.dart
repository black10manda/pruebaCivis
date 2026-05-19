import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/promociones_providers.dart';

/// Filtros como chips pill, con scroll horizontal y count inline.
class FiltroChips extends ConsumerWidget {
  const FiltroChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activo = ref.watch(filtroPromocionesProvider);
    final activas = ref.watch(promocionesActivasCountProvider);
    final inactivas = ref.watch(promocionesInactivasCountProvider);
    final enviadas = ref.watch(promocionesEnviadasCountProvider);
    final noEnviadas = ref.watch(promocionesNoEnviadasCountProvider);
    final total = ref.watch(promocionesStreamProvider).maybeWhen(
          data: (list) => list.length,
          orElse: () => 0,
        );

    final items = <_FiltroItem>[
      _FiltroItem(FiltroPromociones.todas, 'Todas', total),
      _FiltroItem(FiltroPromociones.activas, 'Activas', activas),
      _FiltroItem(FiltroPromociones.inactivas, 'Inactivas', inactivas),
      _FiltroItem(FiltroPromociones.enviadas, 'Enviadas', enviadas),
      _FiltroItem(FiltroPromociones.noEnviadas, 'No enviadas', noEnviadas),
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final item = items[i];
          final selected = item.value == activo;
          return _FiltroChip(
            label: item.label,
            count: item.count,
            selected: selected,
            onTap: () => ref
                .read(filtroPromocionesProvider.notifier)
                .state = item.value,
          );
        },
      ),
    );
  }
}

class _FiltroItem {
  const _FiltroItem(this.value, this.label, this.count);
  final FiltroPromociones value;
  final String label;
  final int count;
}

class _FiltroChip extends StatelessWidget {
  const _FiltroChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.primary : cs.surface;
    final fg = selected ? cs.onPrimary : cs.onSurface;
    final countBg = selected
        ? Colors.white.withValues(alpha: 0.22)
        : cs.surfaceContainerHighest.withValues(alpha: 0.8);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : cs.outlineVariant.withValues(alpha: 0.6),
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: countBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
