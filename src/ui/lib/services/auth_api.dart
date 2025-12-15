import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000');

  static Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/api/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Đăng nhập thất bại (${response.statusCode})',
    );
  }

  static Future<void> register({
    required int role,
    required String username,
    required String password,
    required String phone,
    required String name,
    required int region,
  }) async {
    final response = await http.post(
      _uri('/api/auth/register'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'role': role,
        'username': username,
        'password': password,
        'phone': phone,
        'name': name,
        'region': region,
      }),
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Đăng ký thất bại (${response.statusCode})',
    );
  }
}
