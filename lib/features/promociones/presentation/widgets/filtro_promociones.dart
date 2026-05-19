import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application/promociones_providers.dart';

class FiltroPromocionesBar extends ConsumerWidget {
  const FiltroPromocionesBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtro = ref.watch(filtroPromocionesProvider);
    final activas = ref.watch(promocionesActivasCountProvider);
    final inactivas = ref.watch(promocionesInactivasCountProvider);
    final total = activas + inactivas;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: SegmentedButton<FiltroPromociones>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: FiltroPromociones.todas,
            label: Text(
              'Todas ($total)',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
          ButtonSegment(
            value: FiltroPromociones.activas,
            label: Text(
              'Activas ($activas)',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
          ButtonSegment(
            value: FiltroPromociones.inactivas,
            label: Text(
              'Inactivas ($inactivas)',
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
        ],
        selected: {filtro},
        onSelectionChanged: (set) {
          ref.read(filtroPromocionesProvider.notifier).state = set.first;
        },
      ),
    );
  }
}
