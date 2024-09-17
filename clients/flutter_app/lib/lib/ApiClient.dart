import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../globals.dart' as globals;

class ApiClient {
  final String? host = dotenv.env['API_HOST'];
  final String scheme = 'https';

  Future<http.Response> post(
      String? path,
      [Object? body,
      Map<String, String>? headers]
  ) {
    return http.post(
      Uri.parse('https://' + host! + path!),
      body: body,
      headers: addDefaultHeaders(headers),
    );
  }

  Future<http.Response> get(
      String? path,
      [Map<String, String>? headers]
  ) {
    return http.get(
      Uri.parse('https://' + host! + path!),
      headers: addDefaultHeaders(headers),
    );
  }

  Future<http.Response> delete(
      String? path,
      [Map<String, String>? headers]
  ) {
    return http.delete(
      Uri.parse('https://' + host! + path!),
      headers: addDefaultHeaders(headers),
    );
  }

  addDefaultHeaders(Map<String, String>? headers) {
    Map<String, String> headersToSend = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (globals.token != null) {
      headersToSend.addEntries([
        MapEntry('Authorization', 'Bearer ' + globals.token!)
      ]);
    }

    if (headers != null) {
      headersToSend.addEntries(headers.entries);
    }

    return headersToSend;
  }
}