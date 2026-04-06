import '../../data/models/address_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/services/user_service.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserProfile> activateUser({
    required String token,
    required String userId,
  }) {
    return UserService.activateUser(token: token, userId: userId);
  }

  @override
  Future<Address> addAddress({
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
  }) {
    return UserService.addAddress(
      token: token,
      fullName: fullName,
      phoneNumber: phoneNumber,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      isDefault: isDefault,
    );
  }

  @override
  Future<List<UserProfile>> fetchAllUsers({
    required String token,
  }) {
    return UserService.getAllUsers(token: token);
  }

  @override
  Future<UserProfile> fetchProfile({
    required String token,
  }) {
    return UserService.getProfile(token: token);
  }

  @override
  Future<UserProfile> fetchUserById({
    required String token,
    required String userId,
  }) {
    return UserService.getUserById(token: token, userId: userId);
  }

  @override
  Future<List<Address>> fetchAddresses({
    required String token,
  }) {
    return UserService.getAddresses(token: token);
  }

  @override
  Future<UserProfile> suspendUser({
    required String token,
    required String userId,
  }) {
    return UserService.suspendUser(token: token, userId: userId);
  }

  @override
  Future<UserProfile> updateProfile({
    required String token,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return UserService.updateProfile(
      token: token,
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<Address> updateAddress({
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
  }) {
    return UserService.updateAddress(
      token: token,
      addressId: addressId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
      isDefault: isDefault,
    );
  }

  @override
  Future<void> deleteAddress({
    required String token,
    required String addressId,
  }) {
    return UserService.deleteAddress(
      token: token,
      addressId: addressId,
    );
  }
}
