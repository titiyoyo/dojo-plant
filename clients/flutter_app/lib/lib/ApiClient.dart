import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final String? host = dotenv.env['API_HOST'];

  Future<http.Response> post(
      String? path,
      [Object? body,
      Map<String, String>? headers]
  ) {
    Future<http.Response> response = http.post(
      Uri(
          scheme: 'https',
          host: host,
          path: path
      ),
      body: body,
      headers: headers,
    );

    return response;
  }

  Future<http.Response> get(
      String? path,
      [Map<String, String>? headers]
  ) {
    return http.get(
      Uri(
          scheme: 'https',
          host: host,
          path: path
      ),
      headers: headers,
    );
  }

  Future<http.Response> delete(
      String? path,
      [Map<String, String>? headers]
  ) {
    return http.delete(
      Uri(
          scheme: 'https',
          host: host,
          path: path
      ),
      headers: headers,
    );
  }
}