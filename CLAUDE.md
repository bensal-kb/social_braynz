# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

This is a **fresh Flutter project scaffold** (default `flutter create` counter demo, unmodified) for a take-home assessment. The actual app has not been built yet — [lib/main.dart](lib/main.dart) still contains the stock Flutter counter template and [test/widget_test.dart](test/widget_test.dart) still contains the stock counter smoke test.

The assignment brief is at [docs/Requirement.pdf](docs/Requirement.pdf): build an **Inventory & Stock Manager** app for a small shop owner. Key requirements:

- Add / edit / remove products (name, quantity, price)
- Log a sale (deducts stock accordingly)
- Low-stock alert (threshold logic is left to the implementer)
- App must work fully offline and sync when connectivity returns
- Basic list/detail UI — functional over polished

State management, local storage, and sync/conflict-resolution strategy are **intentionally unspecified** by the brief — picking and justifying an approach is part of the assessment. When implementing, make a deliberate, defensible choice rather than defaulting to whatever is already in `pubspec.yaml` (currently only `cupertino_icons` and `flutter_lints` are declared — no state management, storage, or connectivity packages have been added yet).

The brief also requires a README documenting: what was built and deliberately left out, how offline/sync was handled, and what would be added with 2 more days. Write this at the repo root when the app is implemented.

## Commands

Standard Flutter CLI workflow (run from the repo root):

```bash
flutter pub get                 # install/update dependencies after editing pubspec.yaml
flutter run                     # run on a connected device/emulator (hot reload with 'r')
flutter analyze                 # static analysis (uses analysis_options.yaml / flutter_lints)
flutter test                    # run all tests in test/
flutter test test/widget_test.dart   # run a single test file
flutter test --plain-name "Counter increments smoke test"  # run a single test by name
flutter build apk               # Android release build
flutter build ios               # iOS release build (requires macOS/Xcode)
```

Dart SDK constraint: `^3.12.2` (see [pubspec.yaml](pubspec.yaml)).

## Architecture notes

- Only `lib/main.dart` exists currently — there is no established folder structure (no `lib/models`, `lib/screens`, `lib/services`, etc.) to conform to yet. The first substantial implementation will define this structure.
- Platform projects (`android/`, `ios/`) are untouched Flutter-generated scaffolding; no custom native code, permissions, or plugins have been configured.
- Lint rules come from `package:flutter_lints/flutter.yaml` via [analysis_options.yaml](analysis_options.yaml), with no project-specific overrides yet.
