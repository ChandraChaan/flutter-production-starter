import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/crash/crash_reporter.dart';
import 'core/network/api_client.dart';

/// Run with an environment file:
///
/// ```bash
/// flutter run --dart-define-from-file=env/dev.json
/// ```
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      pinnedCertificateProvider.overrideWithValue(
        await _loadPinnedCertificate(config),
      ),
    ],
    // Errors show a "Try again" button instead of retrying silently.
    retry: (retryCount, error) => null,
  );

  final crashReporter = container.read(crashReporterProvider);
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    crashReporter.recordError(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    crashReporter.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

Future<List<int>?> _loadPinnedCertificate(AppConfig config) async {
  final asset = config.pinnedCertificateAsset;
  if (asset == null || kIsWeb) return null;
  final data = await rootBundle.load(asset);
  return data.buffer.asUint8List();
}
