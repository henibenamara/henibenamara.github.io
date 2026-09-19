import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';

/// Gradient logo tile with the initials, slowly breathing.
class LogoMark extends StatefulWidget {
  final double size;
  final bool animate;
  const LogoMark({super.key, this.size = 38, this.animate = true});

  @override
  State<LogoMark> createState() => _LogoMarkState();
}

class _LogoMarkState extends State<LogoMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) {
        final double t = Curves.easeInOut.transform(_c.value);
        return Transform.rotate(
          angle: (t - 0.5) * 0.12,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  widget.size * (0.3 + 0.12 * t)),
              gradient: LinearGradient(
                colors: <Color>[c.accent3, c.accent, c.accent2],
                begin: Alignment(-1 + t, -1),
                end: Alignment(1, 1 - t),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: c.accent.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                  spreadRadius: -4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              profile.initials,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: widget.size * 0.38,
                letterSpacing: -0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}
