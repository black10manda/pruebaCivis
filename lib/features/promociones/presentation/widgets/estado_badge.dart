import 'package:flutter/material.dart';

class EstadoBadge extends StatelessWidget {
  const EstadoBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory EstadoBadge.activa(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return EstadoBadge(
      label: 'Activa',
      color: scheme.primary,
      icon: Icons.check_circle_outline,
    );
  }

  factory EstadoBadge.inactiva(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return EstadoBadge(
      label: 'Inactiva',
      color: scheme.outline,
      icon: Icons.pause_circle_outline,
    );
  }

  factory EstadoBadge.enviada(BuildContext context) {
    return const EstadoBadge(
      label: 'Enviada',
      color: Color(0xFF2E7D32),
      icon: Icons.send_outlined,
    );
  }

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
