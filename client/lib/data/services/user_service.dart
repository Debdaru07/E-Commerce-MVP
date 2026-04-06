import 'dart:convert';
import '../../shared/network/api_client.dart';
import '../../shared/network/api_exceptions.dart';
import '../models/user_profile_model.dart';
import '../models/address_model.dart';

class UserService {
  static const _usersEndpoint = '/users';
  static const _addressesEndpoint = '/addresses';

  /// Get current user profile
  static Future<UserProfile> getProfile({required String token}) async {
    try {
      final response = await ApiClient.get(
        '$_usersEndpoint/me',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading profile: $e');
    }
  }

  /// Update user profile
  static Future<UserProfile> updateProfile({
    required String token,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (avatarUrl != null) body['avatar_url'] = avatarUrl;

      final response = await ApiClient.put(
        '$_usersEndpoint/me',
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error updating profile: $e');
    }
  }

  /// Get all users (admin only)
  static Future<List<UserProfile>> getAllUsers({required String token}) async {
    try {
      final response =
          await ApiClient.get(_usersEndpoint, token: token);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading users: $e');
    }
  }

  /// Get user by ID (admin only)
  static Future<UserProfile> getUserById({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await ApiClient.get(
        '$_usersEndpoint/$userId',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading user: $e');
    }
  }

  /// Ban/suspend user (admin only)
  static Future<UserProfile> suspendUser({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await ApiClient.put(
        '$_usersEndpoint/$userId/suspend',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to suspend user');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error suspending user: $e');
    }
  }

  /// Activate user (admin only)
  static Future<UserProfile> activateUser({
    required String token,
    required String userId,
  }) async {
    try {
      final response = await ApiClient.put(
        '$_usersEndpoint/$userId/activate',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return UserProfile.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to activate user');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error activating user: $e');
    }
  }

  // ========== ADDRESS MANAGEMENT ==========

  /// Get all addresses for current user
  static Future<List<Address>> getAddresses({required String token}) async {
    try {
      final response = await ApiClient.get(
        _addressesEndpoint,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Address.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading addresses: $e');
    }
  }

  /// Add a new address
  static Future<Address> addAddress({
    required String token,
    required String fullName,
    required String phoneNumber,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    bool isDefault = false,
  }) async {
    try {
      final body = {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'country': country,
        'is_default': isDefault,
      };

      final response = await ApiClient.post(
        _addressesEndpoint,
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Address.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to add address');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error adding address: $e');
    }
  }

  /// Update address
  static Future<Address> updateAddress({
    required String token,
    required String addressId,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (fullName != null) body['full_name'] = fullName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (addressLine1 != null) body['address_line_1'] = addressLine1;
      if (addressLine2 != null) body['address_line_2'] = addressLine2;
      if (city != null) body['city'] = city;
      if (state != null) body['state'] = state;
      if (zipCode != null) body['zip_code'] = zipCode;
      if (country != null) body['country'] = country;
      if (isDefault != null) body['is_default'] = isDefault;

      final response = await ApiClient.put(
        '$_addressesEndpoint/$addressId',
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Address.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to update address');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error updating address: $e');
    }
  }

  /// Delete address
  static Future<void> deleteAddress({
    required String token,
    required String addressId,
  }) async {
    try {
      final response = await ApiClient.delete(
        '$_addressesEndpoint/$addressId',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to delete address');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error deleting address: $e');
    }
  }
}
