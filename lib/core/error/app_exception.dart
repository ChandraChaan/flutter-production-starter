/// Every error the data layer throws, so the UI can switch over a closed
/// set instead of guessing from strings.
sealed class AppException implements Exception {
  const AppException(this.debugMessage);

  /// For logs and crash reports, never shown to users.
  final String debugMessage;

  @override
  String toString() => '$runtimeType: $debugMessage';
}

/// No connection, DNS failure, timeout or a failed SSL pin.
final class NetworkException extends AppException {
  const NetworkException(super.debugMessage);
}

/// The server answered with an error status.
final class ServerException extends AppException {
  const ServerException(this.statusCode, super.debugMessage);

  final int statusCode;

  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401 || statusCode == 403;
}

/// The server answered, but not with what the app expected.
final class ParseException extends AppException {
  const ParseException(super.debugMessage);
}
