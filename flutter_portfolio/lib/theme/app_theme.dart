import 'package:flutter/material.dart';

/// Brand colours + surfaces, exposed as a ThemeExtension so that every widget
/// reads the same tokens and both themes animate between each other.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color accent;
  final Color accent2;
  final Color accent3;
  final Color bg;
  final Color bgAlt;
  final Color surface;
  final Color glass;
  final Color border;
  final Color text;
  final Color muted;
  final Color faint;

  const AppColors({
    required this.accent,
    required this.accent2,
    required this.accent3,
    required this.bg,
    required this.bgAlt,
    required this.surface,
    required this.glass,
    required this.border,
    required this.text,
    required this.muted,
    required this.faint,
  });

  static const AppColors dark = AppColors(
    accent: Color(0xFF4DB5FF),
    accent2: Color(0xFF8B5CF6),
    accent3: Color(0xFF22D3EE),
    bg: Color(0xFF07070F),
    bgAlt: Color(0xFF0C0C18),
    surface: Color(0xFF12121F),
    glass: Color(0x14FFFFFF),
    border: Color(0x1FFFFFFF),
    text: Color(0xFFF2F4FA),
    muted: Color(0xB3E8ECF5),
    faint: Color(0x66E8ECF5),
  );

  static const AppColors light = AppColors(
    accent: Color(0xFF0B7FD4),
    accent2: Color(0xFF6D3BF0),
    accent3: Color(0xFF0891B2),
    bg: Color(0xFFF7F8FC),
    bgAlt: Color(0xFFEEF1F8),
    surface: Color(0xFFFFFFFF),
    glass: Color(0x0A0B1020),
    border: Color(0x1A0B1020),
    text: Color(0xFF0B1020),
    muted: Color(0xB30B1020),
    faint: Color(0x660B1020),
  );

  LinearGradient get brand => LinearGradient(
        colors: <Color>[accent3, accent, accent2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  AppColors copyWith({
    Color? accent,
    Color? accent2,
    Color? accent3,
    Color? bg,
    Color? bgAlt,
    Color? surface,
    Color? glass,
    Color? border,
    Color? text,
    Color? muted,
    Color? faint,
  }) {
    return AppColors(
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      bg: bg ?? this.bg,
      bgAlt: bgAlt ?? this.bgAlt,
      surface: surface ?? this.surface,
      glass: glass ?? this.glass,
      border: border ?? this.border,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      faint: faint ?? this.faint,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      accent: c(accent, other.accent),
      accent2: c(accent2, other.accent2),
      accent3: c(accent3, other.accent3),
      bg: c(bg, other.bg),
      bgAlt: c(bgAlt, other.bgAlt),
      surface: c(surface, other.surface),
      glass: c(glass, other.glass),
      border: c(border, other.border),
      text: c(text, other.text),
      muted: c(muted, other.muted),
      faint: c(faint, other.faint),
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get c => Theme.of(this).extension<AppColors>() ?? AppColors.dark;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class AppTheme {
  AppTheme._();

  static const String display = 'Space Grotesk';
  static const String body = 'Inter';
  static const List<String> fallback = <String>[
    'Inter',
    'Roboto',
    'Segoe UI',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final TextTheme text = _text(c);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: body,
      fontFamilyFallback: fallback,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      splashFactory: InkRipple.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.accent,
        brightness: brightness,
        primary: c.accent,
        secondary: c.accent2,
        surface: c.surface,
      ),
      textTheme: text,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.accent,
        selectionColor: c.accent.withOpacity(0.28),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.accent,
        inactiveTrackColor: c.border,
        thumbColor: c.accent,
        overlayColor: c.accent.withOpacity(0.14),
        trackHeight: 3,
      ),
      extensions: <ThemeExtension<dynamic>>[c],
    );
  }

  static TextTheme _text(AppColors c) {
    TextStyle d(double size, FontWeight w, {double h = 1.12, double ls = -0.5}) =>
        TextStyle(
          fontFamily: display,
          fontFamilyFallback: fallback,
          fontSize: size,
          fontWeight: w,
          height: h,
          letterSpacing: ls,
          color: c.text,
        );
    TextStyle b(double size, FontWeight w, {double h = 1.6, double ls = 0}) =>
        TextStyle(
          fontFamily: body,
          fontFamilyFallback: fallback,
          fontSize: size,
          fontWeight: w,
          height: h,
          letterSpacing: ls,
          color: c.muted,
        );

    return TextTheme(
      displayLarge: d(72, FontWeight.w700, ls: -2.4),
      displayMedium: d(56, FontWeight.w700, ls: -1.8),
      displaySmall: d(40, FontWeight.w600, ls: -1.2),
      headlineMedium: d(32, FontWeight.w600, ls: -0.8),
      headlineSmall: d(24, FontWeight.w600, ls: -0.4),
      titleLarge: d(20, FontWeight.w600, h: 1.3, ls: -0.2),
      titleMedium: d(16, FontWeight.w600, h: 1.3, ls: 0),
      bodyLarge: b(17, FontWeight.w400),
      bodyMedium: b(15, FontWeight.w400),
      bodySmall: b(13.5, FontWeight.w400, h: 1.5),
      labelLarge: b(13, FontWeight.w600, h: 1.2, ls: 0.4),
      labelMedium: b(12, FontWeight.w500, h: 1.2, ls: 1.6),
    );
  }
}
