import 'package:flutter/material.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../core/sections.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/logo_mark.dart';

class FooterSection extends StatelessWidget {
  final List<SectionRef> sections;
  final void Function(int index) onSelect;

  const FooterSection({
    super.key,
    required this.sections,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    final bool mobile = context.isMobile;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 40,
        vertical: 46,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[c.bg, c.bgAlt],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.content),
          child: Column(
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 26,
                spacing: 26,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: mobile ? double.infinity : 320,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const LogoMark(size: 42),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(profile.name,
                                  style: t.titleMedium?.copyWith(color: c.text)),
                              const SizedBox(height: 2),
                              Text(profile.role,
                                  style: t.bodySmall?.copyWith(color: c.faint)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 18,
                    runSpacing: 10,
                    children: <Widget>[
                      for (int i = 0; i < sections.length; i++)
                        _FooterLink(
                          label: sections[i].label,
                          onTap: () => onSelect(i),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconPill(
                        icon: Icons.code_rounded,
                        tooltip: 'GitHub',
                        size: 40,
                        onPressed: () => openLink(profile.github),
                      ),
                      const SizedBox(width: 10),
                      IconPill(
                        icon: Icons.business_center_outlined,
                        tooltip: 'LinkedIn',
                        size: 40,
                        onPressed: () => openLink(profile.linkedin),
                      ),
                      const SizedBox(width: 10),
                      IconPill(
                        icon: Icons.facebook_outlined,
                        tooltip: 'Facebook',
                        size: 40,
                        onPressed: () => openLink(profile.facebook),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 34),
              Divider(color: c.border, height: 1),
              const SizedBox(height: 22),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 18,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    '(c) ${DateTime.now().year} ${profile.name}. All rights reserved.',
                    style: t.bodySmall?.copyWith(color: c.faint),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: c.glass,
                      border: Border.all(color: c.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.flutter_dash, size: 16, color: c.accent),
                        const SizedBox(width: 8),
                        Text(
                          'Built with Flutter Web - 100% Dart, zero packages',
                          style: t.bodySmall?.copyWith(
                            color: c.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: _hover ? c.accent : c.faint,
                fontSize: 14,
              ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
