import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/glass.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    return SectionShell(
      eyebrow: 'Where I have been',
      title: 'Journey',
      intro: 'From ERP modules in Sfax to multi-tenant platforms for 20+ companies.',
      child: Column(
        children: <Widget>[
          for (int i = 0; i < timeline.length; i++)
            _TimelineRow(
              entry: timeline[i],
              first: i == 0,
              last: i == timeline.length - 1,
              mobile: mobile,
              index: i,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineEntry entry;
  final bool first;
  final bool last;
  final bool mobile;
  final int index;

  const _TimelineRow({
    required this.entry,
    required this.first,
    required this.last,
    required this.mobile,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!mobile)
            SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 22, right: 22),
                child: Reveal(
                  dx: -18,
                  delay: Duration(milliseconds: 80 * index),
                  child: Text(
                    entry.period,
                    textAlign: TextAlign.right,
                    style: t.bodyMedium?.copyWith(
                      color: c.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          // rail
          SizedBox(
            width: 40,
            child: Column(
              children: <Widget>[
                Container(
                  width: 2,
                  height: 22,
                  color: first ? Colors.transparent : c.border,
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[c.accent3, c.accent2],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: c.accent.withOpacity(0.45),
                        blurRadius: 14,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: last ? Colors.transparent : c.border,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 26),
              child: Reveal(
                dx: 26,
                delay: Duration(milliseconds: 80 * index),
                child: GlassPanel(
                  radius: 20,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (mobile) ...<Widget>[
                        Text(
                          entry.period,
                          style: t.bodySmall?.copyWith(
                            color: c.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(entry.role,
                          style: t.titleLarge?.copyWith(color: c.text)),
                      const SizedBox(height: 4),
                      Text(entry.org,
                          style: t.bodySmall?.copyWith(color: c.faint)),
                      const SizedBox(height: 12),
                      Text(entry.body,
                          style: t.bodyMedium?.copyWith(color: c.muted)),
                      if (entry.tags.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            for (final String tag in entry.tags) TagChip(tag),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
