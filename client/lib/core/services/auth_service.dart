// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_exceptions.dart';

enum UserRole { admin, dealer, consumer }

class AuthService {
  static Future<String> login({
    required UserRole role,
    required String email,
    required String password,
    String? fullName,
  }) async {
    late Response response;

    final body = {
      'email': email,
      'password': password,
      if (fullName != null) 'full_name': fullName,
    };

    switch (role) {
      case UserRole.admin:
        response = await ApiClient.post(
          ApiEndpoints.adminLogin,
          body: body,
        );
        break;

      case UserRole.dealer:
        response = await ApiClient.post(
          ApiEndpoints.dealerLogin,
          body: body,
        );
        break;

      case UserRole.consumer:
        response = await ApiClient.post(
          ApiEndpoints.consumerLogin,
          body: body,
        );
        break;
    }

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data['access_token'];
    } else {
      throw ApiException(data['message'] ?? 'Login failed');
    }
  }
}
