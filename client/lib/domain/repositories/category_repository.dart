import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> fetchCategories({
    String? token,
  });

  Future<Category> createCategory({
    required String token,
    required String name,
  });

  Future<Category> updateCategory({
    required String token,
    required String categoryId,
    required String name,
  });

  Future<void> deleteCategory({
    required String token,
    required String categoryId,
  });
}
