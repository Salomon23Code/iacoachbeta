import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    dynamic data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = {'message': response.body};
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (data is Map<String, dynamic>) {
        return data;
      }

      return {'data': data};
    }

    final message = _errorMessage(data);

    throw ApiException(
      statusCode: statusCode,
      message: '$message (HTTP $statusCode)',
    );
  }

  String _errorMessage(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return data?.toString().trim().isNotEmpty == true
          ? data.toString()
          : 'Une erreur est survenue';
    }

    final validationErrors = data['errors'] ?? data['violations'];
    if (validationErrors is List) {
      final messages = validationErrors
          .map((entry) {
            if (entry is Map<String, dynamic>) {
              final field = entry['field'] ?? entry['propertyPath'];
              final detail =
                  entry['defaultMessage'] ?? entry['message'] ?? entry['error'];
              if (field != null && detail != null) {
                return '$field: $detail';
              }
              return detail?.toString() ?? '';
            }
            return entry.toString();
          })
          .where((message) => message.trim().isNotEmpty)
          .toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }

    if (validationErrors is Map<String, dynamic>) {
      final messages = validationErrors.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }

    if (data.isNotEmpty &&
        data.keys.every(
          (key) => key != 'message' && key != 'detail' && key != 'error',
        )) {
      return data.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    }

    return data['message']?.toString() ??
        data['detail']?.toString() ??
        data['error']?.toString() ??
        'Une erreur est survenue';
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'ApiException($statusCode): $message';
  }
}
