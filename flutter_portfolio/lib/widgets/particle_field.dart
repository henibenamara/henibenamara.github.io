import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';

/// Hand-written constellation field: particles drift, link to their close
/// neighbours and scatter away from the cursor. One Ticker, one CustomPainter,
/// zero packages - this is the "I actually know Flutter" piece.
class ParticleField extends StatefulWidget {
  final int count;
  final double linkDistance;
  final double pointerRadius;
  final Widget? child;

  const ParticleField({
    super.key,
    this.count = 70,
    this.linkDistance = 128,
    this.pointerRadius = 150,
    this.child,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _Particle {
  Offset p;
  Offset v;
  double r;
  _Particle(this.p, this.v, this.r);
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  final List<_Particle> _ps = <_Particle>[];
  final ValueNotifier<int> _repaint = ValueNotifier<int>(0);
  final math.Random _rnd = math.Random(11);
  Ticker? _ticker;
  Duration _last = Duration.zero;
  Size _size = Size.zero;
  Offset? _pointer;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _seed(Size size) {
    _size = size;
    _ps.clear();
    for (int i = 0; i < widget.count; i++) {
      _ps.add(_Particle(
        Offset(_rnd.nextDouble() * size.width, _rnd.nextDouble() * size.height),
        Offset((_rnd.nextDouble() - 0.5) * 26, (_rnd.nextDouble() - 0.5) * 26),
        0.8 + _rnd.nextDouble() * 2.0,
      ));
    }
  }

  void _ensure(Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    if (_ps.isEmpty || (Offset(size.width, size.height) - Offset(_size.width, _size.height)).distance > 40) _seed(size);
  }

  void _onTick(Duration elapsed) {
    final double dt =
        ((elapsed - _last).inMicroseconds / 1000000.0).clamp(0.0, 0.05);
    _last = elapsed;
    if (_ps.isEmpty || _size.width <= 0) return;

    final Offset? m = _pointer;
    for (final _Particle p in _ps) {
      Offset v = p.v;
      if (m != null) {
        final Offset d = p.p - m;
        final double dist = d.distance;
        if (dist < widget.pointerRadius && dist > 0.01) {
          final double force = (1 - dist / widget.pointerRadius) * 90;
          v += (d / dist) * force * dt;
        }
      }
      // gentle drag so the pointer push decays back to the base drift
      v = Offset(v.dx * 0.992, v.dy * 0.992);
      Offset np = p.p + v * dt;
      double vx = v.dx;
      double vy = v.dy;
      if (np.dx < 0 || np.dx > _size.width) {
        vx = -vx;
        np = Offset(np.dx.clamp(0.0, _size.width), np.dy);
      }
      if (np.dy < 0 || np.dy > _size.height) {
        vy = -vy;
        np = Offset(np.dx, np.dy.clamp(0.0, _size.height));
      }
      // keep a minimum drift so the field never freezes
      if (vx.abs() < 3) vx += vx.isNegative ? -1.2 : 1.2;
      if (vy.abs() < 3) vy += vy.isNegative ? -1.2 : 1.2;
      p.p = np;
      p.v = Offset(vx, vy);
    }
    _repaint.value = _repaint.value + 1;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints cons) {
        final Size size = Size(
          cons.maxWidth.isFinite ? cons.maxWidth : 800,
          cons.maxHeight.isFinite ? cons.maxHeight : 600,
        );
        _ensure(size);
        return MouseRegion(
          opaque: false,
          onHover: (e) => _pointer = e.localPosition,
          onExit: (e) => _pointer = null,
          child: CustomPaint(
            painter: _FieldPainter(
              particles: _ps,
              pointer: () => _pointer,
              linkDistance: widget.linkDistance,
              dot: c.accent,
              link: c.accent3,
              pointerLink: c.accent2,
              repaint: _repaint,
            ),
            size: size,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _FieldPainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset? Function() pointer;
  final double linkDistance;
  final Color dot;
  final Color link;
  final Color pointerLink;

  _FieldPainter({
    required this.particles,
    required this.pointer,
    required this.linkDistance,
    required this.dot,
    required this.link,
    required this.pointerLink,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()..strokeWidth = 1;
    final Paint dotPaint = Paint();
    final Offset? m = pointer();

    for (int i = 0; i < particles.length; i++) {
      final _Particle a = particles[i];
      for (int j = i + 1; j < particles.length; j++) {
        final _Particle b = particles[j];
        final double d = (a.p - b.p).distance;
        if (d < linkDistance) {
          final double t = 1 - d / linkDistance;
          linePaint.color = link.withOpacity(0.22 * t);
          canvas.drawLine(a.p, b.p, linePaint);
        }
      }
      if (m != null) {
        final double d = (a.p - m).distance;
        if (d < linkDistance * 1.5) {
          final double t = 1 - d / (linkDistance * 1.5);
          linePaint.color = pointerLink.withOpacity(0.35 * t);
          canvas.drawLine(a.p, m, linePaint);
        }
      }
      dotPaint.color = dot.withOpacity(0.55);
      canvas.drawCircle(a.p, a.r, dotPaint);
    }

    if (m != null) {
      canvas.drawCircle(
        m,
        3.5,
        Paint()..color = pointerLink.withOpacity(0.85),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FieldPainter old) => true;
}
