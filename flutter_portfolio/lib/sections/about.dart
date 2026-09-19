import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/glass.dart';
import '../widgets/logo_mark.dart';
import '../widgets/meters.dart';
import '../widgets/parallax.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onContact;
  const AboutSection({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    return SectionShell(
      eyebrow: 'Get to know me',
      title: 'About',
      intro:
          'A Flutter developer who likes the boring parts too: state that is '
          'easy to reason about, builds that do not break, and UI that holds '
          'up on a three-year-old phone.',
      child: Column(
        children: <Widget>[
          if (mobile)
            Column(
              children: <Widget>[
                const _Portrait(),
                const SizedBox(height: 32),
                _Copy(onContact: onContact),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Parallax(factor: -0.06, child: Reveal(dx: -30, dy: 10, child: _Portrait())),
                ),
                const SizedBox(width: 56),
                Expanded(flex: 6, child: _Copy(onContact: onContact)),
              ],
            ),
          SizedBox(height: mobile ? 48 : 72),
          const _Stats(),
        ],
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait();

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return AspectRatio(
      aspectRatio: 0.86,
      child: Stack(
        children: <Widget>[
          // gradient frame, offset behind the photo
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: 18, top: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: <Color>[c.accent3, c.accent2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 18, bottom: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  decoration: BoxDecoration(
                    color: c.surface,
                    border: Border.all(color: c.border),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  // Swap this Center for:
                  //   Image.asset('assets/images/me.png', fit: BoxFit.cover)
                  // once you drop a photo in assets/images (and enable the
                  // assets block in pubspec.yaml).
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const LogoMark(size: 92),
                        const SizedBox(height: 18),
                        Text(
                          'your photo here',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: c.faint),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'assets/images/me.png',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: c.faint, fontSize: 11),
                        ),
                      ],
                    ),
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

class _Copy extends StatelessWidget {
  final VoidCallback onContact;
  const _Copy({required this.onContact});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    final bool mobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Reveal(
          dy: 24,
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              for (int i = 0; i < highlights.length; i++)
                SizedBox(
                  width: mobile ? double.infinity : 200,
                  child: GlassPanel(
                    padding: const EdgeInsets.all(18),
                    radius: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(highlights[i].icon, color: c.accent, size: 22),
                        const SizedBox(height: 12),
                        Text(
                          highlights[i].title,
                          style: t.titleMedium?.copyWith(color: c.text),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          highlights[i].body,
                          style: t.bodySmall?.copyWith(color: c.faint),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 120),
          child: Text(aboutParagraph1, style: t.bodyLarge?.copyWith(color: c.muted)),
        ),
        const SizedBox(height: 16),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: Text(aboutParagraph2, style: t.bodyLarge?.copyWith(color: c.muted)),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 260),
          child: Row(
            children: <Widget>[
              Icon(Icons.place_outlined, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Text(profile.location, style: t.bodyMedium?.copyWith(color: c.muted)),
              const SizedBox(width: 20),
              Icon(Icons.verified_outlined, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  profile.role,
                  style: t.bodyMedium?.copyWith(color: c.muted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 320),
          child: BrandButton(
            label: "Let's work together",
            icon: Icons.arrow_forward_rounded,
            onPressed: onContact,
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    return GlassPanel(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 20 : 34, vertical: 28),
      radius: 24,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 40,
        runSpacing: 28,
        children: <Widget>[
          for (int i = 0; i < stats.length; i++)
            SizedBox(
              width: mobile ? 130 : 180,
              child: StatCounter(
                value: stats[i].value,
                suffix: stats[i].suffix,
                label: stats[i].label,
                delay: Duration(milliseconds: 90 * i),
              ),
            ),
        ],
      ),
    );
  }
}
