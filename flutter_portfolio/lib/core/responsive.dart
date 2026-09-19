import 'package:flutter/widgets.dart';

class Breakpoints {
  Breakpoints._();
  static const double mobile = 760;
  static const double tablet = 1100;
  static const double content = 1140; // max content width
}

extension ResponsiveX on BuildContext {
  double get screenW => MediaQuery.of(this).size.width;
  double get screenH => MediaQuery.of(this).size.height;
  bool get isMobile => screenW < Breakpoints.mobile;
  bool get isTablet => screenW >= Breakpoints.mobile && screenW < Breakpoints.tablet;
  bool get isDesktop => screenW >= Breakpoints.tablet;

  /// Pick a value per breakpoint without writing three ternaries every time.
  T pick<T>({required T mobile, T? tablet, required T desktop}) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? desktop;
    return desktop;
  }
}
