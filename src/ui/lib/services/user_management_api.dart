import 'dart:convert';

import 'package:http/http.dart' as http;

class UserManagementApi {
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

  static Future<void> updateStatus({
    required String userId,
    required bool isActive,
    String? token,
  }) async {
    final response = await http.put(
      _uri('/api/users/$userId/status'),
      headers: _headers(token),
      body: jsonEncode({'is_active': isActive}),
    );

    if (response.statusCode == 204) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể cập nhật trạng thái (${response.statusCode})',
    );
  }

  static Future<void> updateTeam({
    required String userId,
    int? team,
    String? token,
  }) async {
    final response = await http.put(
      _uri('/api/users/$userId/team'),
      headers: _headers(token),
      body: jsonEncode({'team': team}),
    );

    if (response.statusCode == 204) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể cập nhật đội (${response.statusCode})',
    );
  }
}
