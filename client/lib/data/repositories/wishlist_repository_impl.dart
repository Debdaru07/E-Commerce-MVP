import '../../data/models/wishlist_model.dart';
import '../../data/services/wishlist_service.dart';
import '../../domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  @override
  Future<void> addItemToWishlist({
    required String token,
    required String productId,
  }) {
    return WishlistService.addToWishlist(
      token: token,
      productId: productId,
    );
  }

  @override
  Future<List<WishlistItem>> fetchWishlist({required String token}) async {
    final wishlist = await WishlistService.getWishlist(token: token);
    return wishlist.items;
  }

  @override
  Future<void> removeItemFromWishlist({
    required String token,
    required String productId,
  }) {
    return WishlistService.removeFromWishlist(
      token: token,
      productId: productId,
    );
  }
}
