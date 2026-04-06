import '../../data/models/auth_response_dto.dart';
import '../../domain/entities/auth_user.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/token_storage_service.dart';
import '../../../../shared/models/user_role.dart';

/// Use case for signing up a new user
class SignupUseCase {
  Future<AuthUser> execute({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    // Call auth service to signup
    await AuthService.signup(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );

    // After successful signup, login automatically
    final token = await AuthService.login(
      email: email,
      password: password,
      role: role,
    );

    // Create DTO from response
    final authResponseDto = AuthResponseDto.fromJson({'access_token': token});
    
    // Map DTO to domain entity
    final authUser = AuthMapper.dtoToEntity(authResponseDto);
    
    // Save tokens
    await TokenStorageService.saveTokens(
      accessToken: authUser.accessToken,
      refreshToken: authUser.refreshToken,
      userRole: role,
    );
    
    return authUser;
  }
}
