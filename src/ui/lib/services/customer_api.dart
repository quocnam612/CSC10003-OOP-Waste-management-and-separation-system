import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomerApi {
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

  static Future<List<Map<String, dynamic>>> fetchCustomers({String? token}) async {
    final response = await http.get(
      _uri('/api/customers'),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách khách hàng (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];

    final decoded = jsonDecode(response.body);
    dynamic rawCustomers;
    if (decoded is Map<String, dynamic>) {
      rawCustomers = decoded['customers'];
    } else if (decoded is List) {
      rawCustomers = decoded;
    }

    if (rawCustomers is List) {
      return rawCustomers
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList(growable: false);
    }

    return const [];
  }
}
