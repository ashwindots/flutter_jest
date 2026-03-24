import 'package:mocktail/mocktail.dart';

/// A generic mock callable that mimics Jest's `jest.fn()`.
///
/// Usage:
/// ```dart
/// final myFn = fn<int>();
///
/// // Stub a return value (like jest.fn().mockReturnValue(42))
/// when(() => myFn()).thenReturn(42);
///
/// // Call it
/// final result = myFn();
///
/// // Verify it was called
/// verify(() => myFn()).called(1);
/// ```
///
/// If no stub is set, calling the mock throws a [MissingStubError] by
/// default.  Use [fn]'s optional [fallback] parameter to provide a
/// default return value instead.
MockFn<T> fn<T>({T? fallback}) {
  final mock = MockFn<T>();
  if (fallback is T) {
    when(() => mock.call()).thenReturn(fallback);
  }
  return mock;
}

/// A mock callable with zero arguments — the workhorse behind [fn].
class MockFn<T> extends Mock {
  /// Invokes the mock and returns the stubbed value.
  T call();
}

/// A mock callable that accepts one argument.
///
/// ```dart
/// final handler = fn1<String, int>();
/// when(() => handler(any())).thenReturn('ok');
/// ```
MockFn1<R, A> fn1<R, A>() => MockFn1<R, A>();

/// A mock callable that accepts one argument.
class MockFn1<R, A> extends Mock {
  /// Invokes the mock with [arg] and returns the stubbed value.
  R call(A arg);
}

/// A mock callable that accepts two arguments.
MockFn2<R, A, B> fn2<R, A, B>() => MockFn2<R, A, B>();

/// A mock callable that accepts two arguments.
class MockFn2<R, A, B> extends Mock {
  /// Invokes the mock with [a] and [b] and returns the stubbed value.
  R call(A a, B b);
}

/// Jest-style `mockReturnValue` — syntactic sugar over `mocktail`'s
/// `when().thenReturn()`.
///
/// ```dart
/// final myFn = fn<int>();
/// mockReturnValue(myFn, 42);
/// expect(myFn(), equals(42));
/// ```
void mockReturnValue<T>(MockFn<T> mock, T value) {
  when(() => mock.call()).thenReturn(value);
}

/// Jest-style `mockImplementation` — provides a callback that is invoked
/// every time the mock is called.
///
/// ```dart
/// final myFn = fn<int>();
/// mockImplementation(myFn, () => DateTime.now().millisecond);
/// ```
void mockImplementation<T>(MockFn<T> mock, T Function() impl) {
  when(() => mock.call()).thenAnswer((_) => impl());
}

/// Resets all recorded calls and stubs on a mock function, equivalent to
/// Jest's `jest.fn().mockReset()`.
void mockReset(Mock mock) {
  reset(mock);
}

/// Clears recorded calls but keeps stubs, like Jest's
/// `jest.fn().mockClear()`.
void mockClear(Mock mock) {
  clearInteractions(mock);
}
