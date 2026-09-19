import 'package:flutter/material.dart';
import '../core/sections.dart';
import '../theme/app_theme.dart';

/// Floating dot navigation on the right edge (desktop only).
class NavRail extends StatelessWidget {
  final List<SectionRef> sections;
  final ValueNotifier<int> active;
  final void Function(int index) onSelect;

  const NavRail({
    super.key,
    required this.sections,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: active,
      builder: (BuildContext context, int index, Widget? _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < sections.length; i++)
              _Dot(
                label: sections[i].label,
                icon: sections[i].icon,
                selected: i == index,
                onTap: () => onSelect(i),
              ),
          ],
        );
      },
    );
  }
}

class _Dot extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _Dot({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final bool on = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _hover ? 1 : 0,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: c.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: c.border),
                  ),
                  child: Text(
                    widget.label,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.text, fontSize: 12),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                width: on ? 34 : 30,
                height: on ? 34 : 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: on
                      ? LinearGradient(colors: <Color>[c.accent3, c.accent2])
                      : null,
                  color: on ? null : (_hover ? c.glass : Colors.transparent),
                  border: Border.all(
                    color: on ? Colors.transparent : c.border,
                  ),
                  boxShadow: on
                      ? <BoxShadow>[
                          BoxShadow(
                            color: c.accent.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  size: on ? 17 : 15,
                  color: on ? Colors.white : c.faint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
