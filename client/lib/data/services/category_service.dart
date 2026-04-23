import 'dart:convert';

import '../../shared/network/api_client.dart';
import '../../shared/network/api_exceptions.dart';
import '../models/category_model.dart';

class CategoryService {
  static const _categoriesEndpoint = '/categories';

  /// Get all categories
  static Future<List<Category>> getCategories({String? token}) async {
    try {
      final response = await ApiClient.get(_categoriesEndpoint, token: token);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Category.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
            'Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading categories: $e');
    }
  }

  /// Get category by ID
  static Future<Category> getCategoryById({
    required String categoryId,
    String? token,
  }) async {
    try {
      final response = await ApiClient.get(
        '$_categoriesEndpoint/$categoryId',
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Category.fromJson(json as Map<String, dynamic>);
      } else {
        throw ApiException(
            'Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error loading category: $e');
    }
  }

  /// Create category (admin only)
  static Future<Category> createCategory({
    required String token,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final body = {
        'name': name,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image_url': imageUrl,
      };

      final response = await ApiClient.post(
        _categoriesEndpoint,
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Category.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to create category');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error creating category: $e');
    }
  }

  /// Update category (admin only)
  static Future<Category> updateCategory({
    required String token,
    required String categoryId,
    String? name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (imageUrl != null) body['image_url'] = imageUrl;

      final response = await ApiClient.put(
        '$_categoriesEndpoint/$categoryId',
        body: body,
        token: token,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);
        return Category.fromJson(json as Map<String, dynamic>);
      } else {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to update category');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error updating category: $e');
    }
  }

  /// Delete category (admin only)
  static Future<void> deleteCategory({
    required String token,
    required String categoryId,
  }) async {
    try {
      final response = await ApiClient.delete(
        '$_categoriesEndpoint/$categoryId',
        token: token,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final error = jsonDecode(response.body);
        throw ApiException(
            error['message'] ?? 'Failed to delete category');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error deleting category: $e');
    }
  }
}
