import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where uncaught errors go.
///
/// The starter ships with [ConsoleCrashReporter] so it runs without any
/// account. Implement this with Firebase Crashlytics or Sentry for
/// production; see README, "Crash reporting".
abstract interface class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  });
}

class ConsoleCrashReporter implements CrashReporter {
  const ConsoleCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    debugPrint('${fatal ? 'FATAL' : 'ERROR'}: $error');
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
  }
}

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => const ConsoleCrashReporter(),
);
