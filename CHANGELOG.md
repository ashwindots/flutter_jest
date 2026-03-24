## [1.0.0] - 2026-03-24

### Added

- **📸 Snapshot testing** — `toMatchSnapshot(name)` matcher with auto-create, compare, and update.
- **🎭 Mock utilities** — `fn<T>()`, `fn1<R, A>()`, `fn2<R, A, B>()`, `mockReturnValue()`, `mockImplementation()`, `mockReset()`, `mockClear()`.
- **⚡ CLI** — `fjest` command with `--watch`, `--coverage`, and `--snapshot-update` flags.
- **👀 Watch mode** — file-system watcher reruns tests on `lib/` and `test/` changes.
- **🖼️ Golden test helpers** — `goldenPath(name)` for visual regression.
- **📦 Single import** — re-exports `test`, `mocktail`, snapshot, mock, and golden APIs.
- **🔧 CI/CD support** — `FLUTTER_JEST_ROOT` env var for reliable snapshot path resolution.

<!-- Template for future releases:

## [x.y.z] - YYYY-MM-DD

### Added
- New features.

### Changed
- Changes to existing functionality.

### Fixed
- Bug fixes.

### Removed
- Removed features.

### Breaking Changes
- Breaking API changes (bump major version).
-->
