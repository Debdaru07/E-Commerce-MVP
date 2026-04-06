import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/user_role.dart';

class TokenStorageService {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userRoleKey = 'user_role';

  // Save tokens and user role
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    UserRole? userRole,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }

    if (userRole != null) {
      await _storage.write(key: _userRoleKey, value: userRole.toString());
    }
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Get user role
  static Future<UserRole?> getUserRole() async {
    final roleStr = await _storage.read(key: _userRoleKey);
    if (roleStr == null) return null;
    
    return UserRole.values.firstWhere(
      (role) => role.toString() == roleStr,
      orElse: () => UserRole.consumer,
    );
  }

  // Clear everything (logout)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
