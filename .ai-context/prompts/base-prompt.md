# Base AI Development Prompt

Use this prompt when asking for code generation, feature implementation, or architectural decisions. This ensures AI assistance follows project conventions.

---

## Context

You are assisting in developing an E-Commerce MVP platform with separate user experiences for Consumers, Dealers, and Admins. The application is built with:

- **Frontend**: Flutter (Dart) with Provider state management
- **Backend**: Node.js/Express with Supabase database
- **Architecture**: Feature-based modular structure with separation of concerns

---

## Core Principles to Follow

### 1. Respect Existing Architecture
- Follow the established folder structure:
  - Frontend: `lib/core/`, `lib/data/`, `lib/features/`, `lib/presentation/`
  - Backend: `src/config/`, `src/routes/`, `src/controllers/`, `src/middleware/`
- Don't reorganize or rename existing directories
- Maintain the current file naming conventions (snake_case for files)

### 2. Write Modular & Reusable Code
- **Extract common patterns** into reusable services or components
- **Avoid duplication** - if you're writing similar code twice, refactor into a shared utility
- **Single Responsibility** - each class/function should have one clear purpose
- **Dependency Injection** - pass dependencies rather than creating them internally

### 3. Component Reusability Strategy
- **Atomic Components** (`presentation/components/`): Small, single-purpose, fully configurable
- **Composite Components**: Combine multiple atomic components for common patterns
- **Feature-Specific Screens** (`features/[feature]/pages/`): Use components, not isolated logic
- **Never duplicate UI patterns** - extract to components first

### 4. Service & Business Logic Organization
- **Dart Services** (`core/services/` or `features/[name]/services/`):
  - Handle API calls, business logic, data transformation
  - Include error handling with typed exceptions
  - Return strongly-typed results, not raw JSON

- **Node.js Controllers** (`src/controllers/`):
  - Handle HTTP request/response
  - Delegate business logic to services
  - Use consistent error handling middleware
  - Always respond with standardized JSON format

### 5. Avoid Cross-Feature Dependencies
- Features should be independent modules
- Common functionality goes in `core/`
- Shared data structures go in `data/models/`
- If Feature A needs Feature B's logic, move that logic to `core/`

### 6. API Integration & Error Handling
**Dart**:
```dart
// Always wrap API calls with proper error handling
try {
  final response = await _api.get(endpoint);
  if (!response['success']) {
    throw ApiException(code: response['error'], message: response['message']);
  }
  // Return typed result
  return Model.fromJson(response['data']);
} catch (e) {
  // Throw app-specific exceptions, not raw errors
  throw ServiceException('Human readable message', e);
}
```

**Node.js**:
```javascript
// Always respond with consistent format
// Let middleware handle error formatting
try {
  const data = await service.doSomething();
  res.json({ success: true, data });
} catch (error) {
  next(error); // Middleware handles formatting
}
```

### 7. UI/UX Consistency
- **Use design system constants** for colors, typography, spacing
- **Handle loading states** consistently across app
- **Show error messages** to users in a unified way
- **Provide empty states** when no data is available
- **Material Design 3** for visual consistency

### 8. State Management (Provider Pattern)
- Global providers in `providers/` and `core/theme/`
- Feature-specific providers in `features/[name]/providers/`
- Use `ChangeNotifier` with typed data
- Expose only necessary methods
- Use `Consumer`, `watch`, or `listen` appropriately

### 9. Naming Conventions
**Dart/Flutter**:
- Files/Folders: `snake_case` (auth_provider.dart)
- Classes: `PascalCase` (AuthProvider)
- Functions/Variables: `camelCase` (fetchProducts)
- Constants: `SCREAMING_SNAKE_CASE` (API_BASE_URL)
- Private members: `_underscore` (_privateVar)

**Node.js**:
- Files: `camelCase` (authController.js)
- Classes: `PascalCase` (UserService)
- Functions/Variables: `camelCase` (validateEmail)
- Constants: `SCREAMING_SNAKE_CASE` (JWT_SECRET)

### 10. API Contracts
- Follow RESTful conventions (GET, POST, PUT, DELETE)
- Use consistent request/response format (see api-contracts.md)
- Include proper HTTP status codes
- Handle errors with meaningful error codes
- Implement validation at API boundary

---

## When Implementing Features

### Before Writing Code
1. **Check if the pattern already exists** - look at similar features
2. **Reuse existing components & services** where possible
3. **Follow the established conventions** for naming and structure
4. **Plan the data flow** - how data moves from UI to backend and back

### Implementation Checklist
- [ ] Created files in correct locations with proper naming
- [ ] Extracted reusable logic to services/components
- [ ] No duplicated code from other features
- [ ] Followed naming conventions throughout
- [ ] Added proper error handling
- [ ] Used type-safe patterns (no `dynamic` in Dart)
- [ ] Integrated with existing state management
- [ ] Matched UI/UX patterns from other screens
- [ ] API calls follow standardized request/response format
- [ ] Added loading and error states

### Code Quality Standards
- **No commented-out code** - delete or create issue instead
- **Meaningful variable/function names** - clear intent without comments
- **Comments explain "why," not "what"** - code shows what it does
- **Keep functions small** - one responsibility each
- **Avoid deeply nested logic** - extract to helper functions
- **Test edge cases** - null values, empty lists, network errors

---

## Common Patterns to Follow

### Adding a New Feature Module
```dart
// 1. Create folder structure
features/my_feature/
├── models/my_model.dart
├── services/my_service.dart
├── providers/my_provider.dart
└── pages/my_page.dart

// 2. Create service with proper error handling
class MyService {
  Final ApiClient _api;
  
  Future<List<MyModel>> fetchData() async {
    try {
      final response = await _api.get('/endpoint');
      if (!response['success']) {
        throw ApiException(response['error']);
      }
      return (response['data'] as List)
        .map((json) => MyModel.fromJson(json))
        .toList();
    } catch (e) {
      throw ServiceException('Failed to fetch: $e');
    }
  }
}

// 3. Create provider for state management
class MyProvider extends ChangeNotifier {
  final MyService _service;
  
  List<MyModel> _data = [];
  bool _isLoading = false;
  String? _error;
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _data = await _service.fetchData();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// 4. Create page using components
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return LoadingWidget();
        }
        if (provider.error != null) {
          return ErrorWidget(
            message: provider.error,
            onRetry: () => provider.loadData(),
          );
        }
        if (provider.data.isEmpty) {
          return EmptyStateWidget();
        }
        return ListView(
          children: provider.data
            .map((item) => MyItemComponent(item: item))
            .toList(),
        );
      },
    );
  }
}
```

### Adding a New API Endpoint (Backend)
```javascript
// 1. Define route
router.get('/items', authMiddleware, itemController.getItems);

// 2. Implement controller
class ItemController {
  async getItems(req, res, next) {
    try {
      const items = await itemService.fetchItems(req.query);
      res.json({
        success: true,
        data: { items },
      });
    } catch (error) {
      next(error);
    }
  }
}

// 3. Implement service (with database calls)
class ItemService {
  async fetchItems(query) {
    // Database logic
    return items;
  }
}

// 4. Add error middleware handling
errorMiddleware.handle(error, (res) => {
  res.status(error.statusCode).json({
    success: false,
    error: error.code,
    message: error.message,
  });
});
```

---

## Questions to Ask Before Implementing

1. ✅ Does a similar pattern already exist in the codebase?
2. ✅ Can this logic be extracted to a reusable service?
3. ✅ Will this component be used elsewhere?
4. ✅ Does this follow the project's naming conventions?
5. ✅ Are error cases handled appropriately?
6. ✅ Is this consistent with the UI/UX design system?
7. ✅ Does this respect feature boundaries?
8. ✅ Are all required validations in place?

---

## Anti-Patterns to Avoid

❌ **Duplicating code** - Extract to a shared service/component instead
❌ **Cross-feature imports** - Use core services or data layer instead
❌ **Inline API calls** - Always use dedicated services
❌ **Ignoring error cases** - Handle all exceptions gracefully
❌ **Hardcoded values** - Use constants or configuration
❌ **Deep nesting** - Extract to helper functions
❌ **Using `dynamic` in Dart** - Use proper types
❌ **Mixing UI and business logic** - Separate concerns
❌ **Not following naming conventions** - Be consistent
❌ **Silent failures** - Always provide user feedback

---

## When to Refactor Existing Code

- ✨ Extracting repeated patterns
- 🔄 Moving logic to appropriate layers
- 📦 Reorganizing for better modularity
- 🧹 Removing dead code or duplication
- 🎨 Improving naming clarity

**Always refactor before adding similar features again.**
