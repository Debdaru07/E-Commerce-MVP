import 'dart:convert';
import 'package:http/http.dart';
import '../config/env.dart';
import '../network/api_client.dart';
import '../network/api_exceptions.dart';
import '../models/user_role.dart';

class AuthService {
  /// LOGIN
  static Future<String> login({
    required UserRole role,
    required String email,
    required String password,
  }) async {
    late Response response;

    final body = {
      'email': email,
      'password': password,
    };

    switch (role) {
      case UserRole.admin:
        response = await ApiClient.post(
          Env.adminLogin,
          body: body,
        );
        break;

      case UserRole.dealer:
        response = await ApiClient.post(
          Env.dealerLogin,
          body: body,
        );
        break;

      case UserRole.consumer:
        response = await ApiClient.post(
          Env.consumerLogin,
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

  /// SIGNUP
  static Future<void> signup({
    required UserRole role,
    required String email,
    required String password,
    required String fullName,
  }) async {
    late Response response;

    final body = {
      'email': email,
      'password': password,
      'full_name': fullName,
    };

    switch (role) {
      case UserRole.dealer:
        response = await ApiClient.post(
          Env.dealerSignup,
          body: body,
        );
        break;

      case UserRole.consumer:
        response = await ApiClient.post(
          Env.consumerSignup,
          body: body,
        );
        break;

      default:
        throw ApiException('Unsupported role');
    }

    final data = jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(data['message'] ?? 'Signup failed');
    }
  }
}
