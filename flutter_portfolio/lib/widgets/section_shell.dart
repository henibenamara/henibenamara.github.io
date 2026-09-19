import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../theme/app_theme.dart';
import 'glass.dart';
import 'reveal.dart';

/// Consistent section wrapper: eyebrow, gradient rule, big title, content.
class SectionShell extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? intro;
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final bool centerHeader;

  const SectionShell({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.child,
    this.intro,
    this.maxWidth = Breakpoints.content,
    this.padding,
    this.centerHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    final bool mobile = context.isMobile;

    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: mobile ? 20 : 40,
            vertical: mobile ? 64 : 110,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: centerHeader
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: <Widget>[
              Reveal(
                dy: 24,
                child: Column(
                  crossAxisAlignment: centerHeader
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      eyebrow.toUpperCase(),
                      style: t.labelMedium?.copyWith(color: c.accent),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: centerHeader ? TextAlign.center : TextAlign.start,
                      style: (mobile ? t.headlineMedium : t.displaySmall)
                          ?.copyWith(color: c.text),
                    ),
                    const SizedBox(height: 16),
                    const GradientRule(),
                    if (intro != null) ...<Widget>[
                      const SizedBox(height: 18),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Text(
                          intro!,
                          textAlign:
                              centerHeader ? TextAlign.center : TextAlign.start,
                          style: t.bodyMedium?.copyWith(color: c.muted),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: mobile ? 36 : 56),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
