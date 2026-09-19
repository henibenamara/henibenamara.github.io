import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/gradient_text.dart';
import '../widgets/parallax.dart';
import '../widgets/particle_field.dart';
import '../widgets/reveal.dart';
import '../widgets/typewriter.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onContact;
  final VoidCallback onWork;
  final VoidCallback onScrollCue;

  const HeroSection({
    super.key,
    required this.onContact,
    required this.onWork,
    required this.onScrollCue,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    final bool mobile = context.isMobile;
    final double h = context.screenH;

    // never shorter than the content needs, so nothing gets clipped on a
    // small laptop or a phone in landscape
    return SizedBox(
      height: math.max(h, mobile ? 800.0 : 680.0),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. living background
          const Positioned.fill(child: ParticleField()),

          // 2. colour glows, drifting slower than the page
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -160,
                    top: -120,
                    child: Parallax(
                      factor: 0.22,
                      child: _Glow(color: c.accent, size: 520),
                    ),
                  ),
                  Positioned(
                    right: -180,
                    bottom: -140,
                    child: Parallax(
                      factor: -0.16,
                      child: _Glow(color: c.accent2, size: 560),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. content
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: mobile ? 22 : 40,
                vertical: 100,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Breakpoints.content),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Reveal(delay: Duration(milliseconds: 120), child: _AvailabilityPill()),
                    const SizedBox(height: 26),
                    Reveal(
                      delay: const Duration(milliseconds: 220),
                      child: Text(
                        profile.greeting,
                        style: t.titleLarge?.copyWith(color: c.muted),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Reveal(
                      delay: const Duration(milliseconds: 300),
                      dy: 26,
                      child: GradientText(
                        profile.name,
                        animate: true,
                        align: TextAlign.center,
                        style: (mobile ? t.displaySmall : t.displayLarge)
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Reveal(
                      delay: const Duration(milliseconds: 380),
                      child: Typewriter(
                        words: profile.rotatingRoles,
                        style: (mobile ? t.titleLarge : t.headlineSmall)
                            ?.copyWith(color: c.text),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Reveal(
                      delay: const Duration(milliseconds: 460),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Text(
                          profile.tagline,
                          textAlign: TextAlign.center,
                          style: t.bodyLarge?.copyWith(color: c.muted),
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Reveal(
                      delay: const Duration(milliseconds: 540),
                      child: Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          BrandButton(
                            label: 'See my work',
                            icon: Icons.arrow_downward_rounded,
                            onPressed: onWork,
                          ),
                          GhostButton(
                            label: 'Download CV',
                            icon: Icons.file_download_outlined,
                            onPressed: () => openLink(profile.cvUrl),
                          ),
                          GhostButton(
                            label: "Let's talk",
                            icon: Icons.chat_bubble_outline_rounded,
                            onPressed: onContact,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Reveal(
                      delay: const Duration(milliseconds: 620),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconPill(
                            icon: Icons.code_rounded,
                            tooltip: 'GitHub',
                            onPressed: () => openLink(profile.github),
                          ),
                          const SizedBox(width: 12),
                          IconPill(
                            icon: Icons.business_center_outlined,
                            tooltip: 'LinkedIn',
                            onPressed: () => openLink(profile.linkedin),
                          ),
                          const SizedBox(width: 12),
                          IconPill(
                            icon: Icons.mail_outline_rounded,
                            tooltip: profile.email,
                            onPressed: () => openLink('mailto:${profile.email}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. scroll cue
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: Center(child: _ScrollCue(onTap: onScrollCue)),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color.withOpacity(0.22), color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _AvailabilityPill extends StatefulWidget {
  const _AvailabilityPill();

  @override
  State<_AvailabilityPill> createState() => _AvailabilityPillState();
}

class _AvailabilityPillState extends State<_AvailabilityPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: c.glass,
        border: Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedBuilder(
            animation: _c,
            builder: (BuildContext context, Widget? _) {
              final double t = _c.value;
              return SizedBox(
                width: 14,
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: (1 - t).clamp(0.0, 1.0),
                      child: Container(
                        width: 6 + 8 * t,
                        height: 6 + 8 * t,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF34D399).withOpacity(0.5),
                        ),
                      ),
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34D399),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 9),
          Text(
            profile.availability,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.muted, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ScrollCue extends StatefulWidget {
  final VoidCallback onTap;
  const _ScrollCue({required this.onTap});

  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 26,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.border),
              ),
              child: AnimatedBuilder(
                animation: _c,
                builder: (BuildContext context, Widget? _) {
                  final double t = Curves.easeInOut.transform(
                    (_c.value * 2).clamp(0.0, 1.0),
                  );
                  return Align(
                    alignment: Alignment(0, -0.6 + 1.2 * t),
                    child: Opacity(
                      opacity: (1 - t * 0.7).clamp(0.0, 1.0),
                      child: Container(
                        width: 4,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.accent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'scroll',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: c.faint, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
