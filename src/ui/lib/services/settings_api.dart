import 'dart:convert';

import 'package:http/http.dart' as http;

class SettingsApi {
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

  static Future<void> updateProfile({
    required String username,
    required String name,
    required String phone,
    required int region,
    String? token,
  }) async {
    final response = await http.put(
      _uri('/api/user/about'),
      headers: _headers(token),
      body: jsonEncode({
        'username': username,
        'name': name,
        'phone': phone,
        'region': region,
      }),
    );

    if (response.statusCode == 200) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể cập nhật thông tin người dùng (${response.statusCode})',
    );
  }

  static Future<void> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    String? token,
  }) async {
    final response = await http.put(
      _uri('/api/user/change-password'),
      headers: _headers(token),
      body: jsonEncode({
        'username': username,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể đổi mật khẩu (${response.statusCode})',
    );
  }
}
