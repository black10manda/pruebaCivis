import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_value_view.dart';
import '../../../shared/constants.dart';
import '../../auth/application/login_controller.dart';
import '../application/promociones_providers.dart';
import '../domain/promocion.dart';
import 'widgets/filtro_promociones.dart';
import 'widgets/promocion_card.dart';

class ListaPromocionesScreen extends ConsumerWidget {
  const ListaPromocionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(promocionesFiltradasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmarLogout(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          const FiltroPromocionesBar(),
          Expanded(
            child: AsyncValueView<List<Promocion>>(
              value: async,
              data: (lista) {
                if (lista.isEmpty) {
                  return const _EstadoVacio();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(promocionesStreamProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: lista.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final p = lista[i];
                      return PromocionCard(
                        promocion: p,
                        onTap: () => context.push(
                          AppRoutes.editarPromocion,
                          extra: p,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.nuevaPromocion),
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
    );
  }

  Future<void> _confirmarLogout(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await ref.read(loginControllerProvider.notifier).signOut();
    }
  }
}

class _EstadoVacio extends ConsumerWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filtro = ref.watch(filtroPromocionesProvider);

    final mensaje = switch (filtro) {
      FiltroPromociones.todas =>
        'Aún no tienes promociones. Crea la primera con el botón "+".',
      FiltroPromociones.activas => 'No hay promociones activas.',
      FiltroPromociones.inactivas => 'No hay promociones inactivas.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (filtro == FiltroPromociones.todas) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.nuevaPromocion),
                icon: const Icon(Icons.add),
                label: const Text('Crear promoción'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
