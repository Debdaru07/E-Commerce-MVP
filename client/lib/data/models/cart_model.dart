class CartItem {
  final String productId;
  final String productTitle;
  final double unitPrice;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.productTitle,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  double get subtotal => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'] as String,
      productTitle: json['product_title'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_title': productTitle,
      'unit_price': unitPrice,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  factory Cart.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return Cart(
      items: itemsList
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
