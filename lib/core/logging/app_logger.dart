import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// A small logger that stays silent unless logging is enabled for the
/// environment, so production builds don't print request details.
class AppLogger {
  const AppLogger({required this.enabled});

  final bool enabled;

  void info(String message) {
    if (enabled) debugPrint('[info] $message');
  }

  void warning(String message) {
    if (enabled) debugPrint('[warn] $message');
  }
}

final loggerProvider = Provider<AppLogger>(
  (ref) => AppLogger(enabled: ref.watch(appConfigProvider).enableLogging),
);
