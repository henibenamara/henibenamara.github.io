# CLAUDE.md

Context for Claude Code working in this repository. Read this before touching
anything; the deeper docs live in `docs/`.

## What this project is

A personal portfolio website for **Heni Ben Amara**, a full-time Flutter
developer, written entirely in **Dart / Flutter Web**. It replaces an older
React portfolio (which still lives at `../portfolio` and must not be modified).

The site is itself the work sample: it exists to prove Flutter skill to
recruiters and clients. That goal outranks convenience, and it produces the
project's single hardest rule below.

## Prime directive: zero third-party packages

`pubspec.yaml` has exactly one dependency: the Flutter SDK. No `url_launcher`,
no `google_fonts`, no `provider`, no `visibility_detector`, no lint package.
Every effect is hand-built on SDK primitives. The footer of the live site
states this out loud ("100% Dart, zero packages").

**Do not add a dependency to solve a problem.** If a task seems to need one,
implement it with SDK primitives, or stop and ask the user first. Precedents
already in the codebase:

| Would normally use | What this repo does instead |
| --- | --- |
| `url_launcher` | `dart:js_interop` `window.open`, behind a conditional export (`lib/core/links.dart`) |
| `visibility_detector` | `OnVisible` measures its own `RenderBox` against the viewport (`lib/widgets/reveal.dart`) |
| `google_fonts` | `<link>` in `web/index.html` + `fontFamilyFallback`, with an optional bundled-font path in `pubspec.yaml` |
| `flutter_animate` | `AnimationController`, `TweenAnimationBuilder`, implicit animations |
| image assets for mockups | `CustomPainter` draws each project thumbnail at runtime |
| `flutter_lints` | a small hand-written `analysis_options.yaml` |

## Commands

```bash
flutter pub get
flutter run -d chrome          # dev
flutter analyze                # static check
flutter build web --release    # output in build/web
```

Requires Flutter **3.22+** — `web/index.html` uses the `flutter_bootstrap.js`
loader introduced in that version.

## Status: never compiled

The code was written in an environment with no Flutter SDK and no network, so
it has **never been run through `flutter analyze` or `flutter build`**. It was
verified statically only (brace balance, import resolution, cross-file symbol
use).

**First task in a fresh session: run `flutter analyze` and fix what it
reports.** Expect small things — a renamed parameter, a deprecation, an unused
import — not structural problems. `docs/BUILD_LOG.md` lists the specific API
calls that carry the most risk, with the reasoning behind each one, so you can
check those first instead of reading everything.

## Architecture in one screen

```
lib/
  main.dart              runApp(PortfolioApp)
  app.dart               MaterialApp, ThemeMode state, drag-to-scroll behaviour
  data/portfolio_data.dart   ALL user-facing content (the only file the owner edits)
  theme/app_theme.dart   AppColors ThemeExtension + light/dark ThemeData + type scale
  core/
    links.dart           conditional export -> links_web.dart | links_stub.dart
    responsive.dart      Breakpoints + BuildContext extension (isMobile/isTablet/pick)
    scroll_scope.dart    PageScroll InheritedWidget: shares scroll offset with the page
    sections.dart        SectionRef list (label, icon, GlobalKey) used by nav + footer
  widgets/               reusable, content-agnostic pieces
  sections/              one file per page section, plus top_bar and nav_rail
  pages/home_page.dart   assembles sections, owns ScrollController + scroll spy
web/index.html           animated splash, removed from Dart on first frame
```

Full file-by-file breakdown: `docs/ARCHITECTURE.md`.

## Conventions this codebase follows

Match these when you add code; they are consistent across every file.

- **Colours come from `context.c`** (the `AppColorsX` extension in
  `theme/app_theme.dart`), never from `Colors.*` literals except pure
  black/white overlays and a few fixed status colours (the traffic-light dots,
  the green availability dot, the form error red).
- **Every widget starts with** `final AppColors c = context.c;` and, when it
  needs text styles, `final TextTheme t = Theme.of(context).textTheme;`.
- **Responsiveness** goes through `context.isMobile` / `context.isTablet` or
  `context.pick(mobile: …, desktop: …)`. Breakpoints: 760 and 1100.
- **Explicit type annotations** on locals and collection literals
  (`<Widget>[]`, `final double x = …`). This is a deliberate house style — keep
  it, do not "modernise" it away.
- **`withOpacity` is used on purpose**, not `withValues`, for compatibility
  with older SDKs. `analysis_options.yaml` silences the deprecation. Do not
  bulk-migrate it without the user asking.
- **Private widgets** (`_Glow`, `_NavLink`, `_ProjectCard`) live at the bottom
  of the file that uses them. Only genuinely reusable widgets go in
  `lib/widgets/`.
- **Content never gets hardcoded in a section file.** It belongs in
  `lib/data/portfolio_data.dart`. Section files read from it.
- **Entrance animation is always `Reveal`** (or `OnVisible` for a custom one),
  never an `initState` + `forward()` that fires off-screen.

## Invariants you can break by accident

1. **`PageScroll` must stay an ancestor of the scroll view.** `Reveal`,
   `OnVisible` and `Parallax` all look it up with
   `PageScroll.maybeOf(context)`. They degrade silently — content stays
   invisible or never parallaxes — instead of throwing. If reveals stop
   working, this is why.
2. **Section order is positional.** `buildSections()` returns 7 `SectionRef`s
   and `home_page.dart` wires `_sections[0..6]` to specific widgets, with
   hardcoded indices in callbacks (`_goTo(3)` = Work, `_goTo(6)` = Contact).
   Adding a section means updating the list, the `KeyedSubtree` chain and those
   indices together.
3. **`lib/core/links_web.dart` is web-only** and must only ever be reached
   through `lib/core/links.dart`. Importing it directly breaks non-web builds.
4. **`window.removeSplash` is a contract** between `web/index.html` and
   `hideSplash()` (called from `HomePage.initState`'s post-frame callback). If
   you rewrite either side, the splash stays on screen forever.
5. **The scroll-to-section offset is manual**, not
   `Scrollable.ensureVisible`, because the fixed top bar would cover the
   heading. See `_goTo` in `home_page.dart` — it subtracts 84px for every
   section except the hero.

## Working with the owner

- He is a Flutter developer, so explain in Flutter terms and skip basics.
- Content placeholders are marked `<-- EDIT` in `lib/data/portfolio_data.dart`.
  Real values (his projects, employers, links) still need filling in; do not
  invent them. If a task needs a real value, ask.
- The old React site at `../portfolio` is reference only. Never edit it.
