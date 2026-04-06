import '../entities/auth_user.dart';
import '../../../../shared/models/user_role.dart';

/// Domain repository interface for authentication
/// Defines the contract that data layer must implement
abstract class IAuthRepository {
  Future<AuthUser> login({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<AuthUser> signup({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  });

  Future<String?> getAccessToken();
  Future<UserRole?> getUserRole();
  Future<void> logout();
}
