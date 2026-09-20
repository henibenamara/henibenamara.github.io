# Heni Ben Amara - Portfolio

**Live site: https://henibenamara.github.io**

My personal portfolio, written entirely in Dart and rendered with Flutter Web, with no third-party packages. Every effect (particle background, scroll reveal, parallax, 3D tilt cards and an interactive playground) is hand-built on top of the Flutter SDK, so the site itself is a work sample.

## Sections

Home, About, Skills, Work, Playground, Journey and Contact, with a CV download and a dark and light theme.

## Repository layout

- `flutter_portfolio/`: the Flutter Web app. Its README covers running and customising it, and `docs/` has the architecture and design notes.
- `.github/workflows/deploy-flutter-portfolio.yml`: builds the app and publishes it to the `gh-pages` branch on every push to `main`.
- `resume.pdf`: my CV.

## Run locally

```bash
cd flutter_portfolio
flutter pub get
flutter run -d chrome
```

Requires Flutter 3.22 or newer.
