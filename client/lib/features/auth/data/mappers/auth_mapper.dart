import '../models/auth_response_dto.dart';
import '../../domain/entities/auth_user.dart';

/// Mapper to convert between DTOs and Domain Entities
class AuthMapper {
  /// Convert AuthResponseDto to AuthUser domain entity
  static AuthUser dtoToEntity(AuthResponseDto dto) {
    return AuthUser(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
  }

  /// Convert AuthUser domain entity to AuthResponseDto
  static AuthResponseDto entityToDto(AuthUser entity) {
    return AuthResponseDto(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
    );
  }
}
