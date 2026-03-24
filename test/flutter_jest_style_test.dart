import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  group('Awesome', () {
    final awesome = Awesome();

    test('isAwesome returns true', () {
      expect(awesome.isAwesome, isTrue);
    });
  });

  group('SnapshotMatcher', () {
    test('creates and matches a snapshot', () {
      final data = {'name': 'Jest', 'version': 1};
      expect(data, toMatchSnapshot('basic_snapshot'));
      // Second call should match the stored file.
      expect(data, toMatchSnapshot('basic_snapshot'));
    });

    test('detects snapshot mismatch', () {
      // Write initial snapshot.
      expect({'value': 'a'}, toMatchSnapshot('mismatch_test'));
      // Attempting with different data should fail.
      expect(
        () => expect({'value': 'b'}, toMatchSnapshot('mismatch_test')),
        throwsA(isA<TestFailure>()),
      );
    });
  });

  group('MockFn (jest.fn())', () {
    test('fn<T>() with stubbed return value', () {
      final myFn = fn<int>();
      mockReturnValue(myFn, 42);
      expect(myFn(), equals(42));
      verify(() => myFn()).called(1);
    });

    test('fn<T>() with fallback', () {
      final myFn = fn<String>(fallback: 'default');
      expect(myFn(), equals('default'));
    });

    test('fn1 with single argument', () {
      final handler = fn1<String, int>();
      when(() => handler(any())).thenReturn('ok');
      expect(handler(5), equals('ok'));
      verify(() => handler(5)).called(1);
    });

    test('mockImplementation provides callback', () {
      final myFn = fn<int>();
      var counter = 0;
      mockImplementation(myFn, () => ++counter);
      expect(myFn(), equals(1));
      expect(myFn(), equals(2));
    });

    test('mockReset clears stubs and calls', () {
      final myFn = fn<int>();
      mockReturnValue(myFn, 10);
      expect(myFn(), equals(10));
      mockReset(myFn);
      // After reset, calling without a stub throws.
      expect(() => myFn(), throwsA(anything));
    });
  });
}
