import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/fade_in_up.dart';

/// Card con el formulario de inicio de sesión.
/// No conoce de Riverpod: recibe controllers y callbacks desde la pantalla.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  bool _obscure = true;

  bool validate() => formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 180),
              child: Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            FadeInUp(
              delay: const Duration(milliseconds: 230),
              child: Text(
                'Inicia sesión para continuar',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: 28.h),
            FadeInUp(
              delay: const Duration(milliseconds: 280),
              child: AppTextField(
                controller: widget.emailController,
                label: 'Correo',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !widget.isLoading,
                validator: Validators.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            SizedBox(height: 16.h),
            FadeInUp(
              delay: const Duration(milliseconds: 330),
              child: AppTextField(
                controller: widget.passwordController,
                label: 'Contraseña',
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enabled: !widget.isLoading,
                validator: Validators.password,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(_obscure),
                    ),
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                onSubmitted: (_) => widget.onSubmit(),
              ),
            ),
            SizedBox(height: 28.h),
            FadeInUp(
              delay: const Duration(milliseconds: 380),
              child: AppButton(
                label: 'Iniciar sesión',
                onPressed: widget.onSubmit,
                isLoading: widget.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
