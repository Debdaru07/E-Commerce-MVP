import '../../shared/models/user_role.dart';

abstract class AuthRepository {
  Future<String> login({
    required UserRole role,
    required String email,
    required String password,
  });

  Future<void> signup({
    required UserRole role,
    required String email,
    required String password,
    required String fullName,
  });

  Future<String?> getAccessToken();

  Future<UserRole?> getUserRole();

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    UserRole? userRole,
  });

  Future<void> clearTokens();
}
