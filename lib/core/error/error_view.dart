import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'app_exception.dart';

/// The message users see for [error], in their language.
String userMessage(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context);
  return switch (error) {
    NetworkException() => l10n.errorNetwork,
    ServerException() || ParseException() => l10n.errorServer,
    _ => l10n.errorUnknown,
  };
}

/// A centred error message with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              error is NetworkException ? Icons.wifi_off : Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(userMessage(context, error), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}
