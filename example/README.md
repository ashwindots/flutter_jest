# Example

Run the example test to see `flutter_jest_style` in action:

```sh
cd example
dart test example_test.dart
```

Or from the project root:

```sh
dart test example/example_test.dart
```

## What's demonstrated

- **Snapshot testing** — `toMatchSnapshot()` creates and compares `.snap` files
- **Mock functions** — `fn<T>()`, `mockReturnValue()`, `mockImplementation()`
- **Single-argument mocks** — `fn1<R, A>()` with `when()` / `verify()`
- **Async mocking** — `thenAnswer()` for `Future`-returning mocks
