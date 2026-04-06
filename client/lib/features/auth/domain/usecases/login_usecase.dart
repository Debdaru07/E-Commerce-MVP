import '../../data/models/auth_response_dto.dart';
import '../../domain/entities/auth_user.dart';
import '../../data/mappers/auth_mapper.dart';
import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/token_storage_service.dart';
import '../../../../shared/models/user_role.dart';

/// Use case for logging in a user
class LoginUseCase {
  Future<AuthUser> execute({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Call auth service to authenticate
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
