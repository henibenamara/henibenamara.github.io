import 'package:flutter/widgets.dart';

/// Broadcasts the page scroll offset to every descendant.
/// Reveal / Parallax / NavRail all read from here instead of each one
/// installing its own listener on the ScrollController.
class PageScroll extends InheritedWidget {
  final ValueNotifier<double> offset;
  final ScrollController controller;

  const PageScroll({
    super.key,
    required this.offset,
    required this.controller,
    required super.child,
  });

  static PageScroll? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PageScroll>();

  @override
  bool updateShouldNotify(PageScroll oldWidget) =>
      oldWidget.offset != offset || oldWidget.controller != controller;
}
