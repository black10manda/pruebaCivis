import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header limpio para formularios: back + título grande + subtítulo opcional.
class FormHeader extends StatelessWidget {
  const FormHeader({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.onBack,
  });

  final String titulo;
  final String? subtitulo;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final back = onBack ?? () => Navigator.of(context).maybePop();

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 20.w, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: back,
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest.withValues(
                alpha: 0.6,
              ),
              foregroundColor: cs.onSurface,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),
                  if (subtitulo != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitulo!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
