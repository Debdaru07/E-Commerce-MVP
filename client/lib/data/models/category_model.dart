class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int productCount;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.productCount,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      productCount: json['product_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'product_count': productCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
