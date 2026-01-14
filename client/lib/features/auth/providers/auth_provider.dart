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
    String? fullName,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final token = await AuthService.login(
        role: role,
        email: email,
        password: password,
        fullName: fullName,
      );

      _token = token;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
