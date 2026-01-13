class ProductUIModel {
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final String imageUrl;
  final String? badge;

  ProductUIModel({
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.imageUrl,
    this.badge,
  });
}
