import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../logging/app_logger.dart';
import 'http_client_web.dart' if (dart.library.io) 'http_client_io.dart';

/// JSON over HTTP, with every failure turned into an [AppException].
class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.client,
    this.logger = const AppLogger(enabled: false),
    this.timeout = const Duration(seconds: 20),
  });

  final Uri baseUrl;
  final http.Client client;
  final AppLogger logger;
  final Duration timeout;

  /// GETs [path] relative to [baseUrl] and decodes the JSON body.
  Future<Object?> getJson(String path, {Map<String, String>? query}) async {
    final uri = baseUrl.replace(
      path: '${baseUrl.path}$path',
      queryParameters: query,
    );
    logger.info('GET $uri');
    final http.Response response;
    try {
      response = await client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on TimeoutException {
      throw NetworkException('GET $uri timed out after $timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('GET $uri failed: ${e.message}');
    } on Exception catch (e) {
      // For example a TLS handshake failure when the pinned certificate
      // doesn't match, which the http package doesn't wrap.
      throw NetworkException('GET $uri failed: $e');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      logger.warning('GET $uri returned ${response.statusCode}');
      throw ServerException(response.statusCode, 'GET $uri');
    }
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException catch (e) {
      throw ParseException('GET $uri returned invalid JSON: ${e.message}');
    }
  }

  void close() => client.close();
}

/// The certificate to pin, loaded in `main.dart` before the app starts.
final pinnedCertificateProvider = Provider<List<int>?>((ref) => null);

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ApiClient(
    baseUrl: config.apiBaseUrl,
    client: createPlatformHttpClient(
      pinnedCertificate: ref.watch(pinnedCertificateProvider),
      connectTimeout: const Duration(seconds: 10),
    ),
    logger: ref.watch(loggerProvider),
  );
  ref.onDispose(client.close);
  return client;
});
