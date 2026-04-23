import 'dart:convert';
import '../../shared/network/api_client.dart';
import '../../shared/network/api_exceptions.dart';
import '../models/wishlist_model.dart';

class WishlistService {
  static const _wishlistEndpoint = '/wishlist';

  /// Get user's wishlist
  static Future<Wishlist> getWishlist({required String token}) async {
    try {
      final response =
          await ApiClient.get(_wishlistEndpoint, token: token);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Wishlist.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException(
            'Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading wishlist: $e');
    }
  }

  /// Add product to wishlist
  static Future<void> addToWishlist({
    required String token,
    required String productId,
  }) async {
    try {
      final response = await ApiClient.post(
        '$_wishlistEndpoint/$productId',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error adding to wishlist: $e');
    }
  }

  /// Remove product from wishlist
  static Future<void> removeFromWishlist({
    required String token,
    required String productId,
  }) async {
    try {
      final response = await ApiClient.delete(
        '$_wishlistEndpoint/$productId',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to remove from wishlist');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error removing from wishlist: $e');
    }
  }

  /// Check if product is in wishlist
  static Future<bool> isInWishlist({
    required String token,
    required String productId,
  }) async {
    try {
      final wishlist = await getWishlist(token: token);
      return wishlist.items
          .any((item) => item.productId == productId);
    } catch (e) {
      return false;
    }
  }
}
