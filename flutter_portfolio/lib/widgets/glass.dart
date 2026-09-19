import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Frosted surface with a 1px gradient hairline border.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final bool hoverLift;
  final Gradient? borderGradient;
  final Color? tint;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 22,
    this.blur = 18,
    this.hoverLift = false,
    this.borderGradient,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final BorderRadius br = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: br,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                (tint ?? c.glass),
                (tint ?? c.glass).withOpacity(0.02),
              ],
            ),
            border: Border.all(color: c.border, width: 1),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Thin gradient divider used between sections.
class GradientRule extends StatelessWidget {
  final double width;
  const GradientRule({super.key, this.width = 120});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Container(
      width: width,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(colors: <Color>[c.accent3, c.accent2]),
      ),
    );
  }
}
