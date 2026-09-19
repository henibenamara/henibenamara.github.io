import 'package:flutter/material.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../core/scroll_scope.dart';
import '../core/sections.dart';
import '../sections/about.dart';
import '../sections/contact.dart';
import '../sections/experience.dart';
import '../sections/footer.dart';
import '../sections/hero.dart';
import '../sections/nav_rail.dart';
import '../sections/playground.dart';
import '../sections/projects.dart';
import '../sections/skills.dart';
import '../sections/top_bar.dart';
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _sc = ScrollController();
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);
  final ValueNotifier<int> _active = ValueNotifier<int>(0);
  final List<SectionRef> _sections = buildSections();

  @override
  void initState() {
    super.initState();
    _sc.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hideSplash();
      _offset.value = 0;
    });
  }

  @override
  void dispose() {
    _sc.removeListener(_onScroll);
    _sc.dispose();
    _offset.dispose();
    _progress.dispose();
    _active.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_sc.hasClients) return;
    final double o = _sc.offset;
    _offset.value = o;
    final double max = _sc.position.maxScrollExtent;
    _progress.value = max <= 0 ? 0 : (o / max).clamp(0.0, 1.0);

    int current = 0;
    for (int i = 0; i < _sections.length; i++) {
      final BuildContext? ctx = _sections[i].key.currentContext;
      if (ctx == null) continue;
      final RenderObject? ro = ctx.findRenderObject();
      if (ro is! RenderBox || !ro.attached) continue;
      final double top = ro.localToGlobal(Offset.zero).dy;
      if (top <= 160) current = i;
    }
    if (_active.value != current) _active.value = current;
  }

  void _goTo(int index) {
    final BuildContext? ctx = _sections[index].key.currentContext;
    if (ctx == null || !_sc.hasClients) return;
    final RenderObject? ro = ctx.findRenderObject();
    if (ro is! RenderBox) return;
    final double delta = ro.localToGlobal(Offset.zero).dy;
    final double target = (_sc.offset + delta - (index == 0 ? 0 : 84))
        .clamp(0.0, _sc.position.maxScrollExtent);
    _sc.animateTo(
      target,
      duration: const Duration(milliseconds: 780),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openMenu() {
    final AppColors c = context.c;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              for (int i = 0; i < _sections.length; i++)
                ListTile(
                  leading: Icon(_sections[i].icon, color: c.accent, size: 20),
                  title: Text(
                    _sections[i].label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: c.text),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Future<void>.delayed(
                      const Duration(milliseconds: 120),
                      () => _goTo(i),
                    );
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final bool mobile = context.isMobile;

    return Scaffold(
      body: PageScroll(
        offset: _offset,
        controller: _sc,
        child: Stack(
          children: <Widget>[
            // page background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[c.bg, c.bgAlt, c.bg],
                  ),
                ),
              ),
            ),

            // content
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _sc,
                child: Column(
                  children: <Widget>[
                    KeyedSubtree(
                      key: _sections[0].key,
                      child: HeroSection(
                        onWork: () => _goTo(3),
                        onContact: () => _goTo(6),
                        onScrollCue: () => _goTo(1),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sections[1].key,
                      child: AboutSection(onContact: () => _goTo(6)),
                    ),
                    KeyedSubtree(
                      key: _sections[2].key,
                      child: const SkillsSection(),
                    ),
                    KeyedSubtree(
                      key: _sections[3].key,
                      child: const ProjectsSection(),
                    ),
                    KeyedSubtree(
                      key: _sections[4].key,
                      child: const PlaygroundSection(),
                    ),
                    KeyedSubtree(
                      key: _sections[5].key,
                      child: const ExperienceSection(),
                    ),
                    KeyedSubtree(
                      key: _sections[6].key,
                      child: const ContactSection(),
                    ),
                    FooterSection(sections: _sections, onSelect: _goTo),
                  ],
                ),
              ),
            ),

            // right hand dot navigation
            if (!mobile)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: NavRail(
                    sections: _sections,
                    active: _active,
                    onSelect: _goTo,
                  ),
                ),
              ),

            // top bar + reading progress
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  TopBar(
                    sections: _sections,
                    active: _active,
                    scrolled: _offset,
                    onSelect: _goTo,
                    onToggleTheme: widget.onToggleTheme,
                    onMenu: _openMenu,
                    isDark: widget.isDark,
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _progress,
                    builder: (BuildContext context, double p, Widget? _) {
                      return SizedBox(
                        height: 2.5,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: p.clamp(0.0, 1.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[c.accent3, c.accent, c.accent2],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // back to top
            Positioned(
              right: mobile ? 18 : 84,
              bottom: 24,
              child: ValueListenableBuilder<double>(
                valueListenable: _offset,
                builder: (BuildContext context, double o, Widget? child) {
                  final bool show = o > 600;
                  return AnimatedSlide(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    offset: show ? Offset.zero : const Offset(0, 1.4),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 280),
                      opacity: show ? 1 : 0,
                      child: child,
                    ),
                  );
                },
                child: _BackToTop(onTap: () => _goTo(0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackToTop extends StatelessWidget {
  final VoidCallback onTap;
  const _BackToTop({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Tooltip(
      message: 'Back to top',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: <Color>[c.accent3, c.accent2]),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: c.accent.withOpacity(0.4),
                  blurRadius: 22,
                  spreadRadius: -4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_upward_rounded,
                color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
