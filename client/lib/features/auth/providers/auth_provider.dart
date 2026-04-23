import 'package:flutter/material.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../shared/models/user_role.dart';
import '../../../shared/network/api_exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  bool _isLoading = false;
  String? _error;
  String? _token;
  UserRole? _userRole;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;
  UserRole? get userRole => _userRole;
  bool get isAuthenticated => _token != null;
  bool get isInitialized => _isInitialized;

  Future<void> restoreSession() async {
    _token = await _repository.getAccessToken();
    _userRole = await _repository.getUserRole();
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
      final token = await _repository.login(
        role: role,
        email: email,
        password: password,
      );

      _token = token;
      _userRole = role;

      await _repository.saveTokens(
        accessToken: token,
        userRole: role,
      );

      return true;
    } catch (e) {
      if (e is ApiException) {
        _error = e.message;
      } else {
        _error = e.toString().replaceFirst('Exception: ', '');
      }
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
      await _repository.signup(
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
    _userRole = null;
    _error = null;

    await _repository.clearTokens();

    notifyListeners();
  }
}
