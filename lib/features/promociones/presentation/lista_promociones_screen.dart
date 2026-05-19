import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_mapper.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/fade_in_up.dart';
import '../../../shared/constants.dart';
import '../../auth/application/login_controller.dart';
import '../application/envio_controller.dart';
import '../application/promociones_providers.dart';
import '../domain/promocion.dart';
import 'widgets/filtro_chips.dart';
import 'widgets/gradient_fab.dart';
import 'widgets/promocion_card.dart';
import 'widgets/promociones_empty.dart';
import 'widgets/promociones_header.dart';

class ListaPromocionesScreen extends ConsumerWidget {
  const ListaPromocionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(promocionesFiltradasProvider);
    final enviandoId = ref.watch(enviandoIdProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PromocionesHeader(
              onLogout: () => _confirmarLogout(context, ref),
            ),
            const FiltroChips(),
            SizedBox(height: 12.h),
            Expanded(
              child: AsyncValueView<List<Promocion>>(
                value: async,
                data: (lista) {
                  if (lista.isEmpty) {
                    final filtro = ref.watch(filtroPromocionesProvider);
                    return PromocionesEmpty(
                      filtro: filtro,
                      onCrear: () => context.push(AppRoutes.nuevaPromocion),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(promocionesStreamProvider);
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 108.h),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: lista.length,
                      separatorBuilder: (_, _) => SizedBox(height: 14.h),
                      itemBuilder: (context, i) {
                        final p = lista[i];
                        return FadeInUp(
                          delay: Duration(milliseconds: 60 * i),
                          child: PromocionCard(
                            promocion: p,
                            enviando: enviandoId == p.id,
                            onTap: () => context.push(
                              AppRoutes.editarPromocion,
                              extra: p,
                            ),
                            onEnviar: () => _enviar(context, ref, p),
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
      ),
      floatingActionButton: GradientFab(
        label: 'Nueva',
        icon: Icons.add_rounded,
        onPressed: () => context.push(AppRoutes.nuevaPromocion),
      ),
    );
  }

  Future<void> _enviar(
    BuildContext context,
    WidgetRef ref,
    Promocion promocion,
  ) async {
    ref.read(enviandoIdProvider.notifier).state = promocion.id;
    final ok = await ref
        .read(envioControllerProvider.notifier)
        .enviar(promocion.id);
    ref.read(enviandoIdProvider.notifier).state = null;

    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Promoción enviada')),
      );
    } else {
      final error = ref.read(envioControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error == null
                ? 'No se pudo enviar la promoción.'
                : ErrorMapper.fromException(error),
          ),
        ),
      );
    }
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
