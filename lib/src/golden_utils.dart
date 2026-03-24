import 'dart:io';

import 'package:path/path.dart' as p;

/// A utility for visual (golden) snapshot testing that works without
/// depending on Flutter at the library level.
///
/// When used in a Flutter test file, call Flutter's
/// `matchesGoldenFile()` directly.  This helper provides the
/// conventional file-path resolution and directory scaffolding so
/// that golden files live in `test/goldens/`.
///
/// Example (inside a `flutter_test` environment):
///
/// ```dart
/// import 'package:flutter_test/flutter_test.dart';
/// import 'package:flutter_jest_style/flutter_jest_style.dart';
///
/// void main() {
///   testWidgets('Button matches golden', (tester) async {
///     await tester.pumpWidget(const MyButton());
///     await expectLater(
///       find.byType(MyButton),
///       matchesGoldenFile(goldenPath('my_button')),
///     );
///   });
/// }
/// ```

/// Returns the canonical golden-file path for [name] inside
/// `test/goldens/`, creating the directory if it doesn't exist.
///
/// The returned path is relative to the project root so it works
/// with `matchesGoldenFile()` from `flutter_test`.
String goldenPath(String name) {
  final dir = p.join('test', 'goldens');
  final d = Directory(dir);
  if (!d.existsSync()) {
    d.createSync(recursive: true);
  }
  final safeName = name.replaceAll(RegExp(r'[^\w\-.]'), '_');
  return p.join(dir, '$safeName.png');
}
