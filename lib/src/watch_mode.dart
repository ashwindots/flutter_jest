import 'dart:async';
import 'dart:io';

import 'package:watcher/watcher.dart';

/// Watches `lib/` and `test/` directories and reruns `flutter test`
/// whenever a Dart file changes — replicating Jest's watch mode.
///
/// Call [startWatchMode] from the CLI entry point.
Future<void> startWatchMode({
  List<String> extraArgs = const [],
  String? projectRoot,
}) async {
  final root = projectRoot ?? Directory.current.path;
  final dirs = [Directory('$root/lib'), Directory('$root/test')];

  _printBanner();

  // Debounce rapid successive changes.
  Timer? debounce;

  for (final dir in dirs) {
    if (!dir.existsSync()) continue;

    final watcher = DirectoryWatcher(dir.path);
    watcher.events.listen((event) {
      if (!event.path.endsWith('.dart')) return;

      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        _runTests(extraArgs, root);
      });
    });
  }

  stdout.writeln('Watching for changes in lib/ and test/...');
  stdout.writeln('Press Ctrl+C to exit.\n');

  // Run tests once immediately so the user sees initial results.
  await _runTests(extraArgs, root);

  // Keep the process alive.
  await Completer<void>().future;
}

void _printBanner() {
  stdout.writeln('''
\x1B[1;36m
 ╔═══════════════════════════════════════╗
 ║     🧪  flutter_jest_style            ║
 ║         Watch Mode                    ║
 ╚═══════════════════════════════════════╝
\x1B[0m''');
}

Future<void> _runTests(List<String> extraArgs, String root) async {
  stdout.writeln('\x1B[33m--- Running tests... ---\x1B[0m\n');

  final result = await Process.run(
    'flutter',
    ['test', ...extraArgs],
    workingDirectory: root,
    runInShell: true,
  );

  stdout.write(result.stdout);
  if ((result.stderr as String).isNotEmpty) {
    stderr.write(result.stderr);
  }

  final code = result.exitCode;
  if (code == 0) {
    stdout.writeln('\x1B[32m✓ Tests passed\x1B[0m\n');
  } else {
    stdout.writeln('\x1B[31m✗ Tests failed (exit code $code)\x1B[0m\n');
  }
}
