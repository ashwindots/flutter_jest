/// A Jest-like testing experience for Flutter & Dart.
///
/// Import this single file to access snapshot matchers, mock helpers,
/// golden-file utilities, and re-exports of the core test APIs.
///
/// ```dart
/// import 'package:flutter_jest_style/flutter_jest_style.dart';
/// ```
library;

// Re-export the core Dart test package.
export 'package:test/test.dart' hide isInstanceOf;

// Re-export mocktail so users don't need a separate import for
// when / verify / any / etc.
export 'package:mocktail/mocktail.dart';

// --- Package features ---
export 'src/snapshot_matcher.dart';
export 'src/mock_utils.dart';
export 'src/golden_utils.dart';
export 'src/flutter_jest_style_base.dart';
