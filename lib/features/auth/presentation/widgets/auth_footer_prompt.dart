import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Línea inferior del formulario de auth: "¿No tienes cuenta? Regístrate"
/// o "¿Ya tienes cuenta? Inicia sesión".
class AuthFooterPrompt extends StatelessWidget {
  const AuthFooterPrompt({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onAction,
    this.enabled = true,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
        ),
        TextButton(
          onPressed: enabled ? onAction : null,
          child: Text(actionLabel),
        ),
      ],
    );
  }
}
