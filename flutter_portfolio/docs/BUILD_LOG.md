# Build log: what was built, why, and what is unverified

Written at handoff so the next session does not have to reverse-engineer the
reasoning.

## Context

The owner had a React portfolio (`../portfolio`, the Egator-style template,
deployed to `henibenamara.github.io/portfolio`) and asked for the same idea
rebuilt in Flutter Web, specifically to demonstrate his Flutter ability, "with
a special touch".

Decisions taken with him up front:

- Content: placeholders centralised in one config file, real details to be
  filled in later.
- Showpiece features: **all four** offered — animated `CustomPainter` hero,
  scroll reveals + parallax, a live Flutter playground, theme switch + 3D tilt
  cards.
- Visual direction: "modern dark, refined" — the old site's spirit, elevated.

## Why zero packages

The site's job is to prove Flutter skill. A portfolio assembled from
`flutter_animate`, `google_fonts` and `url_launcher` proves package selection.
Hand-building the reveal detector, the particle system, the tilt maths and the
link opener proves the thing being claimed — and the footer says so, which
turns a constraint into a talking point.

Cost of the rule, for honesty: fonts load from a CDN instead of the asset
bundle (see risks), and the contact form opens a mail client instead of posting
to an API.

## Build order

1. Read the existing React site to extract the section structure (hero, about,
   experience, portfolio, contact, footer) and keep the same information
   architecture, so the owner recognises it.
2. Scaffolded `pubspec.yaml`, `analysis_options.yaml`, `web/index.html` with
   the HTML splash.
3. `theme/` and `data/` first, so every later widget had tokens and content to
   read.
4. `core/` primitives (responsive, scroll scope, link opening).
5. `widgets/` — the reusable machinery, hardest ones first (reveal, particles,
   tilt).
6. `sections/` — hero through footer, then the playground.
7. `pages/home_page.dart` to assemble, plus nav, progress and back-to-top.
8. Docs and a GitHub Actions deploy workflow.

## Notable implementation choices

| Choice | Why |
| --- | --- |
| `ValueNotifier`s for scroll state, not `setState` | the page would otherwise rebuild the particle field, playground and every glass panel on each scroll frame |
| `OnVisible` measures `RenderBox`, not a visibility package | zero-dependency rule; also gives exact control of the trigger threshold (0.9 of viewport) |
| `ParticleField` repaints via `repaint:` notifier | keeps the animation in the paint phase only — no widget rebuilds at 60fps |
| Manual scroll offset instead of `Scrollable.ensureVisible` | the fixed top bar would cover section headings |
| Painted project mockups instead of screenshots | no image assets to source, and it is another live demonstration of `CustomPainter`; real screenshots are still supported via `Project.image` |
| `ThemeExtension` instead of a global colours file | makes light/dark lerp every custom colour during the toggle |
| Splash in HTML, removed from Dart | a Flutter Web release build shows a blank page until the engine boots; removing it on the first frame is the only accurate moment |
| `Path.combine` for the theme toggle | a real morph instead of swapping two icons |
| Hero content in a `NeverScrollableScrollPhysics` scroll view | clips gracefully on short viewports without stealing the wheel from the page |

## Never compiled — verify these first

This code was written without a Flutter SDK or network access (the environment
had neither), so it has **not** been through `flutter analyze` or a build. It
was checked statically: brace/paren balance per file with a tokenizer, import
path resolution, and cross-file symbol usage against the file that declares
each symbol. Structural correctness is high; API-surface drift is the risk.

Run `flutter analyze` first. If something fails, these are the lines most
likely responsible, with the reasoning that justified each:

1. **`Matrix4..translate(double)`** — `playground.dart`, `_Stage`. The
   vector_math signature takes `dynamic x, [double y, double z]`; a single
   double is valid, but if it complains use `..translate(x, 0.0, 0.0)`.
2. **`dart:js_interop` externals** — `core/links_web.dart`. `@JS('window.open')`
   on a private top-level external with `JSString` params. If the SDK is older
   than 3.0 this whole approach needs `package:js` instead (or just add
   `url_launcher` after asking).
3. **`flutter_bootstrap.js`** — `web/index.html`. Flutter 3.22+ only. On an
   older SDK, regenerate the file with `flutter create . --platforms web` and
   re-add the splash markup.
4. **`ColorScheme.fromSeed(primary:, secondary:, surface:)`** — the override
   parameters are relatively recent; drop them if rejected (the extension
   carries the real colours anyway).
5. **`ThemeData(fontFamilyFallback:)`** — present in modern SDKs; if missing,
   move the fallback into each `TextStyle`.
6. **`Switch(activeColor:)`** — renamed to `activeThumbColor` in newer SDKs;
   it is deprecated, not removed, as of writing.
7. **`withOpacity`** — deprecated in favour of `withValues(alpha:)` on new
   SDKs. `analysis_options.yaml` silences it deliberately for backwards
   compatibility. Migrate only if the owner pins a new SDK.
8. **`num.clamp` returning `double`** — relied on in several places
   (`t.clamp(0.0, 1.0)` assigned to `double`). Dart special-cases this when all
   three operands are `double`; if a line complains, add `.toDouble()`.
9. **`Path.combine`** — `top_bar.dart`. Fine on CanvasKit/Skwasm. If the theme
   toggle renders as a plain disc on some renderer, fall back to two crossfaded
   icons.
10. **`IntrinsicHeight` + `BackdropFilter`** — `experience.dart` rows. All the
    children are proxy boxes so intrinsics pass through, but this is the most
    likely source of a layout assertion if one appears.

## Known limitations

- **Fonts via CSS `<link>`**: whether the CanvasKit renderer picks up
  document-loaded font families is renderer- and version-dependent. If the site
  renders in Roboto, bundle the fonts (`pubspec.yaml` has the block ready and
  `docs/CUSTOMIZATION.md` has the steps). The layout is designed to survive the
  fallback.
- **Performance**: many `BackdropFilter`s (one per `GlassPanel`) plus an O(n²)
  particle loop over ~70 particles. Fine on a laptop; profile before adding
  more glass. If low-end devices stutter, reduce `ParticleField.count` or drop
  the blur to 0 on mobile.
- **No reduced-motion support** — ambient animations run regardless of the OS
  setting.
- **No tests.** A widget test that pumps `PortfolioApp` and asserts the seven
  section keys mount would be a cheap, high-value first test.
- **Content is placeholder.** Employers, project links, phone number and
  percentages are invented scaffolding marked `<-- EDIT`. Do not present them
  as real, and do not invent replacements — ask the owner.
