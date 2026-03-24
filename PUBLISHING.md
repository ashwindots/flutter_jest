# 📦 Publishing Checklist for `flutter_jest_style`

A step-by-step checklist for releasing to [pub.dev](https://pub.dev).

---

## 📦 Package Metadata (`pubspec.yaml`)

- [ ] `name` follows pub.dev conventions (lowercase, underscores)
- [ ] `version` uses [semantic versioning](https://semver.org/) (`1.0.0` for first stable)
- [ ] `description` is ≤ 180 characters and clearly states purpose
- [ ] `homepage` URL is valid and resolves
- [ ] `repository` URL is valid and resolves
- [ ] `issue_tracker` URL points to GitHub Issues
- [ ] `topics` list added for discoverability (max 5)
- [ ] `environment.sdk` constraint is compatible with current stable Dart
- [ ] All `dependencies` have version constraints (no `any`)
- [ ] `dev_dependencies` include a lints package
- [ ] `executables` section declares `fjest`

---

## 📚 Documentation & Quality

- [ ] `README.md` exists, is comprehensive, and renders correctly
  - Preview: `dart pub publish --dry-run` shows `README.md` as detected
- [ ] All public APIs have `///` dartdoc comments
- [ ] `dart doc` runs without errors:
  ```sh
  dart doc
  ```
- [ ] `CHANGELOG.md` has an entry for the current version with bullet-point changes
- [ ] `LICENSE` file exists (MIT) and is referenced in pubspec
- [ ] `example/` directory contains runnable example code:
  - `example/flutter_jest_style_example.dart` ✅
  - `example/example_test.dart` ✅

---

## 🔍 Analysis & Scoring (Pub Points)

- [ ] `dart analyze` returns **zero issues**:
  ```sh
  dart analyze --fatal-infos
  ```
- [ ] `dart format` passes:
  ```sh
  dart format --output=none --set-exit-if-changed .
  ```
- [ ] `pana` score is ≥ 120/160:
  ```sh
  dart pub global activate pana
  dart pub global run pana .
  ```
- [ ] No deprecated APIs used
- [ ] No unnecessary `dart:io` imports in library files (only in src/)

---

## 🧪 Testing

- [ ] `dart test` passes locally:
  ```sh
  dart test
  ```
- [ ] Tests cover core functionality (snapshots, mocking, golden path)
- [ ] CI workflow included at `.github/workflows/ci.yml`
- [ ] Snapshot test artifacts (`test/__snapshots__/`) are gitignored or committed intentionally

---

## 🚀 Publishing Steps

### 1. Dry Run

```sh
dart pub publish --dry-run
```

Fix any warnings before proceeding. Common warnings:
- Missing `homepage` / `repository`
- Description too long (>180 chars)
- Missing `LICENSE`
- Unformatted code

### 2. Preview the Package Page

After dry-run succeeds, review the output — it shows exactly what will be published. Check:
- README renders correctly
- CHANGELOG is included
- Example is detected

### 3. Login

```sh
dart pub login
```

Authenticate with your pub.dev account (Google login via browser).

### 4. Publish

```sh
dart pub publish
```

Type `y` when prompted. Publication is **immediate and irreversible** — the version number cannot be reused.

### 5. Post-Publish Verification

- [ ] Visit `https://pub.dev/packages/flutter_jest_style` and verify:
  - README renders correctly
  - API docs are generated
  - Score is acceptable
- [ ] Add topic tags on the pub.dev admin panel
- [ ] Verify `dart pub add flutter_jest_style` works in a fresh project

---

## 🔄 Post-Publish

- [ ] Tag the release in Git:
  ```sh
  git tag v1.0.0
  git push origin v1.0.0
  ```
- [ ] Create a GitHub Release from the tag with CHANGELOG notes
- [ ] Monitor pub.dev for user issues/feedback

---

## ⚠️ Handling Issues

### Failed Publish

If `dart pub publish` fails:
- Check network connectivity
- Ensure you're logged in: `dart pub login`
- Fix any validation errors shown
- Run `dart pub publish --dry-run` again

### Retracting a Version

If a published version has critical bugs:

```sh
dart pub global activate pana
# On pub.dev admin panel: mark version as "retracted"
```

Retracted versions still exist but show a warning. You **cannot delete** a version — publish a patch instead.

### Versioning After Publish

- Bug fix: `1.0.1`
- New feature (backward-compatible): `1.1.0`
- Breaking change: `2.0.0`

Always update `CHANGELOG.md` and `pubspec.yaml` version before each publish.
