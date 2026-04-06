class WishlistItem {
  final String productId;
  final String productTitle;
  final double price;
  final String imageUrl;
  final double rating;
  final DateTime addedAt;

  WishlistItem({
    required this.productId,
    required this.productTitle,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.addedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['product_id'] as String,
      productTitle: json['product_title'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_title': productTitle,
      'price': price,
      'image_url': imageUrl,
      'rating': rating,
      'added_at': addedAt.toIso8601String(),
    };
  }
}

class Wishlist {
  final String id;
  final String consumerId;
  final List<WishlistItem> items;
  final DateTime createdAt;

  Wishlist({
    required this.id,
    required this.consumerId,
    required this.items,
    required this.createdAt,
  });

  int get itemCount => items.length;

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return Wishlist(
      id: json['id'] as String,
      consumerId: json['consumer_id'] as String,
      items: itemsList
          .map((item) => WishlistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumer_id': consumerId,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
