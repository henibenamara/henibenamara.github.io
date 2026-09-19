import 'package:flutter/material.dart';
import '../core/scroll_scope.dart';

/// Fires once when the widget scrolls into the viewport.
/// No packages: it measures its own RenderBox against the viewport height
/// every time the page scroll offset changes.
class OnVisible extends StatefulWidget {
  final Widget Function(BuildContext context, bool visible) builder;
  final Duration delay;
  final double threshold; // fraction of the viewport height
  final Widget? child;

  const OnVisible({
    super.key,
    required this.builder,
    this.delay = Duration.zero,
    this.threshold = 0.9,
    this.child,
  });

  @override
  State<OnVisible> createState() => _OnVisibleState();
}

class _OnVisibleState extends State<OnVisible> {
  ValueNotifier<double>? _offset;
  bool _visible = false;
  bool _armed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ValueNotifier<double>? n = PageScroll.maybeOf(context)?.offset;
    if (!identical(n, _offset)) {
      _offset?.removeListener(_check);
      _offset = n;
      _offset?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_armed || !mounted) return;
    final RenderObject? ro = context.findRenderObject();
    if (ro is! RenderBox || !ro.hasSize || !ro.attached) return;
    final double top = ro.localToGlobal(Offset.zero).dy;
    final double h = MediaQuery.of(context).size.height;
    if (top < h * widget.threshold && top > -ro.size.height) {
      _armed = true;
      if (widget.delay == Duration.zero) {
        setState(() => _visible = true);
      } else {
        Future<void>.delayed(widget.delay, () {
          if (mounted) setState(() => _visible = true);
        });
      }
    }
  }

  @override
  void dispose() {
    _offset?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _visible);
}

/// Fade + travel entrance driven by [OnVisible].
class Reveal extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double dy;
  final double dx;
  final double scaleFrom;
  final double threshold;

  const Reveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 720),
    this.delay = Duration.zero,
    this.dy = 38,
    this.dx = 0,
    this.scaleFrom = 1.0,
    this.threshold = 0.92,
  });

  @override
  Widget build(BuildContext context) {
    return OnVisible(
      delay: delay,
      threshold: threshold,
      child: child,
      builder: (BuildContext context, bool visible) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: visible ? 1 : 0),
          duration: duration,
          curve: Curves.easeOutCubic,
          child: child,
          builder: (BuildContext context, double t, Widget? c) {
            final double inv = 1 - t;
            return Opacity(
              opacity: t.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(dx * inv, dy * inv),
                child: Transform.scale(
                  scale: scaleFrom + (1 - scaleFrom) * t,
                  child: c,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Staggers a list of children with an incremental delay.
class RevealStagger extends StatelessWidget {
  final List<Widget> children;
  final Duration step;
  final Duration start;
  final double dy;
  final Axis direction;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const RevealStagger({
    super.key,
    required this.children,
    this.step = const Duration(milliseconds: 90),
    this.start = Duration.zero,
    this.dy = 30,
    this.direction = Axis.vertical,
    this.spacing = 0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(Reveal(
        delay: start + step * i,
        dy: dy,
        child: children[i],
      ));
      if (spacing > 0 && i != children.length - 1) {
        items.add(direction == Axis.vertical
            ? SizedBox(height: spacing)
            : SizedBox(width: spacing));
      }
    }
    return direction == Axis.vertical
        ? Column(crossAxisAlignment: crossAxisAlignment, children: items)
        : Row(crossAxisAlignment: crossAxisAlignment, children: items);
  }
}
