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

  static Future<List<Map<String, dynamic>>> fetchRequests({String? token}) async {
    final response = await http.get(
      _uri('/api/services'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách dịch vụ (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];

    final decoded = jsonDecode(response.body);
    dynamic rawServices;
    if (decoded is Map<String, dynamic>) {
      rawServices = decoded['services'];
    } else if (decoded is List) {
      rawServices = decoded;
    }

    if (rawServices is List) {
      return rawServices
          .where((item) => item is Map)
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item as Map),
          )
          .toList(growable: false);
    }

    return const [];
  }

  static Future<void> cancelRequest({
    required String serviceId,
    String? token,
  }) async {
    final response = await http.delete(
      _uri('/api/services/$serviceId'),
      headers: _headers(token),
    );

    if (response.statusCode == 204) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể hủy dịch vụ (${response.statusCode})',
    );
  }
}
