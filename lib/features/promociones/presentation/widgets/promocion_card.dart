import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/promocion.dart';
import 'estado_badge.dart';

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
    final theme = Theme.of(context);
    final fecha = DateFormat('d MMM y', 'es').format(promocion.fecha);
    final atenuado = !promocion.activo;

    return Opacity(
      opacity: atenuado ? 0.65 : 1,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (promocion.imagenUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    promocion.imagenUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promocion.titulo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      promocion.descripcion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          fecha,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (promocion.enviadaEn != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.send_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMM', 'es')
                                .format(promocion.enviadaEn!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (promocion.activo)
                          EstadoBadge.activa(context)
                        else
                          EstadoBadge.inactiva(context),
                        if (promocion.yaEnviada)
                          EstadoBadge.enviada(context),
                      ],
                    ),
                    if (_puedeEnviar) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: enviando ? null : onEnviar,
                          icon: enviando
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_outlined),
                          label: Text(
                            enviando ? 'Enviando…' : 'Enviar promoción',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
