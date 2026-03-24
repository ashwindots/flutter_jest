// ignore_for_file: unused_local_variable
import 'package:flutter_jest_style/flutter_jest_style.dart';

void main() {
  // ── Snapshot testing ────────────────────────────────────
  test('user data matches snapshot', () {
    final user = {'name': 'Alice', 'age': 30};
    expect(user, toMatchSnapshot('user_data'));
  });

  // ── Mock functions (jest.fn style) ─────────────────────
  test('mock function returns stubbed value', () {
    final myFn = fn<int>();
    mockReturnValue(myFn, 42);

    expect(myFn(), equals(42));
    verify(() => myFn()).called(1);
  });

  test('mock with implementation', () {
    final counter = fn<int>();
    var n = 0;
    mockImplementation(counter, () => ++n);

    expect(counter(), 1);
    expect(counter(), 2);
  });

  // ── Single-argument mock ──────────────────────────────
  test('fn1 mock with argument', () {
    final handler = fn1<String, int>();
    when(() => handler(any())).thenReturn('ok');

    expect(handler(5), equals('ok'));
    verify(() => handler(5)).called(1);
  });
}
