

class Product {
  final String id;
  final String title;
  final String description;
  final double unitPrice;
  final int stock;
  final String categoryId;
  final String dealerId;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final bool isActive;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.unitPrice,
    required this.stock,
    required this.categoryId,
    required this.dealerId,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.isActive,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      categoryId: json['category_id'] as String,
      dealerId: json['dealer_id'] as String,
      imageUrls: List<String>.from(json['image_urls'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'unit_price': unitPrice,
      'stock': stock,
      'category_id': categoryId,
      'dealer_id': dealerId,
      'image_urls': imageUrls,
      'rating': rating,
      'review_count': reviewCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
