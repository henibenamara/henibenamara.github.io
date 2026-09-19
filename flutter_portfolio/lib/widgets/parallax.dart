import 'package:flutter/material.dart';
import '../core/scroll_scope.dart';

/// Moves its child against the page scroll. factor < 0 makes it drift up
/// faster than the page (foreground), > 0 lags behind (background).
class Parallax extends StatefulWidget {
  final Widget child;
  final double factor;
  final double max;

  const Parallax({
    super.key,
    required this.child,
    this.factor = 0.12,
    this.max = 140,
  });

  @override
  State<Parallax> createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> {
  ValueNotifier<double>? _offset;
  double _anchor = 0;
  bool _anchored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _offset = PageScroll.maybeOf(context)?.offset;
    if (!_anchored) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _anchor = _offset?.value ?? 0;
        _anchored = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double>? n = _offset;
    if (n == null) return widget.child;
    return ValueListenableBuilder<double>(
      valueListenable: n,
      child: widget.child,
      builder: (BuildContext context, double value, Widget? child) {
        final double d =
            ((value - _anchor) * widget.factor).clamp(-widget.max, widget.max);
        return Transform.translate(offset: Offset(0, d), child: child);
      },
    );
  }
}
