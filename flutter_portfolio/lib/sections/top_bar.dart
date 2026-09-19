import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../core/sections.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/logo_mark.dart';

class TopBar extends StatelessWidget {
  final List<SectionRef> sections;
  final ValueNotifier<int> active;
  final ValueNotifier<double> scrolled;
  final void Function(int index) onSelect;
  final VoidCallback onToggleTheme;
  final VoidCallback onMenu;
  final bool isDark;

  const TopBar({
    super.key,
    required this.sections,
    required this.active,
    required this.scrolled,
    required this.onSelect,
    required this.onToggleTheme,
    required this.onMenu,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final bool mobile = context.isMobile;

    return ValueListenableBuilder<double>(
      valueListenable: scrolled,
      builder: (BuildContext context, double offset, Widget? _) {
        final double t = (offset / 120).clamp(0.0, 1.0);
        return ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 16 * t, sigmaY: 16 * t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 18 : 34,
                vertical: 14 - 3 * t,
              ),
              decoration: BoxDecoration(
                color: c.bg.withOpacity(0.55 * t),
                border: Border(
                  bottom: BorderSide(color: c.border.withOpacity(t), width: 1),
                ),
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => onSelect(0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const LogoMark(size: 36),
                          const SizedBox(width: 12),
                          if (!mobile)
                            Text(
                              'heni.dev',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: c.text),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!mobile)
                    ValueListenableBuilder<int>(
                      valueListenable: active,
                      builder: (BuildContext context, int index, Widget? _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            for (int i = 0; i < sections.length; i++)
                              _NavLink(
                                label: sections[i].label,
                                selected: index == i,
                                onTap: () => onSelect(i),
                              ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(width: 12),
                  _ThemeToggle(isDark: isDark, onTap: onToggleTheme),
                  if (!mobile) ...<Widget>[
                    const SizedBox(width: 12),
                    BrandButton(
                      label: 'Hire me',
                      dense: true,
                      onPressed: () => onSelect(sections.length - 1),
                    ),
                  ] else ...<Widget>[
                    const SizedBox(width: 8),
                    IconPill(
                      icon: Icons.menu_rounded,
                      onPressed: onMenu,
                      size: 42,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final bool on = widget.selected || _hover;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: on ? c.text : c.faint,
                      fontWeight: on ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14.5,
                    ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                height: 2,
                width: widget.selected ? 20 : (_hover ? 12 : 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: <Color>[c.accent3, c.accent2],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sun / moon morph drawn with a clipped circle, not two icons.
class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ThemeToggle({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Tooltip(
      message: isDark ? 'Switch to light' : 'Switch to dark',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.glass,
              border: Border.all(color: c.border),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: isDark ? 1 : 0),
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              builder: (BuildContext context, double t, Widget? _) {
                return Transform.rotate(
                  angle: t * 3.14159,
                  child: CustomPaint(
                    painter: _SunMoonPainter(t: t, color: c.accent),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SunMoonPainter extends CustomPainter {
  final double t; // 0 = sun, 1 = moon
  final Color color;
  _SunMoonPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double r = size.shortestSide * 0.21;
    final Paint p = Paint()..color = color;

    // rays fade out as the moon takes over
    if (t < 0.98) {
      final Paint ray = Paint()
        ..color = color.withOpacity((1 - t).clamp(0.0, 1.0))
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 8; i++) {
        final double a = i * 3.14159 / 4;
        final Offset dir = Offset((r + 4) * _cos(a), (r + 4) * _sin(a));
        final Offset dir2 = Offset((r + 8.5) * _cos(a), (r + 8.5) * _sin(a));
        canvas.drawLine(center + dir, center + dir2, ray);
      }
    }

    // sun disc, with a bite taken out of it to become a crescent
    final Path disc = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r));
    if (t > 0.02) {
      final Path bite = Path()
        ..addOval(Rect.fromCircle(
          center: center + Offset(r * 0.75 * t, -r * 0.35 * t),
          radius: r * (0.85 + 0.15 * t),
        ));
      canvas.drawPath(Path.combine(PathOperation.difference, disc, bite), p);
    } else {
      canvas.drawPath(disc, p);
    }
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant _SunMoonPainter old) =>
      old.t != t || old.color != color;
}
