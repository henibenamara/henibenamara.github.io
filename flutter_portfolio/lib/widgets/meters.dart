import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

/// Skill bar that fills (and counts up) the first time it is scrolled into view.
class SkillBar extends StatelessWidget {
  final String name;
  final double level;
  final Duration delay;

  const SkillBar({
    super.key,
    required this.name,
    required this.level,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return OnVisible(
      delay: delay,
      builder: (BuildContext context, bool visible) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: visible ? level : 0),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, double t, Widget? _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: c.text, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${(t * 100).round()}%',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: c.faint),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints cons) {
                    final double w = cons.maxWidth.isFinite ? cons.maxWidth : 200;
                    return Stack(
                      children: <Widget>[
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: c.border,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        Container(
                          height: 6,
                          width: w * t,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: LinearGradient(
                              colors: <Color>[c.accent3, c.accent, c.accent2],
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: c.accent.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Number that counts up when revealed.
class StatCounter extends StatelessWidget {
  final double value;
  final String label;
  final String suffix;
  final Duration delay;

  const StatCounter({
    super.key,
    required this.value,
    required this.label,
    this.suffix = '',
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return OnVisible(
      delay: delay,
      builder: (BuildContext context, bool visible) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: visible ? value : 0),
          duration: const Duration(milliseconds: 1400),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, double t, Widget? _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect b) => LinearGradient(
                    colors: <Color>[c.accent3, c.accent2],
                  ).createShader(b),
                  child: Text(
                    '${t.round()}$suffix',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: c.faint),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
