import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await createSSLPinningClient();
  static Future<http.Client> createSSLPinningClient({
    ByteData? customCert,
  }) async {
    try {
      ByteData sslCert;
      try {
        sslCert = customCert ??
            await rootBundle.load('packages/core/assets/certificates/certificates.pem');
      } catch (_) {
        sslCert = customCert ??
            await rootBundle.load('assets/certificates/certificates.pem');
      }

      final securityContext = SecurityContext(withTrustedRoots: false);
      securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

      final httpClient = HttpClient(context: securityContext);
      return IOClient(httpClient);

    } catch (e) {
      throw Exception('Failed to initialize SSL Pinning client: $e');
    }
  }

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
