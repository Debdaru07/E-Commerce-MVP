import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({
    String? token,
    String? title,
    String? categoryId,
    String? sortBy,
    String? order,
  });

  Future<Product> fetchProductById({
    required String productId,
    String? token,
  });

  Future<Product> createProduct({
    required String token,
    required String title,
    required String description,
    required double unitPrice,
    required int stock,
    required String categoryId,
    required List<String> imageUrls,
  });

  Future<Product> updateProduct({
    required String token,
    required String productId,
    String? title,
    String? description,
    double? unitPrice,
    int? stock,
    String? categoryId,
    List<String>? imageUrls,
  });

  Future<void> deleteProduct({
    required String token,
    required String productId,
  });

  Future<List<Product>> fetchDealerProducts({
    required String token,
  });
}
