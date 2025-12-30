import 'dart:convert';

import 'package:http/http.dart' as http;

class WorkerApi {
  static const String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000');

  static Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  static Map<String, String> _headers(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<List<Map<String, dynamic>>> fetchWorkers({String? token}) async {
    final response = await http.get(
      _uri('/api/workers'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách nhân viên (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];

    final decoded = jsonDecode(response.body);
    dynamic rawWorkers;
    if (decoded is Map<String, dynamic>) {
      rawWorkers = decoded['workers'];
    } else if (decoded is List) {
      rawWorkers = decoded;
    }

    if (rawWorkers is List) {
      return rawWorkers
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList(growable: false);
    }

    return const [];
  }
}
