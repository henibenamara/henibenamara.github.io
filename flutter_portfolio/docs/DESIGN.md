# Design system

Everything here is already encoded in `lib/theme/app_theme.dart`. This file
explains the intent so new components match instead of drifting.

## Direction

"Modern dark, refined" — the spirit of the old React portfolio (deep navy,
cyan accent) taken up several notches: darker ground, wider contrast range,
glass surfaces instead of flat cards, and a cyan → blue → violet accent ramp
used as a gradient rather than a single hue. The light theme is a genuine
second theme, not an inverted afterthought.

## Colour tokens

Never hardcode a colour. Read `context.c`.

| Token | Dark | Light | Used for |
| --- | --- | --- | --- |
| `accent` | `#4DB5FF` | `#0B7FD4` | primary accent, icons, active states, links |
| `accent2` | `#8B5CF6` | `#6D3BF0` | gradient end, secondary highlights |
| `accent3` | `#22D3EE` | `#0891B2` | gradient start |
| `bg` | `#07070F` | `#F7F8FC` | page ground |
| `bgAlt` | `#0C0C18` | `#EEF1F8` | gradient band down the page, footer |
| `surface` | `#12121F` | `#FFFFFF` | solid cards (project cards, bottom sheet) |
| `glass` | white 8% | ink 4% | frosted panel tint |
| `border` | white 12% | ink 10% | hairlines, inactive outlines |
| `text` | `#F2F4FA` | `#0B1020` | headings, emphasis |
| `muted` | text 70% | ink 70% | body copy |
| `faint` | text 40% | ink 40% | captions, labels, inactive |

The three-stop gradient `[accent3, accent, accent2]` is the brand signature: it
appears on the logo, primary buttons, progress bar, skill bars, stat numerals,
active nav dots and the back-to-top button. Two-stop `[accent3, accent2]` is
used where the run is short.

## Type scale

Display family **Space Grotesk** for anything heading-like, body family
**Inter** for prose, **JetBrains Mono** for the code block. All three load from
Google Fonts in `web/index.html`; `fontFamilyFallback` ends at Roboto, which
Flutter always has.

| Role | Size / weight / tracking | Used for |
| --- | --- | --- |
| `displayLarge` | 72 w700, -2.4 | hero name (desktop) |
| `displaySmall` | 40 w600, -1.2 | section titles (desktop), stat numerals |
| `headlineMedium` | 32 w600 | section titles (mobile) |
| `headlineSmall` | 24 w600 | typewriter role line |
| `titleLarge` | 20 w600 | card titles |
| `titleMedium` | 16 w600 | small card titles, list items |
| `bodyLarge` | 17, 1.6 line height | intro paragraphs |
| `bodyMedium` | 15 | standard copy |
| `bodySmall` | 13.5 | captions, secondary values |
| `labelMedium` | 12 w500, 1.6 tracking | uppercase eyebrows |

Negative tracking on display sizes and generous line height on body is what
makes it read as designed rather than default-Material.

## Spacing and shape

- Section vertical rhythm: **110px** desktop, **64px** mobile
  (`SectionShell`). Header to content: 56 / 36.
- Content max width **1140px** (`Breakpoints.content`), gutters 40 / 20.
- Radii: `999` pills and chips · `26` project cards · `24` major panels ·
  `22` default `GlassPanel` · `20`/`18` nested panels · `14` buttons and
  inputs.
- Grid columns: projects 2/1, skills 3/2/1, everything laid out with `Wrap` +
  computed `SizedBox` widths so there is no dependency on `GridView`.

## Motion language

Nothing moves without a reason, and everything uses the same vocabulary.

| Gesture | Duration | Curve |
| --- | --- | --- |
| Scroll reveal | 720ms | `easeOutCubic` |
| Hover (buttons, links, dots) | 200–260ms | `easeOutCubic` |
| Tilt settle | 260ms | `easeOutCubic` |
| Scroll to section | 780ms | `easeInOutCubic` |
| Theme toggle morph | 520ms | `easeOutCubic` |
| Counters / skill fill | 1100–1400ms | `easeOutCubic` |
| Ambient loops (logo, particles, gradient text) | 1.6s–7s | linear / `easeInOut`, repeating |

Rule of thumb: entrances travel 24–46px and never scale from below 0.9;
hover lifts are 3px; glows grow rather than colours changing.

## Component patterns

- **Glass panel** — `GlassPanel` for anything informational. Solid `surface`
  is reserved for cards with imagery (project cards) and overlays.
- **Buttons** — one `BrandButton` per view as the primary action;
  `GhostButton` for everything secondary; `IconPill` for icon-only.
- **Eyebrow + title + rule** — every section opens the same way via
  `SectionShell`; do not hand-roll a section header.
- **Tags** — always `TagChip`, tinted 10% with a 35% border.

## Accessibility notes (and current gaps)

Done: 4.5:1+ body contrast in both themes, hit targets ≥ 40px, focus-visible
outlines on form fields, `SelectableText` for the code block, tooltips on every
icon-only control.

Known gaps worth fixing if you have time:

- No `Semantics` labels on the decorative painters (harmless) or on the nav
  dots (worth adding).
- No `MediaQuery.disableAnimations` / reduced-motion check — the particle field
  and looping animations run regardless. A `reduceMotion` guard in
  `ParticleField`, `LogoMark`, `GradientText` and the playground's auto-play
  would be a real improvement.
- Keyboard navigation works through default `Focus` traversal but the custom
  `GestureDetector`-based buttons are not focusable. Wrapping them in
  `InkWell`/`FocusableActionDetector` would fix it.
