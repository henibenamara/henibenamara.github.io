import 'package:flutter/material.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/project_preview.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';
import '../widgets/tilt_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    final int columns = mobile ? 1 : 2;

    return SectionShell(
      eyebrow: 'Recent work',
      title: 'Projects',
      intro:
          'Every preview below is painted at runtime by a CustomPainter - the '
          'cards themselves tilt in 3D toward your cursor.',
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints cons) {
          const double gap = 26;
          final double w = (cons.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: <Widget>[
              for (int i = 0; i < projects.length; i++)
                SizedBox(
                  width: w,
                  child: Reveal(
                    delay: Duration(milliseconds: 110 * (i % columns)),
                    dy: 46,
                    child: _ProjectCard(project: projects[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;

    return TiltCard(
      radius: 26,
      maxTilt: 0.08,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProjectPreview(project: project),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(project.title, style: t.titleLarge?.copyWith(color: c.text)),
                  const SizedBox(height: 4),
                  Text(
                    project.subtitle,
                    style: t.bodySmall?.copyWith(color: c.accent),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    project.description,
                    style: t.bodyMedium?.copyWith(color: c.muted),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final String tag in project.tags) TagChip(tag),
                    ],
                  ),
                  if (project.codeUrl.isNotEmpty ||
                      project.liveUrl.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 22),
                    Row(
                      children: <Widget>[
                        if (project.codeUrl.isNotEmpty)
                          GhostButton(
                            label: 'Code',
                            icon: Icons.code_rounded,
                            dense: true,
                            onPressed: () => openLink(project.codeUrl),
                          ),
                        if (project.codeUrl.isNotEmpty &&
                            project.liveUrl.isNotEmpty)
                          const SizedBox(width: 12),
                        if (project.liveUrl.isNotEmpty)
                          BrandButton(
                            label: 'Live demo',
                            icon: Icons.open_in_new_rounded,
                            dense: true,
                            onPressed: () => openLink(project.liveUrl),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
