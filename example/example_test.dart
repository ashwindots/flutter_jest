// ignore_for_file: unused_local_variable
import 'package:flutter_jest_style/flutter_jest_style.dart';

// ─── Example class to test ───────────────────────────────────────

/// A simple user model for demonstration.
class User {
  /// Creates a [User] with the given [name] and [age].
  User(this.name, this.age);

  /// The user's name.
  final String name;

  /// The user's age.
  final int age;

  /// Converts this user to a JSON-compatible map.
  Map<String, dynamic> toJson() => {'name': name, 'age': age};
}

// ─── Tests ───────────────────────────────────────────────────────

void main() {
  // ── 📸 Snapshot Testing ──────────────────────────────────────
  // Like Jest's `expect(data).toMatchSnapshot()`.
  // First run: creates test/__snapshots__/user_alice.snap
  // Later runs: compares against the stored snapshot.
  // Update: run `fjest --snapshot-update`
  group('Snapshot Testing', () {
    test('user JSON matches snapshot', () {
      final alice = User('Alice', 30);
      expect(alice.toJson(), toMatchSnapshot('user_alice'));
    });

    test('list of users matches snapshot', () {
      final users = [User('Alice', 30).toJson(), User('Bob', 25).toJson()];
      expect(users, toMatchSnapshot('user_list'));
    });
  });

  // ── 🎭 Mock Functions (jest.fn() style) ──────────────────────
  // Like Jest's `const myFn = jest.fn()`
  group('Mocking', () {
    test('fn<T>() — basic mock with stubbed return value', () {
      // jest.fn()  →  fn<int>()
      final myFn = fn<int>();

      // jest.fn().mockReturnValue(42)  →  mockReturnValue(myFn, 42)
      mockReturnValue(myFn, 42);

      // Call and assert
      expect(myFn(), equals(42));

      // expect(myFn).toHaveBeenCalledTimes(1)  →  verify().called(1)
      verify(() => myFn()).called(1);
    });

    test('fn<T>() — mock with implementation', () {
      // jest.fn().mockImplementation(() => counter++)
      final counter = fn<int>();
      var n = 0;
      mockImplementation(counter, () => ++n);

      expect(counter(), equals(1));
      expect(counter(), equals(2));
      expect(counter(), equals(3));
    });

    test('fn<T>() — default fallback value', () {
      // Provide a fallback so calling without a stub doesn't throw
      final myFn = fn<String>(fallback: 'default');
      expect(myFn(), equals('default'));
    });

    test('fn1<R, A>() — mock with one argument', () {
      final greet = fn1<String, String>();

      // jest.fn().mockImplementation(name => `Hello ${name}`)
      when(() => greet(any())).thenReturn('Hello!');

      expect(greet('Alice'), equals('Hello!'));
      verify(() => greet('Alice')).called(1);
    });

    test('fn2<R, A, B>() — mock with two arguments', () {
      final add = fn2<int, int, int>();
      when(() => add(any(), any())).thenReturn(10);

      expect(add(3, 7), equals(10));
      verify(() => add(3, 7)).called(1);
    });

    test('mockReset — clears stubs and calls', () {
      final myFn = fn<int>();
      mockReturnValue(myFn, 99);
      expect(myFn(), equals(99));

      // jest.fn().mockReset()  →  mockReset(myFn)
      mockReset(myFn);

      // After reset, calling without a stub throws
      expect(() => myFn(), throwsA(anything));
    });

    test('mockClear — clears calls but keeps stubs', () {
      final myFn = fn<int>();
      mockReturnValue(myFn, 5);
      myFn(); // call once

      // jest.fn().mockClear()  →  mockClear(myFn)
      mockClear(myFn);

      // Stub still works
      expect(myFn(), equals(5));
      // Only one call recorded since clear
      verify(() => myFn()).called(1);
    });
  });

  // ── ⏳ Async Mocking ─────────────────────────────────────────
  group('Async Mocking', () {
    test('mock an async service call', () async {
      final fetchUser = fn<Future<Map<String, dynamic>>>();

      // Mock an async return
      when(
        () => fetchUser(),
      ).thenAnswer((_) async => {'name': 'Alice', 'age': 30});

      final result = await fetchUser();
      expect(result['name'], equals('Alice'));
      verify(() => fetchUser()).called(1);
    });
  });

  // ── 🖼️ Golden Path Helper ────────────────────────────────────
  // goldenPath('name') returns 'test/goldens/name.png' and creates
  // the directory. Use with Flutter's matchesGoldenFile() in widget
  // tests.
  group('Golden Utility', () {
    test('goldenPath returns correct path', () {
      final path = goldenPath('my_widget');
      expect(path, contains('test'));
      expect(path, contains('goldens'));
      expect(path, endsWith('my_widget.png'));
    });
  });
}
