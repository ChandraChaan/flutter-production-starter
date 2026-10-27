import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment { dev, staging, prod }

/// Settings that change between environments.
///
/// They come from `--dart-define-from-file=env/<environment>.json` at build
/// time, so secrets never live in the source code and each build is fixed to
/// one environment.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = false,
    this.pinnedCertificateAsset,
  });

  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    const pinned = String.fromEnvironment('PINNED_CERT_ASSET');
    return AppConfig(
      environment: AppEnvironment.values.firstWhere(
        (e) => e.name == env,
        orElse: () => AppEnvironment.dev,
      ),
      apiBaseUrl: Uri.parse(
        const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://jsonplaceholder.typicode.com',
        ),
      ),
      enableLogging: const bool.fromEnvironment('ENABLE_LOGGING'),
      pinnedCertificateAsset: pinned.isEmpty ? null : pinned,
    );
  }

  final AppEnvironment environment;
  final Uri apiBaseUrl;
  final bool enableLogging;

  /// An asset path to a PEM certificate. When set, the app only trusts
  /// servers whose certificate chain includes it. See README, "SSL pinning".
  final String? pinnedCertificateAsset;

  bool get isProduction => environment == AppEnvironment.prod;
}

/// Overridden in `main.dart` with the real configuration.
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('Override appConfigProvider in main()'),
);
