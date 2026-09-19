# Flutter Web portfolio

A portfolio site written entirely in Dart and rendered by Flutter Web.
No React, no CSS framework, and **no third-party packages** - every effect
below is hand-built on top of the Flutter SDK, which is the point: the site
itself is the work sample.

## Run it

```bash
cd flutter_portfolio
flutter pub get
flutter run -d chrome
```

Release build:

```bash
flutter build web --release
# output: build/web
```

(Needs Flutter 3.22 or newer - `web/index.html` uses the `flutter_bootstrap.js`
loader. `flutter --version` tells you.)

## Make it yours

Everything editable lives in **`lib/data/portfolio_data.dart`**. Search for
`<-- EDIT`:

| What | Where |
| --- | --- |
| Name, role, tagline, socials, email, phone | `profile` |
| About paragraphs and the three highlight cards | `aboutParagraph1/2`, `highlights` |
| The four counters | `stats` |
| Skill groups and percentages | `skillGroups` |
| Projects (title, text, tags, links, colours, mockup style) | `projects` |
| Timeline entries | `timeline` |

Other things you may want to touch:

- **Your photo** - drop `me.png` in `assets/images/`, uncomment the `assets:`
  block in `pubspec.yaml`, then swap the placeholder `Center(...)` in
  `lib/sections/about.dart` (`_Portrait`) for
  `Image.asset('assets/images/me.png', fit: BoxFit.cover)`.
- **Your CV** - replace `web/cv.pdf`. The Download CV button points at it.
- **Project screenshots** - set `image: 'assets/images/project1.png'` on a
  project and the painted mockup is replaced by your screenshot.
- **Colours** - `lib/theme/app_theme.dart`, `AppColors.dark` / `AppColors.light`.
- **Fonts** - the page loads Space Grotesk / Inter / JetBrains Mono from Google
  Fonts in `web/index.html`. To bundle them instead (works offline, no CDN
  request), download the `.ttf` files into `assets/fonts/` and uncomment the
  `fonts:` block in `pubspec.yaml`. If neither is available Flutter falls back
  to Roboto and the layout is unaffected.

## What is hand-built in here

- `widgets/particle_field.dart` - constellation background: one `Ticker`, a
  `CustomPainter`, particles that link to their neighbours and scatter away
  from the cursor.
- `widgets/reveal.dart` - scroll-reveal without a visibility package: each
  widget measures its own `RenderBox` against the viewport and animates once.
- `widgets/parallax.dart` - depth layers driven by the shared scroll offset.
- `widgets/tilt_card.dart` - 3D perspective tilt with a moving specular glare
  (`Matrix4..setEntry(3, 2, ...)`).
- `widgets/project_preview.dart` - every project thumbnail is a phone UI
  painted at runtime; four different layouts, no images.
- `sections/playground.dart` - the interactive section: sliders rebuild a real
  widget tree, the selected `Curve` is plotted live with a playhead, and the
  matching Dart source is generated and syntax-highlighted next to it.
- `sections/top_bar.dart` - the sun/moon theme toggle is a single circle with a
  second circle subtracted from it (`Path.combine`), not two swapped icons.
- `theme/app_theme.dart` - both themes as a `ThemeExtension`, so light/dark
  lerps every custom colour instead of snapping.

## Structure

```
lib/
  main.dart            entry point
  app.dart             MaterialApp, theme mode, drag-to-scroll behaviour
  data/                >>> the only file you normally edit <<<
  theme/               colour tokens + type scale (light & dark)
  core/                responsive helpers, scroll scope, web link opening
  widgets/             reusable pieces (reveal, tilt, particles, meters, ...)
  sections/            hero, about, skills, projects, playground, journey,
                       contact, footer, top bar, nav rail
  pages/home_page.dart assembles the page, scroll-spy and navigation
web/index.html         animated splash that fades out on the first frame
```

## Deploy to GitHub Pages

A workflow is included at `../.github/workflows/deploy-flutter-portfolio.yml`.
It builds on every push to `main` and publishes `build/web` to `gh-pages`.
Set `--base-href` to your repo name (`/site/` by default; use `/` for a custom
domain), then in the repo: Settings -> Pages -> Deploy from branch -> `gh-pages`.

Manual alternative:

```bash
flutter build web --release --base-href /site/
npx gh-pages -d build/web
```
