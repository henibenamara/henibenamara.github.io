import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Text painted with the brand gradient, optionally animated so the gradient
/// slides across the glyphs.
class GradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign align;
  final bool animate;
  final List<Color>? colors;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.align = TextAlign.start,
    this.animate = false,
    this.colors,
  });

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors col = context.c;
    final List<Color> colors =
        widget.colors ?? <Color>[col.accent3, col.accent, col.accent2, col.accent3];
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? _) {
        final double t = widget.animate ? _c.value : 0;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: colors,
              begin: Alignment(-1 + t * 2, -0.4),
              end: Alignment(1 + t * 2, 0.4),
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            textAlign: widget.align,
            style: (widget.style ?? Theme.of(context).textTheme.displayMedium)
                ?.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
