import 'package:flutter/material.dart';

/// Entrada con fade + traslación vertical, con delay opcional.
/// Útil para encadenar apariciones (staggered) sin agregar dependencias.
class FadeInUp extends StatefulWidget {
  const FadeInUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 350),
    this.offset = 16,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  final Curve curve;

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late final Duration _total = widget.delay + widget.duration;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  );

  late final Animation<double> _anim = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _total == Duration.zero
          ? 0
          : widget.delay.inMicroseconds / _total.inMicroseconds,
      1.0,
      curve: widget.curve,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        return Opacity(
          opacity: _anim.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _anim.value) * widget.offset),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
