import 'dart:convert';

import 'package:http/http.dart' as http;

class ReportsApi {
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

  static Future<void> createReport({
    required String title,
    required String content,
    required int type,
    String? token,
  }) async {
    final response = await http.post(
      _uri('/api/reports'),
      headers: _headers(token),
      body: jsonEncode({
        'title': title,
        'content': content,
        'type': type,
      }),
    );

    if (response.statusCode == 201) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể gửi phản hồi (${response.statusCode})',
    );
  }

  static Future<List<Map<String, dynamic>>> fetchReports({String? token}) async {
    final response = await http.get(
      _uri('/api/reports'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách phản ánh (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];

    final decoded = jsonDecode(response.body);
    dynamic rawReports;
    if (decoded is Map<String, dynamic>) {
      rawReports = decoded['reports'];
    } else if (decoded is List) {
      rawReports = decoded;
    }

    if (rawReports is List) {
      return rawReports
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList(growable: false);
    }

    return const [];
  }

  static Future<void> resolveReport({
    required String reportId,
    required bool resolved,
    String? token,
  }) async {
    final response = await http.put(
      _uri('/api/reports/$reportId/resolve'),
      headers: _headers(token),
      body: jsonEncode({'resolved': resolved}),
    );

    if (response.statusCode == 204) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể cập nhật trạng thái (${response.statusCode})',
    );
  }
}
