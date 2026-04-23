import '../../data/models/wishlist_model.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> fetchWishlist({
    required String token,
  });

  Future<void> addItemToWishlist({
    required String token,
    required String productId,
  });

  Future<void> removeItemFromWishlist({
    required String token,
    required String productId,
  });
}
