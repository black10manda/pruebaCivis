import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.primary && fullWidth) {
      return _MorphPrimaryButton(
        label: label,
        icon: icon,
        isLoading: isLoading,
        onPressed: onPressed,
      );
    }

    final effectiveOnPressed = isLoading ? null : onPressed;
    final child = isLoading
        ? SizedBox(
            height: 22.w,
            width: 22.w,
            child: const CircularProgressIndicator(strokeWidth: 2.4),
          )
        : _Content(label: label, icon: icon);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        child: child,
      ),
    };

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Botón primario que muta de barra a círculo cuando entra en loading.
class _MorphPrimaryButton extends StatefulWidget {
  const _MorphPrimaryButton({
    required this.label,
    required this.isLoading,
    this.icon,
    this.onPressed,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  State<_MorphPrimaryButton> createState() => _MorphPrimaryButtonState();
}

class _MorphPrimaryButtonState extends State<_MorphPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    value: widget.isLoading ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(covariant _MorphPrimaryButton old) {
    super.didUpdateWidget(old);
    if (widget.isLoading != old.isLoading) {
      if (widget.isLoading) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final h = 52.h;
    final disabled = widget.isLoading || widget.onPressed == null;
    final bg = disabled && !widget.isLoading
        ? cs.primary.withValues(alpha: 0.5)
        : cs.primary;

    return SizedBox(
      height: h,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = Curves.easeOutCubic.transform(_controller.value);
              final width = maxW - (maxW - h) * t;
              final radius = 12.r + ((h / 2) - 12.r) * t;
              final borderRadius = BorderRadius.circular(radius);

              return Center(
                child: Material(
                  color: bg,
                  borderRadius: borderRadius,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: disabled ? null : widget.onPressed,
                    child: SizedBox(
                      width: width,
                      height: h,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: widget.isLoading
                              ? SizedBox(
                                  key: const ValueKey('loading'),
                                  width: 22.w,
                                  height: 22.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: cs.onPrimary,
                                  ),
                                )
                              : DefaultTextStyle(
                                  key: const ValueKey('content'),
                                  style: TextStyle(
                                    color: cs.onPrimary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: cs.onPrimary,
                                      size: 20.sp,
                                    ),
                                    child: _Content(
                                      label: widget.label,
                                      icon: widget.icon,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return Text(label);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.sp),
        SizedBox(width: 8.w),
        Text(label),
      ],
    );
  }
}
