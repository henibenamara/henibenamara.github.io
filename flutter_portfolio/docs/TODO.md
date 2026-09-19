# TODO — ordered

## 1. Make it run (do this first)

- [ ] `flutter pub get && flutter analyze` — fix whatever it reports.
      `docs/BUILD_LOG.md` lists the ten most likely offenders with reasons.
- [ ] `flutter run -d chrome` and walk the whole page: hero particles react to
      the cursor, reveals fire on scroll, tilt cards tilt, playground sliders
      update stage + curve + code, theme toggle morphs, nav dots track the
      active section, mobile menu opens under 760px width.
- [ ] Resize to phone width and check every section single-columns cleanly.
- [ ] `flutter build web --release` and serve `build/web` — confirm the HTML
      splash fades out instead of hanging.

## 2. Real content (needs the owner)

- [ ] `lib/data/portfolio_data.dart`: every `<-- EDIT` marker — real projects,
      real employers and dates, real links, real phone, honest skill levels.
- [ ] `web/cv.pdf` — replace the placeholder.
- [ ] `assets/images/me.png` + the swap in `about.dart` `_Portrait`.
- [ ] Project screenshots (optional — the painted mockups are a feature, not a
      gap).
- [ ] `web/index.html` meta description and `og:` tags; `'heni.dev'` label in
      `top_bar.dart`.

## 3. Polish worth doing

- [ ] Bundle the three fonts locally (removes a CDN dependency and the
      CanvasKit font-registration question entirely).
- [ ] Reduced-motion support: check `MediaQuery.of(context).disableAnimations`
      in `ParticleField`, `LogoMark`, `GradientText` and the playground's
      auto-play.
- [ ] Focus/keyboard support on the custom `GestureDetector` buttons
      (`FocusableActionDetector` or `InkWell`).
- [ ] `Semantics` labels on nav dots and icon-only buttons.
- [ ] One widget test: pump `PortfolioApp`, assert the seven sections mount.
- [ ] Open Graph preview image (`web/og.png`) so shared links render a card.

## 4. Ship

- [ ] Decide the URL: GitHub Pages project site (`--base-href /<repo>/`) or a
      custom domain (`--base-href /`).
- [ ] The workflow at `../.github/workflows/deploy-flutter-portfolio.yml`
      builds on push to `main` and publishes `build/web` to `gh-pages`. Its
      `--base-href` is `/site/` — change it to match the repo name.
- [ ] Repo → Settings → Pages → Deploy from branch → `gh-pages` / root.
- [ ] Decide what happens to the old React site at `../portfolio`: keep it,
      archive it, or point the GitHub Pages site at the Flutter build instead.
      Ask before touching it.
