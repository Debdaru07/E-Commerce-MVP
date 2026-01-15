import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  Future<bool> login({
    required UserRole role,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _token = await AuthService.login(
        role: role,
        email: email,
        password: password,
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
}
