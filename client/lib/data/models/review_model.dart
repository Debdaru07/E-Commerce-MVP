class Review {
  final String id;
  final String productId;
  final String consumerId;
  final String consumerName;
  final String? consumerAvatarUrl;
  final double rating;
  final String title;
  final String? comment;
  final List<String> imageUrls;
  final int helpfulCount;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.consumerId,
    required this.consumerName,
    this.consumerAvatarUrl,
    required this.rating,
    required this.title,
    this.comment,
    required this.imageUrls,
    required this.helpfulCount,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      consumerId: json['consumer_id'] as String,
      consumerName: json['consumer_name'] as String,
      consumerAvatarUrl: json['consumer_avatar_url'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String,
      comment: json['comment'] as String?,
      imageUrls: List<String>.from(json['image_urls'] as List? ?? []),
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'consumer_id': consumerId,
      'consumer_name': consumerName,
      'consumer_avatar_url': consumerAvatarUrl,
      'rating': rating,
      'title': title,
      'comment': comment,
      'image_urls': imageUrls,
      'helpful_count': helpfulCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
