import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_mapper.dart';
import '../../../core/widgets/fade_in_up.dart';
import '../../../shared/constants.dart';
import '../application/register_controller.dart';
import 'widgets/auth_brand_hero.dart';
import 'widgets/register_form.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<RegisterFormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _shake = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
  ]).animate(
    CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
  );

  @override
  void dispose() {
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    FocusScope.of(context).unfocus();

    final ok = await ref
        .read(registerControllerProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Cuenta creada correctamente')),
        );
    }
  }

  void _goToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final isLoading = state.isLoading;

    ref.listen<AsyncValue<void>>(registerControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          _shakeController.forward(from: 0);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(ErrorMapper.fromAuth(e))),
            );
        },
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: FadeInUp(
              offset: 0,
              duration: Duration(milliseconds: 400),
              child: AuthBrandHero(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 200.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 80),
                    child: AnimatedBuilder(
                      animation: _shake,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(_shake.value, 0),
                        child: child,
                      ),
                      child: RegisterForm(
                        key: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmController: _confirmController,
                        isLoading: isLoading,
                        onSubmit: _submit,
                        onLogin: _goToLogin,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
