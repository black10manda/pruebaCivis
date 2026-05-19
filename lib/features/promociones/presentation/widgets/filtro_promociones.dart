import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: SegmentedButton<FiltroPromociones>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: FiltroPromociones.todas,
            label: Text('Todas ($total)'),
          ),
          ButtonSegment(
            value: FiltroPromociones.activas,
            label: Text('Activas ($activas)'),
          ),
          ButtonSegment(
            value: FiltroPromociones.inactivas,
            label: Text('Inactivas ($inactivas)'),
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
