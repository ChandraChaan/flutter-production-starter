# Flutter Production Starter

[![CI](https://github.com/ChandraChaan/flutter-production-starter/actions/workflows/ci.yml/badge.svg)](https://github.com/ChandraChaan/flutter-production-starter/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
![Flutter](https://img.shields.io/badge/Flutter-3.44%2B-02569B?logo=flutter)

A small, real Flutter app that starts where most tutorials stop. Clone it, rename it, and build your features on decisions that already hold up in production.

> Click **Use this template** at the top of this page to start your own app from it.

## What's inside

| Concern | How it's handled |
|---|---|
| **Architecture** | Feature-first folders, each split into `domain`, `data` and `presentation`. Screens depend on interfaces, never on HTTP. |
| **State** | [Riverpod 3](https://riverpod.dev): `AsyncNotifier` for loading data, `Notifier` for settings, and overrides for tests. |
| **Navigation** | [go_router](https://pub.dev/packages/go_router) with deep-linkable routes (`/articles/42`). |
| **Environments** | `env/dev.json`, `env/staging.json`, `env/prod.json` passed with `--dart-define-from-file`. No secrets in code. |
| **Networking** | One `ApiClient` with timeouts, UTF-8 decoding and every failure mapped to a typed error. |
| **Errors** | A sealed `AppException` (`NetworkException`, `ServerException`, `ParseException`), friendly translated messages, and a **Try again** button instead of silent retries. |
| **SSL pinning** | Optional certificate pinning on Android, iOS and desktop, switched on per environment. |
| **Crash reporting** | Uncaught errors from Flutter and the platform go to one `CrashReporter`, ready to swap for Crashlytics or Sentry. |
| **Localization** | English and Hindi with `gen-l10n`, switchable at runtime. |
| **Theming** | Material 3, light and dark, from one seed color. |
| **Logging** | Quiet in production, detailed in dev and staging. |
| **Tests** | Unit tests for the API client and controller, plus widget tests that drive the whole app with a fake repository. |
| **CI** | GitHub Actions: format, analyze, test and a release web build on every push. |

The sample feature lists articles from [JSONPlaceholder](https://jsonplaceholder.typicode.com) so it runs straight away. Replace it with your own API.

## Run it

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

Build for production:

```bash
flutter build apk --release --dart-define-from-file=env/prod.json
flutter build ipa --release --dart-define-from-file=env/prod.json
```

## Project structure

```
lib/
├── main.dart                 # Bootstrap: config, crash reporting, ProviderScope
├── app/                      # App widget, router, theme and settings state
├── core/
│   ├── config/               # AppConfig from the environment file
│   ├── crash/                # CrashReporter interface
│   ├── error/                # AppException types and the shared error view
│   ├── logging/              # Environment-aware logger
│   └── network/              # ApiClient and the (optionally pinned) HTTP client
├── features/
│   ├── articles/
│   │   ├── domain/           # Article model and ArticleRepository interface
│   │   ├── data/             # HttpArticleRepository
│   │   └── presentation/     # Controller and screens
│   └── settings/
└── l10n/                     # ARB files and generated localizations
```

To add a feature, copy `features/articles`, define the repository interface in `domain`, implement it in `data`, and add a route in `app/router.dart`.

## Make it yours

1. Click **Use this template** and clone your new repository.
2. Rename the Dart package: change `name:` in `pubspec.yaml`, then replace `package:flutter_production_starter/` across `test/`.
3. Change the app ID: `applicationId` and `namespace` in `android/app/build.gradle.kts`, and `PRODUCT_BUNDLE_IDENTIFIER` in Xcode.
4. Set your API URLs in `env/*.json`.
5. Change the seed color in `lib/app/theme.dart` and the strings in `lib/l10n/`.

## Environments

Each JSON file in `env/` becomes compile-time constants read by `AppConfig.fromEnvironment()`:

```json
{
  "APP_ENV": "prod",
  "API_BASE_URL": "https://api.example.com",
  "ENABLE_LOGGING": false,
  "PINNED_CERT_ASSET": ""
}
```

Don't commit real secrets. For CI, generate the production file from your secret store before building.

## SSL pinning

Pinning makes the app trust only your server's certificate chain, which protects API traffic on compromised networks.

1. Get the certificate to pin. Pin an **intermediate or root CA** certificate, not your leaf certificate, so routine certificate renewals don't break the app:
   ```bash
   openssl s_client -connect api.example.com:443 -showcerts </dev/null
   ```
   Save the CA certificate block as `assets/certs/api-ca.pem`.
2. Set `"PINNED_CERT_ASSET": "assets/certs/api-ca.pem"` in the environment file.
3. Test that a request to a different host fails with a `NetworkException`.

The app then trusts only chains that include that certificate. Plan certificate rotation before the CA changes, and keep a way to ship an update. Pinning isn't possible on the web, where the browser handles TLS.

## Crash reporting

`main.dart` sends `FlutterError.onError` and `PlatformDispatcher.onError` to `crashReporterProvider`. To use Firebase Crashlytics, implement the interface and override the provider:

```dart
class CrashlyticsReporter implements CrashReporter {
  @override
  Future<void> recordError(Object error, StackTrace? stack, {bool fatal = false}) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
}

// In main(), add to the ProviderContainer overrides:
crashReporterProvider.overrideWithValue(CrashlyticsReporter()),
```

Sentry works the same way, with `Sentry.captureException`.

## Testing

```bash
flutter test
```

Widget tests run the real app with `articleRepositoryProvider` overridden by a `FakeArticleRepository`, so they cover routing, loading, errors, retry and localization without a network. See `test/helpers.dart`.

## About the author

Built by [Chandra ObulaReddy](https://chandrachaan.com), a Flutter architect with 8+ years of shipping FinTech, HealthTech and EdTech apps used by 100K+ people. Questions and ideas are welcome in [Discussions](https://github.com/ChandraChaan/flutter-production-starter/discussions).
