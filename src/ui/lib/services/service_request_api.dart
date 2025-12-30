import 'dart:convert';

import 'package:http/http.dart' as http;

class ServiceRequestApi {
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

  static Future<void> createRequest({
    required String district,
    required String address,
    String? note,
    String? token,
  }) async {
    final response = await http.post(
      _uri('/api/services'),
      headers: _headers(token),
      body: jsonEncode({
        'district': district,
        'address': address,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      }),
    );

    if (response.statusCode == 201) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể đăng ký dịch vụ (${response.statusCode})',
    );
  }

}
