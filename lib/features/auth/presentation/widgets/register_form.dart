import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/fade_in_up.dart';
import 'auth_footer_prompt.dart';

/// Card con el formulario de registro.
class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.isLoading,
    required this.onSubmit,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isLoading;
  final Future<void> Function() onSubmit;
  final VoidCallback onLogin;

  @override
  State<RegisterForm> createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool validate() => formKey.currentState?.validate() ?? false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
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
                'Crear cuenta',
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
                'Regístrate para empezar',
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
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                enabled: !widget.isLoading,
                validator: Validators.password,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: _ObscureToggle(
                  obscured: _obscurePassword,
                  onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            FadeInUp(
              delay: const Duration(milliseconds: 380),
              child: AppTextField(
                controller: widget.confirmController,
                label: 'Confirmar contraseña',
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                enabled: !widget.isLoading,
                validator: (v) => Validators.combinar([
                  () => Validators.requerido(v, campo: 'Confirmación'),
                  () => Validators.coincide(v, widget.passwordController.text),
                ]),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: _ObscureToggle(
                  obscured: _obscureConfirm,
                  onPressed: () => setState(
                    () => _obscureConfirm = !_obscureConfirm,
                  ),
                ),
                onSubmitted: (_) => widget.onSubmit(),
              ),
            ),
            SizedBox(height: 28.h),
            FadeInUp(
              delay: const Duration(milliseconds: 430),
              child: AppButton(
                label: 'Crear cuenta',
                onPressed: widget.onSubmit,
                isLoading: widget.isLoading,
              ),
            ),
            SizedBox(height: 8.h),
            FadeInUp(
              delay: const Duration(milliseconds: 480),
              child: AuthFooterPrompt(
                text: '¿Ya tienes cuenta?',
                actionLabel: 'Inicia sesión',
                onAction: widget.onLogin,
                enabled: !widget.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObscureToggle extends StatelessWidget {
  const _ObscureToggle({required this.obscured, required this.onPressed});

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, anim) => ScaleTransition(
          scale: anim,
          child: FadeTransition(opacity: anim, child: child),
        ),
        child: Icon(
          obscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          key: ValueKey(obscured),
        ),
      ),
    );
  }
}
