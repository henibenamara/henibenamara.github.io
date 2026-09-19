# Customization recipes

Task-oriented. Each recipe lists every file that has to change.

---

## Change name, role, socials, email

`lib/data/portfolio_data.dart` → the `profile` const. Fields marked `<-- EDIT`:
`name`, `initials`, `tagline`, `location`, `availability`, `email`, `phone`
(country code + number, no `+`, used for `wa.me`), `github`, `linkedin`,
`facebook`, `rotatingRoles` (the typewriter list).

Also update, if you want them to match:

- `web/index.html` — `<title>`, the `description` and `og:` meta tags.
- `lib/sections/top_bar.dart` — the literal `'heni.dev'` next to the logo.
- `pubspec.yaml` — `name:` (currently `heni_portfolio`); changing it means
  every `import 'package:heni_portfolio/...'` would change too, but this
  project uses relative imports only, so it is safe.

## Add or edit a project

Append to the `projects` list in `lib/data/portfolio_data.dart`:

```dart
Project(
  title: 'App name',
  subtitle: 'One line of positioning',
  description: 'Two sentences on what it does and what was hard.',
  tags: <String>['Flutter', 'Firebase'],
  gradient: <Color>[Color(0xFF4DB5FF), Color(0xFF8B5CF6)],
  mock: MockStyle.tracker,     // tracker | chat | dashboard | shop
  codeUrl: 'https://github.com/...',   // omit or '' hides the Code button
  liveUrl: 'https://...',              // omit or '' hides the Live button
  image: 'assets/images/myapp.png',    // optional: replaces the painted mockup
),
```

The grid is a `Wrap` — any number of projects works, two per row on desktop.

To use a real screenshot: drop the file in `assets/images/`, uncomment the
`assets:` block in `pubspec.yaml`, set `image:`, then `flutter pub get`.

To add a fifth mockup style: add a value to `enum MockStyle`, then add a
matching `case` in `_PhonePainter.paint` in
`lib/widgets/project_preview.dart` (the switch is exhaustive, so the analyzer
will point you at it).

## Add a skill group or change percentages

`skillGroups` in `lib/data/portfolio_data.dart`. `level` is 0.0–1.0 and is both
the bar fill and the displayed percentage. Icons come from `Icons.*`. Three
groups fit one desktop row; a fourth wraps cleanly.

## Edit the timeline

`timeline` in `lib/data/portfolio_data.dart`. `period`, `role`, `org`, `body`,
optional `tags`. The rail (dots and connecting lines) adapts automatically —
first and last entries hide their outer line segments.

## Swap the portrait placeholder for a photo

1. Put `me.png` in `assets/images/`.
2. Uncomment the `assets:` block in `pubspec.yaml`, run `flutter pub get`.
3. In `lib/sections/about.dart`, inside `_Portrait`, replace the
   `Center(child: Column(...))` placeholder with:
   ```dart
   Image.asset('assets/images/me.png', fit: BoxFit.cover)
   ```
   Keep it inside the existing `ClipRRect` so the gradient frame still works.

## Replace the CV

Overwrite `web/cv.pdf`. It is served next to `index.html` after
`flutter build web`, and `profile.cvUrl` (`'cv.pdf'`) points at it. Use an
absolute URL instead if you host the CV elsewhere.

## Change the colour scheme

`lib/theme/app_theme.dart` → `AppColors.dark` and `AppColors.light`. Change
`accent`, `accent2`, `accent3` and every gradient across the site follows. Keep
the light theme's accents darker than the dark theme's or contrast on white
collapses.

## Bundle fonts instead of loading from Google

1. Download the `.ttf` files into `assets/fonts/`.
2. Uncomment the `fonts:` block in `pubspec.yaml` (it already lists the
   expected filenames).
3. `flutter pub get`.
4. Optionally remove the `<link>` tags from `web/index.html`.

This also fixes the case where the CanvasKit renderer does not pick up
CSS-loaded fonts — see `docs/BUILD_LOG.md`.

## Add a new section

Four coordinated edits — miss one and the nav silently points at the wrong
place:

1. `lib/core/sections.dart` — add a `SectionRef('Label', Icons.something)` at
   the right position in `buildSections()`.
2. `lib/sections/my_section.dart` — build it with `SectionShell(eyebrow:,
   title:, intro:, child:)` so it matches the others.
3. `lib/pages/home_page.dart` — add a `KeyedSubtree(key: _sections[n].key,
   child: const MySection())` in the same position in the `Column`.
4. `lib/pages/home_page.dart` — fix the hardcoded indices in the hero and about
   callbacks (`onWork: () => _goTo(3)`, `onContact: () => _goTo(6)`,
   `onScrollCue: () => _goTo(1)`).

The top bar, nav rail, footer links and mobile menu all read the same list, so
they update themselves.

## Change breakpoints

`lib/core/responsive.dart`. `mobile` (760) switches every section to single
column; `tablet` (1100) mainly affects the skills grid (3 columns vs 2).
The nav rail's visibility is governed by `isMobile` alone.

## Make the contact form send instead of opening a mail client

Currently `_send` in `lib/sections/contact.dart` builds a `mailto:` URL — no
backend, no packages. To post to a service (Formspree, Web3Forms, your own
endpoint) you need an HTTP call. `dart:js_interop` + `fetch` keeps the
zero-dependency rule; `package:http` would break it. Ask the owner before
adding the package.
