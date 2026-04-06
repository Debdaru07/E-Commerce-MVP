import '../../data/models/category_model.dart';
import '../../data/services/category_service.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<Category> createCategory({
    required String token,
    required String name,
  }) {
    return CategoryService.createCategory(
      token: token,
      name: name,
    );
  }

  @override
  Future<void> deleteCategory({
    required String token,
    required String categoryId,
  }) {
    return CategoryService.deleteCategory(
      token: token,
      categoryId: categoryId,
    );
  }

  @override
  Future<List<Category>> fetchCategories({String? token}) {
    return CategoryService.getCategories(token: token);
  }

  @override
  Future<Category> updateCategory({
    required String token,
    required String categoryId,
    required String name,
  }) {
    return CategoryService.updateCategory(
      token: token,
      categoryId: categoryId,
      name: name,
    );
  }
}
