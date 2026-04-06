import '../../domain/repositories/auth_repository.dart';
import '../../shared/models/user_role.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/token_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login({
    required UserRole role,
    required String email,
    required String password,
  }) {
    return AuthService.login(
      role: role,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signup({
    required UserRole role,
    required String email,
    required String password,
    required String fullName,
  }) {
    return AuthService.signup(
      role: role,
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<String?> getAccessToken() {
    return TokenStorageService.getAccessToken();
  }

  @override
  Future<UserRole?> getUserRole() {
    return TokenStorageService.getUserRole();
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    UserRole? userRole,
  }) {
    return TokenStorageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userRole: userRole,
    );
  }

  @override
  Future<void> clearTokens() {
    return TokenStorageService.clear();
  }
}
