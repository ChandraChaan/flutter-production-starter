import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// On Android, iOS and desktop: when [pinnedCertificate] is given, trust
/// only certificate chains that include it, instead of the system's trusted
/// roots.
http.Client createPlatformHttpClient({
  List<int>? pinnedCertificate,
  required Duration connectTimeout,
}) {
  final SecurityContext? context = pinnedCertificate == null
      ? null
      : (SecurityContext(withTrustedRoots: false)
          ..setTrustedCertificatesBytes(pinnedCertificate));
  final client = HttpClient(context: context)
    ..connectionTimeout = connectTimeout;
  return IOClient(client);
}
