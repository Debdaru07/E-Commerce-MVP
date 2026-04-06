# Coding Guidelines

## Naming Conventions

### Dart/Flutter

**Files & Folders**
- Use `snake_case` for file names: `auth_provider.dart`, `user_service.dart`
- Folders also use `snake_case`: `core/`, `data/services/`

**Classes & Types**
- Use `PascalCase`: `AuthProvider`, `UserService`, `LoginPage`
- Abstract classes: prefix with `Abstract` or `Base`: `BaseService`, `AbstractRepository`

**Variables & Functions**
- Use `camelCase`: `currentUser`, `fetchProducts()`, `isAuthenticated`
- Constants use `SCREAMING_SNAKE_CASE`: `API_BASE_URL`, `MAX_RETRY_ATTEMPTS`
- Private members prefix with underscore: `_privateVar`, `_privateMethod()`

**Getters/Setters**
- Use property syntax without `get`/`set` prefix: `user.name` not `user.getName()`

### Node.js/JavaScript

**Files**
- Use `camelCase` for files: `authController.js`, `userService.js`
- Index files: `index.js`

**Classes & Functions**
- Classes use `PascalCase`: `UserController`, `AuthService`
- Functions use `camelCase`: `fetchUser()`, `validateEmail()`
- Constants use `SCREAMING_SNAKE_CASE`: `DB_HOST`, `JWT_SECRET`

**Variables**
- Use `camelCase`: `userData`, `isValid`, `totalAmount`
- Private members: convention is `_privateVar` or prefixed comment `// private`

---

## Code Organization & Modularization

### Feature-Based Structure
Features should be self-contained modules with all necessary code:

```
features/[feature_name]/
├── models/              # Data structures
├── providers/           # State management
├── services/            # Business logic
└── pages/               # UI screens
```

**Example**: When adding a new feature like Reviews:
```
features/reviews/
├── models/
│   ├── review_model.dart
│   └── rating_model.dart
├── providers/
│   └── reviews_provider.dart
├── services/
│   └── reviews_service.dart
└── pages/
    ├── reviews_list_page.dart
    └── write_review_page.dart
```

### Core Services
Shared functionality belongs in `core/services/`:
- `auth_service.dart` - Authentication logic
- `api_client.dart` - HTTP communication
- `storage_service.dart` - Local data persistence

### No Cross-Feature Dependencies
- Features should NOT directly import from other features' private code
- Use shared services and models instead
- If sharing is needed, move to `core/` or `data/`

---

## Reusable Components Strategy

### Component Hierarchy

**Atomic Components** (`presentation/components/`)
- Small, single-purpose widgets
- Fully customizable via parameters
- No business logic, only presentation

```dart
// ✅ GOOD: Reusable button component
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? CircularProgressIndicator() : Text(label),
    );
  }
}
```

**Composite Components** (`presentation/components/`)
- Combine multiple atomic components
- Still reusable across features

```dart
// ✅ GOOD: Composite product card
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          NetworkImage(product.imageUrl),
          Text(product.name),
          PrimaryButton(label: 'View', onPressed: onTap),
        ],
      ),
    );
  }
}
```

**Page Components** (`presentation/pages/`)
- Feature-specific screens
- Connect providers and services
- Compose from reusable components

### Avoid Code Duplication

**❌ BAD**: Duplicated widget logic
```dart
// In ConsumerPage
ElevatedButton(
  onPressed: () async {
    setState(() => loading = true);
    try {
      await productService.fetchProducts();
    } finally {
      setState(() => loading = false);
    }
  },
  child: loading ? CircularProgressIndicator() : Text('Fetch'),
)

// In DealerPage (same logic repeated)
ElevatedButton(
  onPressed: () async {
    setState(() => loading = true);
    try {
      await orderService.fetchOrders();
    } finally {
      setState(() => loading = false);
    }
  },
  child: loading ? CircularProgressIndicator() : Text('Fetch'),
)
```

**✅ GOOD**: Extract to reusable component
```dart
// Extract as AsyncButton component
class AsyncButton extends StatefulWidget {
  final String label;
  final Future<void> Function() onPressed;

  @override
  _AsyncButtonState createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _loading ? null : _onPressed,
      child: _loading ? CircularProgressIndicator() : Text(widget.label),
    );
  }

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    try {
      await widget.onPressed();
    } finally {
      setState(() => _loading = false);
    }
  }
}

// Reuse everywhere
AsyncButton(
  label: 'Fetch',
  onPressed: () => productService.fetchProducts(),
)
```

---

## Service & Controller Pattern

### Dart Services
Services handle business logic and API calls:

```dart
// ✅ GOOD service structure
class ProductService {
  final ApiClient _api;

  ProductService(this._api);

  Future<List<Product>> fetchProducts({
    int page = 1,
    String? query,
  }) async {
    try {
      final response = await _api.get('/products', {
        'page': page,
        'search': query,
      });
      
      return (response['data'] as List)
        .map((json) => Product.fromJson(json))
        .toList();
    } catch (e) {
      throw ServiceException('Failed to fetch products: $e');
    }
  }
}
```

### Node.js Controllers
Controllers handle HTTP requests and delegate to services:

```javascript
// ✅ GOOD controller structure
class ProductController {
  constructor(productService) {
    this.productService = productService;
  }

  async getProducts(req, res, next) {
    try {
      const { page = 1, search } = req.query;
      const products = await this.productService.fetchProducts({
        page: parseInt(page),
        search,
      });

      res.json({
        success: true,
        data: { products },
      });
    } catch (error) {
      next(error);
    }
  }
}
```

---

## UI/UX Consistency

### Design System / Theme

**Color Palette** (defined in `core/theme/`)
```dart
class AppColors {
  static const primary = Color(0xFF6200EA);
  static const secondary = Color(0xFF03DAC6);
  static const error = Color(0xFFB00020);
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
}

// Usage
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
  ),
  child: Text('Click me'),
)
```

**Typography** (Material Design 3)
```dart
class AppTypography {
  static final headlineLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static final bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
}

// Usage
Text(
  'Headline',
  style: AppTypography.headlineLarge,
)
```

**Spacing Constants**
```dart
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

// Usage
Padding(
  padding: EdgeInsets.all(AppSpacing.md),
  child: Text('Content'),
)
```

### Consistent Patterns

**Loading States**
```dart
// ✅ Always show loading indicator while fetching
Consumer<ProductProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView(children: provider.products);
  },
)
```

**Error Handling**
```dart
// ✅ Always show user-friendly error messages
if (provider.error != null) {
  return ErrorWidget(
    message: provider.error!,
    onRetry: () => provider.fetch(),
  );
}
```

**Empty States**
```dart
// ✅ Always show meaningful UI when no data
if (provider.products.isEmpty && !provider.isLoading) {
  return EmptyStateWidget(
    icon: Icons.shopping_bag_outlined,
    message: 'No products found',
    actionLabel: 'Browse all',
    onAction: () => navigateToAllProducts(),
  );
}
```

---

## API Integration & Error Handling

### Request/Response Pattern

**Dart**:
```dart
// ✅ Structured API calls with error handling
Future<List<Order>> fetchOrders() async {
  try {
    final response = await _api.get('/orders');
    
    if (!response['success']) {
      throw ApiException(
        code: response['error'],
        message: response['message'],
      );
    }
    
    return (response['data']['orders'] as List)
      .map((json) => Order.fromJson(json))
      .toList();
  } on SocketException catch (e) {
    throw NetException('Network error: $e');
  } on TimeoutException {
    throw NetException('Request timeout');
  } catch (e) {
    throw ApiException(message: 'Unknown error: $e');
  }
}
```

**Node.js**:
```javascript
// ✅ Consistent error handling
async getOrders(req, res, next) {
  try {
    const orders = await this.orderService.fetchOrders(req.user.id);
    
    return res.json({
      success: true,
      data: { orders },
    });
  } catch (error) {
    // Let middleware handle error formatting
    next(error);
  }
}
```

### Error Classes

**Dart**:
```dart
class ServiceException implements Exception {
  final String message;
  final String? code;

  ServiceException(this.message, [this.code]);

  @override
  String toString() => message;
}

class ApiException extends ServiceException {
  ApiException({required String message, String? code})
    : super(message, code);
}
```

**Node.js**:
```javascript
class ApiError extends Error {
  constructor(statusCode, code, message) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
  }
}

class ValidationError extends ApiError {
  constructor(message, details = {}) {
    super(400, 'VALIDATION_ERROR', message);
    this.details = details;
  }
}
```

---

## Common Best Practices

1. **Don't Repeat Yourself (DRY)**: Extract common patterns to reusable functions/components
2. **Single Responsibility**: Each class/function should have one reason to change
3. **Dependency Injection**: Pass dependencies vs. creating them internally
4. **Null Safety**: Handle nullable values explicitly (Dart)
5. **Type Safety**: Use strong typing, avoid `dynamic` when possible
6. **Comments**: Comment "why," not "what" (code shows what)
7. **Testing**: Write testable code with clear dependencies
8. **Git Commits**: Small, focused commits with clear messages
