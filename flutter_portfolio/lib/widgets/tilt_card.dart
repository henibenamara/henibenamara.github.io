import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A card that tilts in 3D toward the cursor, with a moving specular glare.
/// Perspective comes from a plain Matrix4 - no packages, no shaders.
class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt; // radians at the extremes
  final double radius;
  final double hoverScale;
  final bool glare;
  final VoidCallback? onTap;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.10,
    this.radius = 24,
    this.hoverScale = 1.02,
    this.glare = true,
    this.onTap,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  Offset _p = Offset.zero;
  Size _size = Size.zero;
  bool _hover = false;

  void _updatePointer(Offset local) {
    final RenderObject? ro = context.findRenderObject();
    if (ro is RenderBox && ro.hasSize) _size = ro.size;
    _p = local;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final double w = _size.width <= 0 ? 1 : _size.width;
    final double h = _size.height <= 0 ? 1 : _size.height;
    final double nx = (_p.dx / w).clamp(0.0, 1.0);
    final double ny = (_p.dy / h).clamp(0.0, 1.0);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (e) => setState(() {
        _hover = true;
        _updatePointer(e.localPosition);
      }),
      onHover: (e) => setState(() => _updatePointer(e.localPosition)),
      onExit: (e) => setState(() {
        _hover = false;
        _p = Offset(w / 2, h / 2);
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: _hover ? 1 : 0),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, double t, Widget? _) {
            final double rx = (0.5 - ny) * 2 * widget.maxTilt * t;
            final double ry = (nx - 0.5) * 2 * widget.maxTilt * t;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(rx)
                ..rotateY(ry)
                ..scale(1 + (widget.hoverScale - 1) * t),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: c.accent.withOpacity(0.16 * t),
                      blurRadius: 40 * t + 10,
                      spreadRadius: -6,
                      offset: Offset(0, 18 * t + 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: Stack(
                    children: <Widget>[
                      widget.child,
                      if (widget.glare)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  center: Alignment(nx * 2 - 1, ny * 2 - 1),
                                  radius: 0.9,
                                  colors: <Color>[
                                    Colors.white.withOpacity(0.13 * t),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
