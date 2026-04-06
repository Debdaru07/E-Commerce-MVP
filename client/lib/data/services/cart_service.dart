import '../models/cart_model.dart';


class CartService {
  static final CartService _instance = CartService._internal();
  static List<CartItem> _items = [];

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  // Get all cart items
  List<CartItem> getItems() => _items;

  // Get cart
  Cart getCart() {
    return Cart(items: _items);
  }

  // Add item to cart
  void addItem({
    required String productId,
    required String productTitle,
    required double unitPrice,
    required String imageUrl,
    int quantity = 1,
  }) {
    final existingIndex =
        _items.indexWhere((item) => item.productId == productId);

    if (existingIndex >= 0) {
      // Item already in cart, update quantity
      final existing = _items[existingIndex];
      _items[existingIndex] = CartItem(
        productId: existing.productId,
        productTitle: existing.productTitle,
        unitPrice: existing.unitPrice,
        quantity: existing.quantity + quantity,
        imageUrl: existing.imageUrl,
      );
    } else {
      // New item
      _items.add(CartItem(
        productId: productId,
        productTitle: productTitle,
        unitPrice: unitPrice,
        quantity: quantity,
        imageUrl: imageUrl,
      ));
    }
  }

  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        final item = _items[index];
        _items[index] = CartItem(
          productId: item.productId,
          productTitle: item.productTitle,
          unitPrice: item.unitPrice,
          quantity: quantity,
          imageUrl: item.imageUrl,
        );
      }
    }
  }

  // Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  // Clear cart
  void clearCart() {
    _items.clear();
  }

  // Get item count
  int getItemCount() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price
  double getTotalPrice() {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }
}
