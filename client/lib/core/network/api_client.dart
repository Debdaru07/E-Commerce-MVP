// lib/core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class ApiClient {
  static const _timeout = Duration(seconds: 30);

  static Future<http.Response> get(
    String endpoint, {
    String? token,
  }) async {
    return http
        .get(
          Uri.parse('${Env.baseUrl}$endpoint'),
          headers: _headers(token),
        )
        .timeout(_timeout);
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return http
        .post(
          Uri.parse('${Env.baseUrl}$endpoint'),
          headers: _headers(token),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return http
        .put(
          Uri.parse('${Env.baseUrl}$endpoint'),
          headers: _headers(token),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }

  static Future<http.Response> delete(
    String endpoint, {
    String? token,
  }) async {
    return http
        .delete(
          Uri.parse('${Env.baseUrl}$endpoint'),
          headers: _headers(token),
        )
        .timeout(_timeout);
  }

  static Map<String, String> _headers(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
