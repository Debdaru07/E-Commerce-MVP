import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/token_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _token;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isInitialized => _isInitialized;

  Future<void> restoreSession() async {
    _token = await TokenStorageService.getAccessToken();
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login({
    required UserRole role,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final token = await AuthService.login(
        role: role,
        email: email,
        password: password,
      );

      _token = token;

      await TokenStorageService.saveTokens(
        accessToken: token,
      );

      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup({
    required UserRole role,
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      await AuthService.signup(
        role: role,
        email: email,
        password: password,
        fullName: fullName,
      );
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _error = null;

    await TokenStorageService.clear();

    notifyListeners();
  }
}
