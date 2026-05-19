import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_mapper.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/fade_in_up.dart';
import '../../../shared/constants.dart';
import '../../auth/presentation/widgets/account_drawer.dart';
import '../application/envio_controller.dart';
import '../application/promocion_acciones_controller.dart';
import '../application/promociones_providers.dart';
import '../domain/promocion.dart';
import 'widgets/eliminar_promocion_dialog.dart';
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
      endDrawer: const AccountDrawer(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PromocionesHeader(),
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
                          child: Dismissible(
                            key: ValueKey(p.id),
                            direction: DismissDirection.endToStart,
                            background: const _SwipeDeleteBackground(),
                            confirmDismiss: (_) => EliminarPromocionDialog.show(
                              context,
                              titulo: p.titulo,
                            ),
                            onDismissed: (_) => _eliminar(context, ref, p),
                            child: PromocionCard(
                              promocion: p,
                              enviando: enviandoId == p.id,
                              onTap: () => context.push(
                                AppRoutes.editarPromocion,
                                extra: p,
                              ),
                              onEnviar: () => _enviar(context, ref, p),
                              onToggleActivo: () =>
                                  _toggleActivo(context, ref, p),
                            ),
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
                : ErrorMapper.fromData(error),
          ),
        ),
      );
    }
  }

  Future<void> _toggleActivo(
    BuildContext context,
    WidgetRef ref,
    Promocion promocion,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(promocionAccionesControllerProvider.notifier)
        .toggleActivo(promocion.id, !promocion.activo);

    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();
    if (!ok) {
      final error = ref.read(promocionAccionesControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error == null
                ? 'No se pudo actualizar el estado.'
                : ErrorMapper.fromData(error),
          ),
        ),
      );
    }
  }

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    Promocion promocion,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(promocionAccionesControllerProvider.notifier)
        .eliminar(promocion.id);

    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();
    if (ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Promoción eliminada')),
      );
    } else {
      final error = ref.read(promocionAccionesControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error == null
                ? 'No se pudo eliminar la promoción.'
                : ErrorMapper.fromData(error),
          ),
        ),
      );
    }
  }
}

class _SwipeDeleteBackground extends StatelessWidget {
  const _SwipeDeleteBackground();

  static const Color _destructive = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _destructive,
        borderRadius: BorderRadius.circular(20.r),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 24.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22.sp),
          SizedBox(width: 8.w),
          Text(
            'Eliminar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
