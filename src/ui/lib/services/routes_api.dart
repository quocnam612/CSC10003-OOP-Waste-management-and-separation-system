import 'dart:convert';

import 'package:http/http.dart' as http;

class RoutesApi {
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

  static Future<List<Map<String, dynamic>>> fetchRoutes({String? token}) async {
    final response = await http.get(
      _uri('/api/routes'),
      headers: _headers(token),
    );

    if (response.statusCode == 404) {
      return const [];
    }

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách tuyến đường (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];
    final decoded = jsonDecode(response.body);
    dynamic rawRoutes;
    if (decoded is Map<String, dynamic>) {
      rawRoutes = decoded['routes'] ?? decoded['data'] ?? decoded['items'];
    } else if (decoded is List) {
      rawRoutes = decoded;
    }

    if (rawRoutes is List) {
      return rawRoutes
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList(growable: false);
    }

    return const [];
  }

  static Future<List<Map<String, dynamic>>> fetchWorkerRoutes({String? token}) async {
    final response = await http.get(
      _uri('/api/routes/team'),
      headers: _headers(token),
    );

    if (response.statusCode == 404) {
      return const [];
    }

    if (response.statusCode != 200) {
      throw Exception(
        response.body.isNotEmpty
            ? response.body
            : 'Không thể tải danh sách tuyến đường (${response.statusCode})',
      );
    }

    if (response.body.isEmpty) return const [];
    final decoded = jsonDecode(response.body);
    dynamic rawRoutes;
    if (decoded is Map<String, dynamic>) {
      rawRoutes = decoded['routes'] ?? decoded['data'] ?? decoded['items'];
    } else if (decoded is List) {
      rawRoutes = decoded;
    }

    if (rawRoutes is List) {
      return rawRoutes
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList(growable: false);
    }

    return const [];
  }

  static Future<void> createRoute({
    required String district,
    required String shift,
    required int team,
    required List<String> stops,
    required int region,
    String? token,
  }) async {
    final response = await http.post(
      _uri('/api/routes'),
      headers: _headers(token),
      body: jsonEncode({
        'district': district,
        'shift': shift,
        'team': team,
        'route': stops,
        'region': region,
      }),
    );

    if (response.statusCode == 201) return;

    throw Exception(
      response.body.isNotEmpty
          ? response.body
          : 'Không thể tạo tuyến đường (${response.statusCode})',
    );
  }
}
