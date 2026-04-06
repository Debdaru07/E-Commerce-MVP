import 'package:flutter/material.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();

  // Get cart
  Cart get cart => _cartService.getCart();

  // Get item count
  int get itemCount => _cartService.getItemCount();

  // Get total price
  double get totalPrice => _cartService.getTotalPrice();

  // Get items
  List<CartItem> get items => _cartService.getItems();

  // Add item to cart
  void addItem({
    required String productId,
    required String productTitle,
    required double unitPrice,
    required String imageUrl,
    int quantity = 1,
  }) {
    _cartService.addItem(
      productId: productId,
      productTitle: productTitle,
      unitPrice: unitPrice,
      imageUrl: imageUrl,
      quantity: quantity,
    );
    notifyListeners();
  }

  // Update quantity
  void updateQuantity(String productId, int quantity) {
    _cartService.updateQuantity(productId, quantity);
    notifyListeners();
  }

  // Remove item
  void removeItem(String productId) {
    _cartService.removeItem(productId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartService.clearCart();
    notifyListeners();
  }

  // Check if product is in cart
  bool isProductInCart(String productId) {
    return _cartService.getItems().any((item) => item.productId == productId);
  }

  // Get quantity of product in cart
  int getProductQuantity(String productId) {
    final item = _cartService
        .getItems()
        .firstWhere(
            (item) => item.productId == productId,
            orElse: () => CartItem(
                  productId: '',
                  productTitle: '',
                  unitPrice: 0,
                  quantity: 0,
                  imageUrl: '',
                ));
    return item.quantity;
  }
}
