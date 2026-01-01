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
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final token = decoded['token'] as String?;
      final user = decoded['user'];

      if (token == null || user == null) {
        throw Exception('Phản hồi đăng nhập không hợp lệ');
      }

      final userMap = Map<String, dynamic>.from(user as Map);

      return {'token': token, 'user': userMap};
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
