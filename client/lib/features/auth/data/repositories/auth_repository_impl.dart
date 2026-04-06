import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/auth_user.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../data/models/auth_response_dto.dart';
import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/token_storage_service.dart';
import '../../../../shared/models/user_role.dart';

/// Data layer implementation of AuthRepository
/// Handles all API communication for authentication
class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Call service to get token from API
    final token = await AuthService.login(
      email: email,
      password: password,
      role: role,
    );

    // Create DTO from response
    final authResponseDto = AuthResponseDto.fromJson({'access_token': token});
    
    // Map to domain entity
    final authUser = AuthMapper.dtoToEntity(authResponseDto);
    
    // Persist tokens
    await TokenStorageService.saveTokens(
      accessToken: authUser.accessToken,
      refreshToken: authUser.refreshToken,
      userRole: role,
    );
    
    return authUser;
  }

  @override
  Future<AuthUser> signup({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    // Call service to signup
    await AuthService.signup(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );

    // Automatically login after signup
    return login(
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    return await TokenStorageService.getAccessToken();
  }

  @override
  Future<UserRole?> getUserRole() async {
    return await TokenStorageService.getUserRole();
  }

  @override
  Future<void> logout() async {
    await TokenStorageService.clear();
  }
}
