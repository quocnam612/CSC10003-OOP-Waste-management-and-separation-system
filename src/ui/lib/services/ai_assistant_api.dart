import 'dart:convert';

import 'package:http/http.dart' as http;

class AiAssistantApi {
  static const String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000');

  static Uri _endpoint() => Uri.parse('$_baseUrl/api/ai');

  static Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Future<Map<String, dynamic>> sendPrompt({
    required String prompt,
    required String token,
    String? model,
  }) async {
    final payload = <String, dynamic>{'prompt': prompt};
    if (model != null && model.trim().isNotEmpty) {
      payload['model'] = model;
    }

    final response = await http.post(
      _endpoint(),
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể kết nối AI (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) {
      throw Exception('Máy chủ AI trả về dữ liệu rỗng.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw Exception('Định dạng phản hồi AI không hợp lệ.');
  }
}
