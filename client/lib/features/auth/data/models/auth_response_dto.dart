/// DTO for login/signup response from API
class AuthResponseDto {
  final String accessToken;
  final String? refreshToken;
  final String? message;

  AuthResponseDto({
    required this.accessToken,
    this.refreshToken,
    this.message,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      accessToken: json['access_token'] ?? json['token'] ?? '',
      refreshToken: json['refresh_token'],
      message: json['message'],
    );
  }
}
