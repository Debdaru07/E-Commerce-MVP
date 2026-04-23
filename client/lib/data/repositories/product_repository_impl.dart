import '../../data/services/product_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Product> createProduct({
    required String token,
    required String title,
    required String description,
    required double unitPrice,
    required int stock,
    required String categoryId,
    required List<String> imageUrls,
  }) {
    return ProductService.createProduct(
      token: token,
      title: title,
      description: description,
      unitPrice: unitPrice,
      stock: stock,
      categoryId: categoryId,
      imageUrls: imageUrls,
    );
  }

  @override
  Future<void> deleteProduct({required String token, required String productId}) {
    return ProductService.deleteProduct(
      token: token,
      productId: productId,
    );
  }

  @override
  Future<List<Product>> fetchDealerProducts({required String token}) {
    return ProductService.getDealerProducts(token: token);
  }

  @override
  Future<Product> fetchProductById({required String productId, String? token}) {
    return ProductService.getProductById(
      productId: productId,
      token: token,
    );
  }

  @override
  Future<List<Product>> fetchProducts({
    String? token,
    String? title,
    String? categoryId,
    String? sortBy,
    String? order,
  }) {
    return ProductService.getAllProducts(
      token: token,
      title: title,
      categoryId: categoryId,
      sortBy: sortBy,
      order: order,
    );
  }

  @override
  Future<Product> updateProduct({
    required String token,
    required String productId,
    String? title,
    String? description,
    double? unitPrice,
    int? stock,
    String? categoryId,
    List<String>? imageUrls,
  }) {
    return ProductService.updateProduct(
      token: token,
      productId: productId,
      title: title,
      description: description,
      unitPrice: unitPrice,
      stock: stock,
      categoryId: categoryId,
      imageUrls: imageUrls,
    );
  }
}
