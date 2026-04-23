/// Domain entity representing authenticated user
/// Independent of any API or database structure
class AuthUser {
  final String accessToken;
  final String? refreshToken;

  AuthUser({
    required this.accessToken,
    this.refreshToken,
  });
}
