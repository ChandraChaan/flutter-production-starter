import 'package:http/http.dart' as http;

/// On the web the browser owns TLS, so certificate pinning isn't possible
/// and [pinnedCertificate] is ignored.
http.Client createPlatformHttpClient({
  List<int>? pinnedCertificate,
  required Duration connectTimeout,
}) => http.Client();
