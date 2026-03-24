import 'dart:io';

import 'package:args/args.dart';

import 'package:flutter_jest_style/src/snapshot_matcher.dart' as snap;
import 'package:flutter_jest_style/src/watch_mode.dart' as wm;

/// Jest-style CLI wrapper around `flutter test`.
///
/// Usage:
///   fjest                    # run all tests
///   fjest --watch            # watch mode
///   fjest --coverage         # collect coverage
///   fjest --snapshot-update  # regenerate all snapshots
///   fjest -- path/to/test.dart  # pass extra args to flutter test
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('watch', abbr: 'w', help: 'Re-run tests on file changes.')
    ..addFlag('coverage', abbr: 'c', help: 'Collect code coverage.')
    ..addFlag(
      'snapshot-update',
      abbr: 'u',
      help: 'Update all snapshots instead of comparing.',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.');

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(parser.usage);
    exit(64);
  }

  if (results.flag('help')) {
    _printBanner();
    stdout.writeln('Usage: fjest [options] [-- flutter test args]\n');
    stdout.writeln(parser.usage);
    return;
  }

  final doWatch = results.flag('watch');
  final doCoverage = results.flag('coverage');
  final doSnapshotUpdate = results.flag('snapshot-update');

  if (doSnapshotUpdate) {
    snap.updateSnapshots = true;
  }

  // Remaining args are forwarded to `flutter test`.
  final extraArgs = <String>[if (doCoverage) '--coverage', ...results.rest];

  _printBanner();

  if (doWatch) {
    await wm.startWatchMode(extraArgs: extraArgs);
  } else {
    await _runOnce(extraArgs);
  }
}

void _printBanner() {
  stdout.writeln('''
\x1B[1;36m
 ╔═══════════════════════════════════════╗
 ║     🧪  flutter_jest_style            ║
 ║         Jest-like testing for Flutter ║
 ╚═══════════════════════════════════════╝
\x1B[0m''');
}

Future<void> _runOnce(List<String> extraArgs) async {
  final result = await Process.run('flutter', [
    'test',
    ...extraArgs,
  ], runInShell: true);

  stdout.write(result.stdout);
  if ((result.stderr as String).isNotEmpty) {
    stderr.write(result.stderr);
  }

  exitCode = result.exitCode;
}
