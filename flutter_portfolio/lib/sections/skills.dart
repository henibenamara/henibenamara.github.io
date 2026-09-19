import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/meters.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    final bool tablet = context.isTablet;
    final int columns = mobile ? 1 : (tablet ? 2 : 3);

    return SectionShell(
      eyebrow: 'What I work with',
      title: 'Skills',
      intro:
          'Percentages are honest, not decorative - they animate in from the '
          'values in portfolio_data.dart.',
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints cons) {
          const double gap = 22;
          final double w =
              (cons.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: <Widget>[
              for (int i = 0; i < skillGroups.length; i++)
                SizedBox(
                  width: w,
                  child: Reveal(
                    delay: Duration(milliseconds: 120 * i),
                    dy: 40,
                    child: _SkillCard(group: skillGroups[i], index: i),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillGroup group;
  final int index;
  const _SkillCard({required this.group, required this.index});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    return GlassPanel(
      padding: const EdgeInsets.all(26),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: <Color>[
                  c.accent3.withOpacity(0.25),
                  c.accent2.withOpacity(0.25),
                ],
              ),
              border: Border.all(color: c.border),
            ),
            child: Icon(group.icon, color: c.accent, size: 22),
          ),
          const SizedBox(height: 18),
          Text(group.title, style: t.titleLarge?.copyWith(color: c.text)),
          const SizedBox(height: 22),
          for (int i = 0; i < group.skills.length; i++) ...<Widget>[
            SkillBar(
              name: group.skills[i].name,
              level: group.skills[i].level,
              delay: Duration(milliseconds: 90 * i),
            ),
            if (i != group.skills.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}
