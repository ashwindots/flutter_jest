import 'dart:convert';
import 'dart:io';

import 'package:matcher/matcher.dart';
import 'package:path/path.dart' as p;

/// A flag that, when set to `true`, causes every snapshot assertion to
/// overwrite the stored snapshot file instead of comparing against it.
/// Typically toggled via the `--snapshot-update` CLI flag.
bool updateSnapshots = false;

/// Environment-variable override for the project root directory.
/// Useful in CI/CD where the working directory may differ.
const String _envRoot = 'FLUTTER_JEST_ROOT';

/// Resolves the project root directory reliably across local and CI
/// environments.
///
/// Resolution order:
/// 1. The `FLUTTER_JEST_ROOT` environment variable (CI-friendly).
/// 2. Walk up from [Platform.script] looking for `pubspec.yaml`.
/// 3. Fall back to the current working directory.
String _resolveProjectRoot() {
  final envRoot = Platform.environment[_envRoot];
  if (envRoot != null && envRoot.isNotEmpty) {
    return envRoot;
  }

  // Walk up from the script location to find pubspec.yaml
  var dir = Directory.current.path;

  // If running via `dart test`, Platform.script points into .dart_tool;
  // walk up until we find pubspec.yaml.
  final scriptPath = Platform.script.toFilePath();
  if (scriptPath.isNotEmpty) {
    var candidate = File(scriptPath).parent.path;
    for (var i = 0; i < 10; i++) {
      if (File(p.join(candidate, 'pubspec.yaml')).existsSync()) {
        return candidate;
      }
      final parent = p.dirname(candidate);
      if (parent == candidate) break; // reached filesystem root
      candidate = parent;
    }
  }

  // Fallback: walk up from cwd
  for (var i = 0; i < 10; i++) {
    if (File(p.join(dir, 'pubspec.yaml')).existsSync()) {
      return dir;
    }
    final parent = p.dirname(dir);
    if (parent == dir) break;
    dir = parent;
  }

  return Directory.current.path;
}

/// Returns the canonical path to the `test/__snapshots__` directory,
/// creating it if it doesn't exist.
String _snapshotsDir() {
  final root = _resolveProjectRoot();
  final dir = p.join(root, 'test', '__snapshots__');
  final d = Directory(dir);
  if (!d.existsSync()) {
    d.createSync(recursive: true);
  }
  return dir;
}

/// Sanitises a snapshot [name] into a safe filename.
String _sanitiseName(String name) => name.replaceAll(RegExp(r'[^\w\-.]'), '_');

/// Attempts to produce a stable JSON-encoded string of [value].
///
/// Falls back to [value.toString()] when JSON encoding fails.
String _serialize(dynamic value) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  } catch (_) {
    return value.toString();
  }
}

/// Jest-style `toMatchSnapshot()` matcher.
///
/// Usage:
/// ```dart
/// expect(myObject, toMatchSnapshot('my_snapshot'));
/// ```
///
/// On the first run the snapshot file is created automatically.
/// Subsequent runs compare against the stored snapshot. Pass
/// `--snapshot-update` (or set [updateSnapshots] = true) to regenerate.
Matcher toMatchSnapshot(String name) => _SnapshotMatcher(name);

class _SnapshotMatcher extends Matcher {
  _SnapshotMatcher(this._name);

  final String _name;

  late final String _snapshotPath = p.join(
    _snapshotsDir(),
    '${_sanitiseName(_name)}.snap',
  );

  @override
  bool matches(dynamic item, Map matchState) {
    final serialized = _serialize(item);
    final file = File(_snapshotPath);

    if (updateSnapshots || !file.existsSync()) {
      // First run or explicit update — write the snapshot.
      file.writeAsStringSync(serialized);
      return true;
    }

    final stored = file.readAsStringSync();
    if (stored == serialized) return true;

    matchState['expected'] = stored;
    matchState['actual'] = serialized;
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('matches snapshot "$_name"');

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    final expected = matchState['expected'] as String?;
    final actual = matchState['actual'] as String?;
    if (expected != null && actual != null) {
      mismatchDescription
          .add('Snapshot mismatch for "$_name".\n')
          .add('--- Stored snapshot ---\n$expected\n')
          .add('--- Received value ---\n$actual\n')
          .add(
            '\nRun with --snapshot-update (or set updateSnapshots = true) '
            'to accept the new snapshot.',
          );
    }
    return mismatchDescription;
  }
}
