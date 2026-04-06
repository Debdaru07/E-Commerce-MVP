# Module Implementation Template

Use this template when creating new feature modules (Consumer, Dealer, Admin features, or new sections). It ensures consistency across the entire codebase.

---

## Feature Module Structure

```
features/[feature_name]/
├── models/
│   ├── [model_name]_model.dart      # Data model with fromJson/toJson
│   └── ...
├── services/
│   ├── [feature_name]_service.dart  # API calls and business logic
│   └── ...
├── providers/
│   ├── [feature_name]_provider.dart # State management
│   └── ...
└── pages/
    ├── [page_name]_page.dart        # Feature screens
    └── ...
```

---

## Step-by-Step Implementation Guide

### Step 1: Define Data Models

📁 **File**: `features/[feature_name]/models/[model_name]_model.dart`

```dart
import 'package:flutter/foundation.dart';

/// Represents a [FeatureName] entity
class FeatureModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const FeatureModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    this.metadata,
  });

  /// Factory constructor for creating from JSON response
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
  };

  /// Create a copy with optional modifications
  FeatureModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return FeatureModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() => 'FeatureModel(id: $id, name: $name)';
}
```

**Key Points**:
- ✅ Use strongly typed fields (not `dynamic`)
- ✅ Include `fromJson` and `toJson` for API serialization
- ✅ Include `copyWith` for state updates
- ✅ Add meaningful `toString()` for debugging
- ✅ Document classes with comments

---

### Step 2: Create Service Layer

📁 **File**: `features/[feature_name]/services/[feature_name]_service.dart`

```dart
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/exceptions.dart';
import '[model_name]_model.dart';

/// Business logic and API communication for [FeatureName]
class FeatureService {
  final ApiClient _api;

  FeatureService(this._api);

  /// Fetch all items with optional filtering and pagination
  ///
  /// Throws [ServiceException] if the request fails
  Future<List<FeatureModel>> fetchItems({
    int page = 1,
    String? query,
    String? category,
    int limit = 20,
  }) async {
    try {
      final response = await _api.get(
        '/[endpoint]',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (query != null) 'search': query,
          if (category != null) 'category': category,
        },
      );

      // Check for API-level errors
      if (response['success'] != true) {
        throw ApiException(
          code: response['error'] as String? ?? 'UNKNOWN_ERROR',
          message: response['message'] as String? ?? 'Unknown error occurred',
        );
      }

      // Parse and return typed results
      final data = response['data'] as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((json) => FeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return items;
    } on ApiException {
      rethrow; // Re-throw API exceptions as-is
    } catch (error) {
      throw ServiceException(
        'Failed to fetch items: $error',
        originalError: error,
      );
    }
  }

  /// Fetch single item by ID
  Future<FeatureModel> fetchItemById(String id) async {
    try {
      final response = await _api.get('/[endpoint]/$id');

      if (response['success'] != true) {
        throw ApiException(
          code: 'NOT_FOUND',
          message: 'Item not found',
        );
      }

      return FeatureModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } catch (error) {
      throw ServiceException('Failed to fetch item: $error');
    }
  }

  /// Create a new item
  ///
  /// [item] should not have an ID set yet (server will generate)
  Future<FeatureModel> createItem(FeatureModel item) async {
    try {
      final response = await _api.post(
        '/[endpoint]',
        body: item.toJson(),
      );

      if (response['success'] != true) {
        throw ApiException(
          code: response['error'] as String?,
          message: response['message'] as String?,
        );
      }

      return FeatureModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } catch (error) {
      throw ServiceException('Failed to create item: $error');
    }
  }

  /// Update existing item
  Future<FeatureModel> updateItem(FeatureModel item) async {
    try {
      final response = await _api.put(
        '/[endpoint]/${item.id}',
        body: item.toJson(),
      );

      if (response['success'] != true) {
        throw ApiException(
          code: response['error'] as String?,
          message: response['message'] as String?,
        );
      }

      return FeatureModel.fromJson(
        response['data'] as Map<String, dynamic>,
      );
    } catch (error) {
      throw ServiceException('Failed to update item: $error');
    }
  }

  /// Delete item by ID
  Future<void> deleteItem(String id) async {
    try {
      final response = await _api.delete('/[endpoint]/$id');

      if (response['success'] != true) {
        throw ApiException(
          code: response['error'] as String?,
          message: response['message'] as String?,
        );
      }
    } catch (error) {
      throw ServiceException('Failed to delete item: $error');
    }
  }
}

/// Base exception for feature-specific errors
class ServiceException implements Exception {
  final String message;
  final dynamic originalError;

  ServiceException(this.message, {this.originalError});

  @override
  String toString() => message;
}
```

**Key Points**:
- ✅ Accept `ApiClient` as dependency (DI)
- ✅ Use meaningful method names (`fetchItems`, not `getItems`)
- ✅ Include proper error handling with typed exceptions
- ✅ Return strongly-typed results
- ✅ Add documentation comments
- ✅ Use query parameters for filtering
- ✅ Validate responses before parsing

---

### Step 3: Create State Management Provider

📁 **File**: `features/[feature_name]/providers/[feature_name]_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/[model_name]_model.dart';
import '../services/[feature_name]_service.dart';

/// State management for [FeatureName] feature
class FeatureProvider extends ChangeNotifier {
  final FeatureService _service;

  // State variables
  List<FeatureModel> _items = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  String? _searchQuery;
  String? _selectedCategory;

  // Getters (immutable access to state)
  List<FeatureModel> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMoreItems => _items.isNotEmpty; // Add pagination logic as needed

  FeatureProvider(this._service);

  /// Load items from API with optional filters
  Future<void> loadItems({
    String? query,
    String? category,
    bool reset = false,
  }) async {
    // Reset pagination if applying new filters
    if (reset) {
      _currentPage = 1;
      _searchQuery = query;
      _selectedCategory = category;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _service.fetchItems(
        page: _currentPage,
        query: query,
        category: category,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page of items
  Future<void> loadMoreItems() async {
    if (_isLoading) return;

    _currentPage++;
    _isLoading = true;
    notifyListeners();

    try {
      final moreItems = await _service.fetchItems(
        page: _currentPage,
        query: _searchQuery,
        category: _selectedCategory,
      );
      _items.addAll(moreItems);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentPage--; // Revert page increment on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search for items
  Future<void> searchItems(String query) async {
    await loadItems(
      query: query.isEmpty ? null : query,
      reset: true,
    );
  }

  /// Create new item
  Future<void> createItem(FeatureModel item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdItem = await _service.createItem(item);
      _items.insert(0, createdItem); // Add to top of list
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update existing item
  Future<void> updateItem(FeatureModel item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedItem = await _service.updateItem(item);
      
      // Update in list
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index] = updatedItem;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete item by ID
  Future<void> deleteItem(String itemId) async {
    try {
      await _service.deleteItem(itemId);
      _items.removeWhere((item) => item.id == itemId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    _items = [];
    _isLoading = false;
    _error = null;
    _currentPage = 1;
    _searchQuery = null;
    _selectedCategory = null;
    notifyListeners();
  }
}
```

**Key Points**:
- ✅ Extend `ChangeNotifier` for provider pattern
- ✅ Use private variables with public getters
- ✅ Include loading, error, and data states
- ✅ Return immutable lists (`List.unmodifiable`)
- ✅ Call `notifyListeners()` after state changes
- ✅ Handle errors gracefully
- ✅ Provide reset/clear methods for cleanup

---

### Step 4: Create UI Pages

📁 **File**: `features/[feature_name]/pages/[page_name]_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/presentation/components/empty_state_widget.dart';
import 'package:app/presentation/components/error_widget.dart';
import 'package:app/presentation/components/loading_widget.dart';
import '../models/[model_name]_model.dart';
import '../providers/[feature_name]_provider.dart';

/// Display list of items for [FeatureName]
class FeatureListPage extends StatefulWidget {
  const FeatureListPage({Key? key}) : super(key: key);

  @override
  State<FeatureListPage> createState() => _FeatureListPageState();
}

class _FeatureListPageState extends State<FeatureListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Load initial data
    Future.microtask(() {
      context.read<FeatureProvider>().loadItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Features'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  context.read<FeatureProvider>().searchItems(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<FeatureProvider>().searchItems('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            // Content area
            Expanded(
              child: Consumer<FeatureProvider>(
                builder: (context, provider, _) {
                  // Loading state
                  if (provider.isLoading && provider.items.isEmpty) {
                    return const LoadingWidget();
                  }

                  // Error state
                  if (provider.error != null && provider.items.isEmpty) {
                    return ErrorWidget(
                      message: provider.error ?? 'An error occurred',
                      onRetry: () => provider.loadItems(),
                    );
                  }

                  // Empty state
                  if (provider.items.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.shopping_bag_outlined,
                      title: 'No items found',
                      message: 'Try adjusting your search criteria',
                      actionLabel: 'Clear filters',
                      onAction: () {
                        _searchController.clear();
                        provider.loadItems(reset: true);
                      },
                    );
                  }

                  // Items list
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.items.length + 1,
                    itemBuilder: (context, index) {
                      // Loading indicator at bottom for pagination
                      if (index == provider.items.length) {
                        if (provider.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      final item = provider.items[index];
                      return FeatureItemTile(
                        item: item,
                        onTap: () => _navigateToDetail(context, item),
                        onDelete: () => _deleteItem(context, item.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, FeatureModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeatureDetailPage(item: item),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FeatureCreatePage(),
      ),
    );
  }

  void _deleteItem(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FeatureProvider>().deleteItem(itemId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Individual item tile component
class FeatureItemTile extends StatelessWidget {
  final FeatureModel item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const FeatureItemTile({
    Key? key,
    required this.item,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(item.description),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

/// Detail page for single item
class FeatureDetailPage extends StatelessWidget {
  final FeatureModel item;

  const FeatureDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(item.description),
            const SizedBox(height: 16),
            Text(
              'Price: \$${item.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Create item page
class FeatureCreatePage extends StatelessWidget {
  const FeatureCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Item'),
      ),
      body: const Center(
        child: Text('Create form here'),
      ),
    );
  }
}
```

**Key Points**:
- ✅ Use `Consumer` widget for state updates
- ✅ Handle loading, error, and empty states
- ✅ Use `StatefulWidget` for input controllers
- ✅ Extract components for reusability
- ✅ Use Material design patterns
- ✅ Proper null safety handling
- ✅ Clean up resources in `dispose()`

---

## Backend Module Structure

### Step 1: Define Routes

📁 **File**: `src/routes/[feature].js`

```javascript
import express from 'express';
import { authMiddleware } from '../middleware/auth.js';
import { FeatureController } from '../controllers/featureController.js';

const router = express.Router();
const featureController = new FeatureController();

// Public routes
router.get('/search', featureController.search.bind(featureController));
router.get('/:id', featureController.getById.bind(featureController));

// Protected routes
router.post('/', authMiddleware, featureController.create.bind(featureController));
router.put('/:id', authMiddleware, featureController.update.bind(featureController));
router.delete('/:id', authMiddleware, featureController.delete.bind(featureController));

export default router;
```

### Step 2: Implement Controller

📁 **File**: `src/controllers/featureController.js`

```javascript
export class FeatureController {
  constructor(featureService) {
    this.featureService = featureService;
  }

  async getAll(req, res, next) {
    try {
      const { page = 1, limit = 20, search } = req.query;
      const items = await this.featureService.findAll({
        page: parseInt(page),
        limit: parseInt(limit),
        search,
      });

      res.json({
        success: true,
        data: { items },
      });
    } catch (error) {
      next(error);
    }
  }

  async getById(req, res, next) {
    try {
      const item = await this.featureService.findById(req.params.id);
      
      if (!item) {
        return res.status(404).json({
          success: false,
          error: 'NOT_FOUND',
          message: 'Item not found',
        });
      }

      res.json({
        success: true,
        data: item,
      });
    } catch (error) {
      next(error);
    }
  }

  async create(req, res, next) {
    try {
      const item = await this.featureService.create({
        ...req.body,
        userId: req.user.id,
      });

      res.status(201).json({
        success: true,
        data: item,
      });
    } catch (error) {
      next(error);
    }
  }

  async update(req, res, next) {
    try {
      const item = await this.featureService.update(
        req.params.id,
        req.body
      );

      res.json({
        success: true,
        data: item,
      });
    } catch (error) {
      next(error);
    }
  }

  async delete(req, res, next) {
    try {
      await this.featureService.delete(req.params.id);

      res.json({
        success: true,
        message: 'Item deleted successfully',
      });
    } catch (error) {
      next(error);
    }
  }
}
```

### Step 3: Implement Service

📁 **File**: `src/services/featureService.js`

```javascript
export class FeatureService {
  constructor(database) {
    this.db = database;
  }

  async findAll({ page = 1, limit = 20, search }) {
    let query = this.db.table('features');

    if (search) {
      query = query.ilike('name', `%${search}%`);
    }

    const from = (page - 1) * limit;
    const { data, error } = await query
      .range(from, from + limit - 1);

    if (error) throw error;
    return data || [];
  }

  async findById(id) {
    const { data, error } = await this.db
      .table('features')
      .select('*')
      .eq('id', id)
      .single();

    if (error && error.code === 'PGRST116') return null;
    if (error) throw error;
    return data;
  }

  async create(item) {
    const { data, error } = await this.db
      .table('features')
      .insert([item])
      .select();

    if (error) throw error;
    return data[0];
  }

  async update(id, updates) {
    const { data, error } = await this.db
      .table('features')
      .update(updates)
      .eq('id', id)
      .select();

    if (error) throw error;
    return data[0];
  }

  async delete(id) {
    const { error } = await this.db
      .table('features')
      .delete()
      .eq('id', id);

    if (error) throw error;
  }
}
```

---

## Checklist for New Module

- [ ] Created folder structure in `features/[name]/`
- [ ] Defined data models with `fromJson`/`toJson`
- [ ] Created service layer with proper error handling
- [ ] Created provider for state management
- [ ] Implemented list page with loading/error states
- [ ] Implemented detail page
- [ ] Created reusable components for list items
- [ ] Extracted common UI patterns
- [ ] Added proper error messages
- [ ] Followed naming conventions throughout
- [ ] Added documentation comments
- [ ] Backend: Created routes and controller
- [ ] Backend: Implemented service with database operations
- [ ] Backend: Added error handling middleware

---

## Common Patterns Reference

### Pagination
```dart
// In Provider
int _currentPage = 1;

Future<void> loadMoreItems() async {
  _currentPage++;
  final moreItems = await _service.fetchItems(page: _currentPage);
  _items.addAll(moreItems);
}
```

### Search/Filter
```dart
Future<void> searchItems(String query) async {
  await loadItems(query: query.isEmpty ? null : query, reset: true);
}
```

### Real-time Updates
```dart
// Provider with WebSocket listener
void _subscribeToUpdates() {
  _api.subscribe('feature-updates', (update) {
    _items = _items.map((item) =>
      item.id == update.id ? FeatureModel.fromJson(update) : item
    ).toList();
    notifyListeners();
  });
}
```

### Offline Support (with local storage)
```dart
Future<void> loadItems() async {
  try {
    _items = await _service.fetchItems();
    await _storage.saveItems(_items);
  } catch (e) {
    _items = await _storage.loadItems();
  }
}
```
