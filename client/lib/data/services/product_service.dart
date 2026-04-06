import 'dart:convert';

import '../../shared/network/api_client.dart';
import '../../shared/network/api_exceptions.dart';
import '../models/product_model.dart';

class ProductService {
  static const _productsEndpoint = '/products';

  /// Get all products with optional filters
  static Future<List<Product>> getAllProducts({
    String? token,
    String? title,
    String? categoryId,
    String? sortBy,
    String? order,
  }) async {
    try {
      String endpoint = _productsEndpoint;

      // Build query parameters
      final queryParams = <String, String>{};
      if (title != null) queryParams['title'] = title;
      if (categoryId != null) queryParams['category'] = categoryId;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (order != null) queryParams['order'] = order;

      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      final response = await ApiClient.get(endpoint, token: token);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading products: $e');
    }
  }

  /// Get product by ID
  static Future<Product> getProductById({
    required String productId,
    String? token,
  }) async {
    try {
      final response = await ApiClient.get(
        '$_productsEndpoint/$productId',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading product: $e');
    }
  }

  /// Create a new product (dealer only)
  static Future<Product> createProduct({
    required String token,
    required String title,
    required String description,
    required double unitPrice,
    required int stock,
    required String categoryId,
    required List<String> imageUrls,
  }) async {
    try {
      final body = {
        'title': title,
        'description': description,
        'unit_price': unitPrice,
        'stock': stock,
        'category_id': categoryId,
        'image_urls': imageUrls,
      };

      final response = await ApiClient.post(
        _productsEndpoint,
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error creating product: $e');
    }
  }

  /// Update product (dealer only)
  static Future<Product> updateProduct({
    required String token,
    required String productId,
    String? title,
    String? description,
    double? unitPrice,
    int? stock,
    String? categoryId,
    List<String>? imageUrls,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (unitPrice != null) body['unit_price'] = unitPrice;
      if (stock != null) body['stock'] = stock;
      if (categoryId != null) body['category_id'] = categoryId;
      if (imageUrls != null) body['image_urls'] = imageUrls;

      final response = await ApiClient.put(
        '$_productsEndpoint/$productId',
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Product.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error updating product: $e');
    }
  }

  /// Delete product (dealer only)
  static Future<void> deleteProduct({
    required String token,
    required String productId,
  }) async {
    try {
      final response = await ApiClient.delete(
        '$_productsEndpoint/$productId',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error deleting product: $e');
    }
  }

  /// Get dealer's own products
  static Future<List<Product>> getDealerProducts({
    required String token,
  }) async {
    try {
      final response = await ApiClient.get(
        '$_productsEndpoint/dealer/my-products',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load dealer products: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading dealer products: $e');
    }
  }
}
