# Architecture

How the app is wired, file by file, and the four mechanisms worth understanding
before you change anything.

---

## 1. Boot sequence

1. `web/index.html` paints an animated HTML splash (gradient tile, sliding
   progress bar, "compiling dart to the web") and defines
   `window.removeSplash()`.
2. `flutter_bootstrap.js` loads the Flutter engine and the app.
3. `main.dart` → `runApp(const PortfolioApp())`.
4. `app.dart` builds `MaterialApp` with both themes and `themeMode` held in
   state.
5. `HomePage.initState` registers a post-frame callback that calls
   `hideSplash()` → `window.removeSplash()` → the HTML splash fades out over
   550ms and removes itself from the DOM.

The splash exists because a Flutter Web release build shows a blank page while
the engine downloads. Removing it from Dart (not from a JS timer) guarantees it
disappears exactly when the first Flutter frame is on screen.

---

## 2. The scroll system (the spine of the page)

`HomePage` owns one `ScrollController` and three `ValueNotifier`s:

| Notifier | Feeds |
| --- | --- |
| `_offset` (double) | `PageScroll` → every `Reveal` / `OnVisible` / `Parallax`; the top bar's blur/opacity; the back-to-top button |
| `_progress` (0..1) | the gradient reading-progress bar under the top bar |
| `_active` (int) | the top bar's underline and the right-hand nav rail |

`_onScroll()` updates all three on every scroll event, and recomputes the
active section by walking the 7 `SectionRef` keys and taking the last one whose
`localToGlobal(Offset.zero).dy <= 160`.

Notifiers rather than `setState` is deliberate: the whole page (hero particles,
playground animation, dozens of glass panels) would rebuild on every scroll
frame otherwise. Only the widgets that listen rebuild.

`PageScroll` (`core/scroll_scope.dart`) is a plain `InheritedWidget` carrying
the offset notifier and the controller. It wraps the entire `Stack` in
`HomePage.build`, so every descendant can find it.

### Scroll-into-view

`_goTo(index)` reads the target `SectionRef`'s `GlobalKey.currentContext`,
converts its `RenderBox` position to a scroll offset, subtracts 84px of top-bar
height (except for the hero), clamps to `maxScrollExtent` and calls
`animateTo` with `easeInOutCubic` over 780ms.

`Scrollable.ensureVisible` was rejected because it aligns the section top to
the viewport top, which puts the heading behind the fixed top bar.

---

## 3. The reveal system

`widgets/reveal.dart` contains three things:

- **`OnVisible`** — the primitive. On every scroll tick it measures its own
  `RenderBox` (`localToGlobal(Offset.zero).dy`) against
  `MediaQuery.of(context).size.height * threshold` (default 0.9). When the
  widget crosses the line it sets `_armed = true` (so it fires exactly once),
  waits `delay`, and calls `setState` with `_visible = true`. It also runs one
  check in a post-frame callback from `didChangeDependencies`, which is what
  makes above-the-fold content (the whole hero) animate in on load without any
  scrolling.
- **`Reveal`** — wraps `OnVisible` in a `TweenAnimationBuilder<double>` that
  drives opacity, a `Transform.translate` (`dx`/`dy` travel) and an optional
  `Transform.scale`. Curve: `easeOutCubic`, 720ms.
- **`RevealStagger`** — builds a Column/Row of `Reveal`s with an incrementing
  delay.

Anything that needs "animate when scrolled to" uses `OnVisible` directly rather
than reimplementing the measurement — see `SkillBar` and `StatCounter` in
`widgets/meters.dart`, which start their count-up/fill only once visible.

**Failure mode:** if `PageScroll` is not an ancestor, `OnVisible` only ever
runs its single post-frame check. Content above the fold still appears;
anything below it stays at opacity 0.

---

## 4. Theming

`theme/app_theme.dart` defines `AppColors`, a `ThemeExtension<AppColors>` with
11 tokens: `accent`, `accent2`, `accent3`, `bg`, `bgAlt`, `surface`, `glass`,
`border`, `text`, `muted`, `faint`, plus a `brand` `LinearGradient` getter.

Two const instances (`AppColors.dark`, `AppColors.light`) are attached to the
two `ThemeData`s via `extensions:`. Because `lerp` is implemented, switching
themes animates every custom colour through `MaterialApp`'s built-in
`AnimatedTheme` instead of snapping.

Access is always `context.c` (extension `AppColorsX` in the same file), with
`context.isDark` for the rare case where a widget needs the brightness itself
(the code block's near-black background).

Typography is built in `AppTheme._text`: a `display` family (Space Grotesk) for
headings with negative tracking, a `body` family (Inter) for prose, and a
`fallback` chain ending in `sans-serif`. Both families are loaded by a `<link>`
in `web/index.html`; if they fail to load, Flutter falls back to Roboto and
nothing breaks.

---

## 5. File-by-file

### Entry / shell

| File | Responsibility |
| --- | --- |
| `main.dart` | `runApp` only |
| `app.dart` | `MaterialApp`, theme mode state + toggle, `AppScrollBehavior` (adds mouse/trackpad/stylus to `dragDevices` so the page can be dragged, not just wheeled) |
| `pages/home_page.dart` | scroll controller, notifiers, scroll spy, `_goTo`, mobile menu bottom sheet, the `Stack` that layers background → content → nav rail → top bar + progress → back-to-top |

### Core

| File | Responsibility |
| --- | --- |
| `core/responsive.dart` | `Breakpoints` (mobile 760, tablet 1100, content 1140) and the `ResponsiveX` extension (`screenW/H`, `isMobile/isTablet/isDesktop`, `pick`) |
| `core/scroll_scope.dart` | `PageScroll` inherited widget |
| `core/sections.dart` | `SectionRef(label, icon, GlobalKey)` + `buildSections()` — the 7 anchors, in order: Home, About, Skills, Work, Playground, Journey, Contact |
| `core/links.dart` | conditional export: `links_web.dart` when `dart.library.js_interop` is available, else `links_stub.dart` |
| `core/links_web.dart` | `@JS('window.open')` and `@JS('window.removeSplash')` externals, each wrapped in try/catch |
| `core/links_stub.dart` | no-op `openLink` / `hideSplash` so the app still compiles for mobile/desktop targets |

### Data

`data/portfolio_data.dart` — every string, number, colour and link the visitor
sees. Types: `Profile`, `Highlight`, `StatItem`, `Skill`, `SkillGroup`,
`Project` + `MockStyle` enum, `TimelineEntry`. Top-level consts: `profile`,
`aboutParagraph1/2`, `highlights`, `stats`, `skillGroups`, `projects`,
`timeline`.

### Widgets (reusable)

| File | What it does |
| --- | --- |
| `reveal.dart` | `OnVisible`, `Reveal`, `RevealStagger` (see §3) |
| `parallax.dart` | translates its child by `(scroll - anchor) * factor`, clamped; anchor captured on first frame |
| `particle_field.dart` | the hero background. One `Ticker` (via `SingleTickerProviderStateMixin`), a `List<_Particle>` of positions/velocities, edge bouncing, a minimum drift so it never freezes, pointer repulsion inside `pointerRadius`, and a `CustomPainter` that draws neighbour links (O(n²) over ~70 particles), pointer links and dots. Repaints via a `ValueNotifier<int>` passed as `repaint:` — the widget tree never rebuilds. |
| `tilt_card.dart` | `MouseRegion` + `Matrix4..setEntry(3, 2, 0.0012)..rotateX/rotateY`, hover factor smoothed by `TweenAnimationBuilder`, plus a `RadialGradient` glare positioned at the pointer and a coloured shadow that grows on hover |
| `glass.dart` | `GlassPanel` (ClipRRect + BackdropFilter + hairline border) and `GradientRule` |
| `gradient_text.dart` | `ShaderMask` with `BlendMode.srcIn`; when `animate: true` the gradient's begin/end alignments slide on a 6s repeating controller |
| `buttons.dart` | `BrandButton` (gradient fill, hover lift + glow), `GhostButton` (outline), `IconPill` (circular icon), `TagChip` |
| `meters.dart` | `SkillBar` (fill + % counter, starts on visible), `StatCounter` (count-up with gradient numerals) |
| `typewriter.dart` | type / hold / delete cycle driven by a recursive `Timer`, with a blinking caret on a repeating controller |
| `logo_mark.dart` | gradient tile with initials, slowly rotating and morphing its corner radius |
| `section_shell.dart` | the section frame every section uses: eyebrow, title, `GradientRule`, optional intro, responsive padding, 1140px max width |
| `project_preview.dart` | gradient panel + light blobs + `_PhonePainter`, which draws four different app UIs (`tracker`, `chat`, `dashboard`, `shop`) with primitives only. Replaced by `Image.asset` if a project sets `image:` |

### Sections

| File | Notes |
| --- | --- |
| `hero.dart` | full-viewport stack: particles → parallaxed colour glows → content → scroll cue. Content is in a `SingleChildScrollView` with `NeverScrollableScrollPhysics` so it clips instead of overflowing on short screens while the wheel still reaches the page. Height is `max(viewportHeight, 800 mobile / 680 desktop)`. |
| `about.dart` | portrait placeholder (swap for `Image.asset`), highlight cards, two paragraphs, location/role row, CTA, and the 4-stat glass strip |
| `skills.dart` | 1/2/3 column `Wrap` of glass cards, each with an icon tile and its `SkillBar`s |
| `projects.dart` | 1/2 column `Wrap` of `TiltCard`s with painted previews, tags and conditional Code/Live buttons |
| `playground.dart` | the interactive section — see §6 |
| `experience.dart` | timeline: `IntrinsicHeight` row of [period] [rail with gradient dot and connecting lines] [glass card], revealing from opposite directions |
| `contact.dart` | three contact option cards (mailto, `wa.me`, LinkedIn) and a validated `Form` that composes a `mailto:` URL with `Uri.encodeComponent` and shows a floating `SnackBar` |
| `footer.dart` | logo + name, section links, socials, copyright, "Built with Flutter Web" badge |
| `top_bar.dart` | blur and background opacity interpolate over the first 120px of scroll; animated underline nav links; `_ThemeToggle` whose sun becomes a crescent via `Path.combine(PathOperation.difference, …)` |
| `nav_rail.dart` | desktop-only dot rail, right edge, label on hover, gradient + glow when active |

---

## 6. The playground section

The most complex file (`sections/playground.dart`, ~890 lines) and the point of
the whole site. State: `radius`, `blur`, `hue`, `travel`, `ms`, `gradient`,
`spin`, `curve` index, `playing`, plus one `AnimationController` repeating in
reverse.

Four pieces stay in sync from that single state:

1. **`_Stage`** — grid-painted backdrop with a live `AnimatedBuilder` box:
   `curve.transform(controller.value)` drives a `Matrix4` translate/rotate, and
   the decoration reads radius/blur/hue/gradient directly.
2. **`_CurveGraph`** — plots the selected `Curve` across 90 samples with a
   head-room mapping (`(v + 0.25) / 1.5`) so overshooting curves like
   `elasticOut` stay inside the box, and draws a playhead dot at the current
   controller value.
3. **`_CodeBlock`** — the `_code` getter interpolates the current state into a
   Dart snippet; a single `RegExp` splits it into comment / string / number /
   keyword / type spans for highlighting, rendered in a macOS-style window
   chrome via `SelectableText.rich`.
4. **`_Controls`** — sliders, switches and curve chips, all stateless and
   driven by callbacks.

Changing a slider calls `setState` on the section, which rebuilds stage, graph
and code together. Changing the duration also reassigns `controller.duration`
and restarts the repeat if it was playing.
