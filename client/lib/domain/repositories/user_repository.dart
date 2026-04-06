import '../../data/models/address_model.dart';
import '../../data/models/user_profile_model.dart';

abstract class UserRepository {
  Future<UserProfile> fetchProfile({
    required String token,
  });

  Future<UserProfile> updateProfile({
    required String token,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });

  Future<List<UserProfile>> fetchAllUsers({
    required String token,
  });

  Future<UserProfile> fetchUserById({
    required String token,
    required String userId,
  });

  Future<UserProfile> suspendUser({
    required String token,
    required String userId,
  });

  Future<UserProfile> activateUser({
    required String token,
    required String userId,
  });

  Future<List<Address>> fetchAddresses({
    required String token,
  });

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
  });

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
  });

  Future<void> deleteAddress({
    required String token,
    required String addressId,
  });
}
