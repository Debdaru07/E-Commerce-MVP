import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/repositories/category_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  ProductProvider(this._productRepository, this._categoryRepository);

  List<Product> _products = [];
  List<Category> _categories = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  // Filters
  String? _selectedCategoryId;
  String _searchQuery = '';

  // Getters
  List<Product> get products => _products;
  List<Category> get categories => _categories;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == null ||
          product.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Load all products
  Future<void> loadProducts({String? token}) async {
    _setLoading(true);
    _error = null;

    try {
      _products = await _productRepository.fetchProducts(
        token: token,
        sortBy: 'created_at',
        order: 'desc',
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Load categories
  Future<void> loadCategories({String? token}) async {
    try {
      _categories = await _categoryRepository.fetchCategories(token: token);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  // Get product by ID
  Future<void> getProductById({
    required String productId,
    String? token,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _selectedProduct = await _productRepository.fetchProductById(
        productId: productId,
        token: token,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Set category filter
  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _selectedCategoryId = null;
    _searchQuery = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
