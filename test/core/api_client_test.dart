import 'dart:async';
import 'dart:convert';

import 'package:flutter_production_starter/core/error/app_exception.dart';
import 'package:flutter_production_starter/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ApiClient _client(MockClientHandler handler, {Duration? timeout}) => ApiClient(
  baseUrl: Uri.parse('https://api.example.com/v1'),
  client: MockClient(handler),
  timeout: timeout ?? const Duration(seconds: 5),
);

void main() {
  test('builds the URL from the base URL and decodes JSON', () async {
    late Uri requested;
    final api = _client((request) async {
      requested = request.url;
      return http.Response('{"ok": true}', 200);
    });
    expect(await api.getJson('/posts', query: {'page': '2'}), {'ok': true});
    expect(requested.toString(), 'https://api.example.com/v1/posts?page=2');
  });

  test('decodes UTF-8 bodies even without a charset header', () async {
    final api = _client(
      (_) async => http.Response.bytes(utf8.encode('{"name": "हिन्दी"}'), 200),
    );
    expect(await api.getJson('/x'), {'name': 'हिन्दी'});
  });

  test('turns error statuses into ServerException', () async {
    final api = _client((_) async => http.Response('nope', 404));
    await expectLater(
      api.getJson('/missing'),
      throwsA(
        isA<ServerException>().having(
          (e) => e.isNotFound,
          'isNotFound',
          isTrue,
        ),
      ),
    );
  });

  test('turns invalid JSON into ParseException', () async {
    final api = _client((_) async => http.Response('<html>', 200));
    await expectLater(api.getJson('/x'), throwsA(isA<ParseException>()));
  });

  test('turns connection failures into NetworkException', () async {
    final api = _client((_) async => throw http.ClientException('offline'));
    await expectLater(api.getJson('/x'), throwsA(isA<NetworkException>()));
  });

  test('turns timeouts into NetworkException', () async {
    final api = _client(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 10),
    );
    await expectLater(api.getJson('/x'), throwsA(isA<NetworkException>()));
  });
}
