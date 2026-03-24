<p align="center">
  <h1 align="center">flutter_jest_style</h1>
  <p align="center">
    A <strong>Jest-like testing experience</strong> for Flutter & Dart.<br/>
    Snapshot testing · Mock helpers · Watch-mode CLI · Visual regression — all in one import.
  </p>
</p>

<p align="center">
  <a href="https://pub.dev/packages/flutter_jest_style"><img src="https://img.shields.io/pub/v/flutter_jest_style.svg" alt="pub version"></a>
  <a href="https://pub.dev/packages/flutter_jest_style/score"><img src="https://img.shields.io/pub/points/flutter_jest_style" alt="pub points"></a>
  <a href="https://pub.dev/packages/flutter_jest_style/score"><img src="https://img.shields.io/pub/popularity/flutter_jest_style" alt="popularity"></a>
  <a href="https://pub.dev/packages/flutter_jest_style/score"><img src="https://img.shields.io/pub/likes/flutter_jest_style" alt="likes"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
</p>

---

## 🤔 Why This Package?

If you're coming from JavaScript/TypeScript and miss Jest's ergonomics, this package bridges the gap:

| Jest Feature | Flutter Equivalent | This Package |
|---|---|---|
| `toMatchSnapshot()` | No built-in equivalent | ✅ `toMatchSnapshot('name')` — auto-creates & compares `.snap` files |
| `jest.fn()` | `mockito` + build_runner | ✅ `fn<T>()` — zero-codegen mock functions via `mocktail` |
| `jest --watch` | `flutter test` (manual re-run) | ✅ `fjest --watch` — auto-reruns on file save |
| `jest --updateSnapshot` | N/A | ✅ `fjest --snapshot-update` |
| `jest --coverage` | `flutter test --coverage` | ✅ `fjest --coverage` (same, wrapped) |
| Visual regression | `matchesGoldenFile()` | ✅ `goldenPath('name')` — scaffolds directories automatically |
| Single import | Multiple imports needed | ✅ One `import` gives you everything |

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_jest_style: ^1.0.0
```

Or install via the command line:

```sh
dart pub add flutter_jest_style
```

---

## 🚀 Quick Start

```dart
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  group('Calculator', () {
    test('adds two numbers', () {
      expect(1 + 2, equals(3));
    });

    test('result matches snapshot', () {
      final result = {'operation': 'add', 'a': 1, 'b': 2, 'result': 3};
      expect(result, toMatchSnapshot('calculator_add'));
    });
  });
}
```

One import. Familiar syntax. Snapshots just work.

---

## ✨ Features

### 📸 Snapshot Testing

Replicate Jest's `toMatchSnapshot()` — on the first run the snapshot file is created; subsequent runs compare against it.

```dart
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  test('user serialises correctly', () {
    final user = {'name': 'Alice', 'age': 30, 'roles': ['admin', 'editor']};
    expect(user, toMatchSnapshot('user_profile'));
  });
}
```

**File structure produced:**

```
test/
├── __snapshots__/
│   └── user_profile.snap      ← auto-generated JSON
├── my_test.dart
```

**Updating snapshots** when your data intentionally changes:

```sh
fjest --snapshot-update
```

Or programmatically in a `setUp`:

```dart
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  setUp(() => updateSnapshots = true);

  test('regenerate all snapshots', () {
    expect({'key': 'new_value'}, toMatchSnapshot('my_snapshot'));
  });
}
```

---

### 🎭 Mocking (`jest.fn()` Style)

Zero-codegen mock functions powered by `mocktail`:

```dart
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  test('fn<T>() with stubbed return', () {
    final myFn = fn<int>();
    mockReturnValue(myFn, 42);

    expect(myFn(), equals(42));
    verify(() => myFn()).called(1);
  });

  test('fn<T>() with implementation', () {
    final counter = fn<int>();
    var n = 0;
    mockImplementation(counter, () => ++n);

    expect(counter(), equals(1));
    expect(counter(), equals(2));
  });

  test('fn1 — mock with one argument', () {
    final greet = fn1<String, String>();
    when(() => greet(any())).thenReturn('Hello!');

    expect(greet('Alice'), equals('Hello!'));
    verify(() => greet('Alice')).called(1);
  });

  test('reset and clear', () {
    final myFn = fn<int>();
    mockReturnValue(myFn, 10);
    myFn();

    mockClear(myFn);   // clears calls, keeps stubs
    mockReset(myFn);    // clears everything
  });
}
```

---

### 🖼️ Visual / Golden Testing

Golden (pixel-perfect) regression testing with automatic directory scaffolding:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  testWidgets('MyButton matches golden', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MyButton())),
    );

    await expectLater(
      find.byType(MyButton),
      matchesGoldenFile(goldenPath('my_button')),
    );
  });
}
```

**File structure:**

```
test/
├── goldens/
│   └── my_button.png           ← auto-generated golden image
├── widget_test.dart
```

Generate/update golden files:

```sh
flutter test --update-goldens
```

---

### ⚡ Watch Mode CLI

The `fjest` CLI wraps `flutter test` with a Jest-inspired workflow:

```sh
# Run all tests once
fjest

# Watch mode — auto-reruns on file changes in lib/ and test/
fjest --watch

# Collect code coverage
fjest --coverage

# Regenerate all snapshots
fjest --snapshot-update

# Combine flags
fjest --watch --coverage

# Forward extra flags to flutter test
fjest -- --name "my specific test" --reporter expanded
```

---

### 📊 Coverage Reporting

```sh
# Generate coverage
fjest --coverage

# View HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🔧 Advanced Usage

### Updating Snapshots

When your data model changes intentionally:

```sh
# Update all snapshots via CLI
fjest --snapshot-update

# Or set the flag programmatically
updateSnapshots = true;
```

### Ignoring Fields in Snapshots

Sanitise volatile fields (timestamps, IDs) before snapshotting:

```dart
test('user snapshot ignoring timestamp', () {
  final user = getUser();
  final sanitised = Map<String, dynamic>.from(user)
    ..remove('createdAt')
    ..remove('id');
  expect(sanitised, toMatchSnapshot('user_no_volatile'));
});
```

### Async Testing

```dart
test('fetches data asynchronously', () async {
  final fetchData = fn<Future<String>>();
  when(() => fetchData()).thenAnswer((_) async => 'result');

  final result = await fetchData();
  expect(result, equals('result'));
  verify(() => fetchData()).called(1);
});
```

### Running in CI/CD (GitHub Actions)

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
      - run: dart pub get
      - run: dart analyze
      - run: dart format --output=none --set-exit-if-changed .
      - run: dart test
        env:
          FLUTTER_JEST_ROOT: ${{ github.workspace }}
```

> **Tip:** Setting `FLUTTER_JEST_ROOT` ensures snapshot paths resolve correctly regardless of the runner's working directory.

---

## 📖 API Reference

### Snapshot Testing

| API | Description |
|---|---|
| `toMatchSnapshot(String name)` | Matcher — compares value against `test/__snapshots__/<name>.snap`. Creates on first run. |
| `updateSnapshots` (global) | Set to `true` to overwrite all snapshots instead of comparing. |

### Mock Utilities

| API | Description |
|---|---|
| `fn<T>({T? fallback})` | Creates a zero-arg mock function (like `jest.fn()`). |
| `fn1<R, A>()` | Creates a one-arg mock function. |
| `fn2<R, A, B>()` | Creates a two-arg mock function. |
| `mockReturnValue<T>(mock, value)` | Stubs a return value (like `jest.fn().mockReturnValue()`). |
| `mockImplementation<T>(mock, impl)` | Stubs with a callback (like `jest.fn().mockImplementation()`). |
| `mockReset(mock)` | Clears all stubs and recorded calls. |
| `mockClear(mock)` | Clears recorded calls but keeps stubs. |

### Golden Utilities

| API | Description |
|---|---|
| `goldenPath(String name)` | Returns `test/goldens/<name>.png`, creating the directory if needed. |

### CLI (`fjest`)

| Flag | Description |
|---|---|
| `--watch`, `-w` | Watch mode — rerun tests on file changes. |
| `--coverage`, `-c` | Collect code coverage. |
| `--snapshot-update`, `-u` | Regenerate all snapshot files. |
| `--help`, `-h` | Print usage information. |

### Re-exports

Everything from [`package:test`](https://pub.dev/packages/test) and [`package:mocktail`](https://pub.dev/packages/mocktail) is re-exported, so you get `test()`, `group()`, `expect()`, `setUp()`, `tearDown()`, `when()`, `verify()`, `any()`, etc. with a single import.

---

## 🔄 Migration Guide — Coming from Jest?

### Basic Test Structure

<table>
<tr><th>Jest (JavaScript)</th><th>flutter_jest_style (Dart)</th></tr>
<tr>
<td>

```js
describe('Math', () => {
  test('adds 1 + 2', () => {
    expect(1 + 2).toBe(3);
  });
});
```

</td>
<td>

```dart
group('Math', () {
  test('adds 1 + 2', () {
    expect(1 + 2, equals(3));
  });
});
```

</td>
</tr>
</table>

### Snapshots

<table>
<tr><th>Jest</th><th>flutter_jest_style</th></tr>
<tr>
<td>

```js
test('matches', () => {
  expect(data).toMatchSnapshot();
});
// Run: jest --updateSnapshot
```

</td>
<td>

```dart
test('matches', () {
  expect(data, toMatchSnapshot('data'));
});
// Run: fjest --snapshot-update
```

</td>
</tr>
</table>

### Mocking

<table>
<tr><th>Jest</th><th>flutter_jest_style</th></tr>
<tr>
<td>

```js
const myFn = jest.fn();
myFn.mockReturnValue(42);
myFn();
expect(myFn).toHaveBeenCalledTimes(1);
myFn.mockReset();
```

</td>
<td>

```dart
final myFn = fn<int>();
mockReturnValue(myFn, 42);
myFn();
verify(() => myFn()).called(1);
mockReset(myFn);
```

</td>
</tr>
</table>

### Lifecycle Hooks

<table>
<tr><th>Jest</th><th>flutter_jest_style</th></tr>
<tr>
<td>

```js
beforeEach(() => { /* setup */ });
afterEach(() => { /* teardown */ });
beforeAll(() => { /* once */ });
afterAll(() => { /* once */ });
```

</td>
<td>

```dart
setUp(() { /* setup */ });
tearDown(() { /* teardown */ });
setUpAll(() { /* once */ });
tearDownAll(() { /* once */ });
```

</td>
</tr>
</table>

### Full Mapping Table

| Jest | flutter_jest_style | Notes |
|---|---|---|
| `describe()` | `group()` | |
| `test()` / `it()` | `test()` | |
| `expect(x).toBe(y)` | `expect(x, equals(y))` | |
| `expect(x).toBeTruthy()` | `expect(x, isTrue)` | |
| `expect(x).toBeNull()` | `expect(x, isNull)` | |
| `expect(x).toContain(y)` | `expect(x, contains(y))` | |
| `expect(fn).toThrow()` | `expect(() => fn(), throwsA(anything))` | |
| `expect(x).toMatchSnapshot()` | `expect(x, toMatchSnapshot('name'))` | Named snapshots |
| `jest.fn()` | `fn<T>()` | |
| `fn.mockReturnValue(v)` | `mockReturnValue(mock, v)` | |
| `fn.mockImplementation(cb)` | `mockImplementation(mock, cb)` | |
| `fn.mockReset()` | `mockReset(mock)` | |
| `fn.mockClear()` | `mockClear(mock)` | |
| `jest --watch` | `fjest --watch` | |
| `jest --updateSnapshot` | `fjest --snapshot-update` | |
| `jest --coverage` | `fjest --coverage` | |

---

## ❓ Troubleshooting

### `test/__snapshots__` directory not found in CI

**Symptom:** Snapshot path resolves to the wrong location in Docker / GitHub Actions.

**Fix:** Set the `FLUTTER_JEST_ROOT` environment variable to your project root:

```yaml
# GitHub Actions
- run: dart test
  env:
    FLUTTER_JEST_ROOT: ${{ github.workspace }}
```

```sh
# Docker / generic CI
export FLUTTER_JEST_ROOT=/app
dart test
```

### Snapshot mismatch after upgrading a dependency

**Symptom:** Tests fail with "Snapshot mismatch" after a `pub upgrade`.

**Fix:** Review the diff in the error output. If the change is expected, update snapshots:

```sh
fjest --snapshot-update
```

Then commit the updated `.snap` files.

### `MissingStubError` when calling a mock

**Symptom:** `fn<T>()` throws `MissingStubError` when called without a stub.

**Fix:** Either stub first or provide a fallback:

```dart
// Option A: stub explicitly
final myFn = fn<int>();
mockReturnValue(myFn, 0);

// Option B: use fallback parameter
final myFn = fn<int>(fallback: 0);
```

### Golden file mismatch on different platforms

**Symptom:** Golden tests pass on macOS but fail on Linux CI.

**Fix:** Generate golden files on the same platform as CI (typically Linux). Use:

```sh
# On CI
flutter test --update-goldens
```

Then commit the goldens from that environment.

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Report bugs** — Open an [issue](https://github.com/AshwiniJoshi/flutter_jest_style/issues) with steps to reproduce.
2. **Suggest features** — Describe the use case in an issue first.
3. **Submit PRs:**
   ```sh
   git clone https://github.com/AshwiniJoshi/flutter_jest_style.git
   cd flutter_jest_style
   dart pub get
   dart test          # ensure tests pass
   dart analyze       # ensure zero issues
   dart format .      # ensure code is formatted
   ```
4. Write tests for any new functionality.
5. Open a PR against `main`.

Please follow the [Dart style guide](https://dart.dev/effective-dart/style).

---

## 📄 License & Credits

MIT License — see [LICENSE](LICENSE) for details.

Built on the shoulders of:

- [`test`](https://pub.dev/packages/test) — Dart's core test framework
- [`mocktail`](https://pub.dev/packages/mocktail) — zero-codegen mocking
- [`golden_toolkit`](https://pub.dev/packages/golden_toolkit) — advanced golden testing
- [`watcher`](https://pub.dev/packages/watcher) — file-system change detection
- [`matcher`](https://pub.dev/packages/matcher) — custom matcher foundations
