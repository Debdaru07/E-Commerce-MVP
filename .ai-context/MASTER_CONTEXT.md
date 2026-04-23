# MASTER_CONTEXT.md - Complete Project Reference

**Last Updated**: 2024-01-15  
**Project**: E-Commerce MVP - Multi-role marketplace platform

---

## 📋 Quick Reference

### Tech Stack
- **Frontend**: Flutter (Dart) with Provider state management
- **Backend**: Node.js/Express with Supabase (PostgreSQL)
- **Deployment**: Netlify/Vercel (frontend), Cloud platform (backend)

### Folder Structure
```
client/lib/
├── core/              # Shared services, config, theme, routing
├── data/              # Models and API services
├── features/          # Feature modules (auth, consumer, dealer, admin)
├── presentation/      # UI components and pages
└── providers/         # Global state managers

server/src/
├── config/            # Environment & database setup
├── middleware/        # Auth, CORS, error handling
├── routes/            # API endpoint definitions
├── controllers/       # Request handlers
└── utils/             # Helper functions
```

### Key Routes
```
Public:       /                          (landing)
Auth:         /auth/consumer/login
              /auth/dealer/login
              /auth/admin/login
Apps:         /consumer   (protected)
              /dealer     (protected)
              /admin      (protected)
```

---

## 🏗️ Architecture Patterns

### Frontend (Dart/Flutter)
**State Management**: Provider pattern with `ChangeNotifier`
```
UI → Providers (state) → Services (logic) → API Client (HTTP) → Backend
```

**Feature Structure**:
```
features/[name]/
├── models/          → Data structures (fromJson, toJson, copyWith)
├── services/        → Business logic & API calls (error handling)
├── providers/       → State management (loading, error, data states)
└── pages/           → UI screens (compose from components)
```

**Naming**:
- Files: `snake_case` (auth_provider.dart)
- Classes: `PascalCase` (AuthProvider)
- Functions/Vars: `camelCase` (fetchUser)
- Constants: `SCREAMING_SNAKE_CASE` (API_BASE_URL)
- Private: `_underscore` (_privateVar)

### Backend (Node.js/Express)
**Request Flow**:
```
HTTP Request → Middleware → Router → Controller → Service → Database
```

**Naming**:
- Files: `camelCase` (authController.js)
- Classes: `PascalCase` (UserService)
- Functions/Vars: `camelCase` (validateEmail)
- Constants: `SCREAMING_SNAKE_CASE` (JWT_SECRET)

---

## 🔐 Authentication Flow

1. **Registration**: POST `/auth/register` → Server hashes password → Issues JWT
2. **Login**: POST `/auth/login` → Validates credentials → Returns JWT token
3. **Storage**: Client stores token in `flutter_secure_storage`
4. **API Calls**: Token sent in `Authorization: Bearer <token>` header
5. **Verification**: Middleware verifies token on protected routes
6. **Roles**: JWT payload includes `userId`, `role` (consumer|dealer|admin)

---

## 📡 API Contract Summary

### Response Format
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Human readable message",
  "error": "ERROR_CODE"  // Only in error responses
}
```

### Common Endpoints
```
POST   /auth/register         (public) Register user
POST   /auth/login            (public) Login user
GET    /consumer/products     (public) List products
GET    /consumer/products/:id (public) Product details
POST   /consumer/orders       (protected) Create order
GET    /dealer/inventory      (protected) Dealer products
PUT    /dealer/products/:id   (protected) Update product
GET    /admin/users           (protected) Admin panel
```

### Error Codes
- `INVALID_CREDENTIALS` (401) - Login failed
- `UNAUTHORIZED` (403) - Insufficient permissions
- `VALIDATION_ERROR` (400) - Input validation failed
- `NOT_FOUND` (404) - Resource not found
- `TOKEN_EXPIRED` (401) - Session expired

---

## 💡 Code Quality Rules

### DO ✅
- Extract repeated code to reusable services/components
- Use strongly-typed data (no `dynamic` in Dart)
- Handle all error cases with user-friendly messages
- Separate UI logic from business logic
- Follow feature-based modular structure
- Use dependency injection (pass deps, don't create)
- Add loading/error/empty states consistently
- Reuse components across features

### DON'T ❌
- Duplicate code across features
- Import directly from other features' private code
- Ignore error cases silently
- Mix business logic with UI widgets
- Hardcode values (use constants)
- Use `dynamic` types in Dart
- Deeply nest logic (extract helpers)
- Cross-feature dependencies without core layer

---

## 🔧 State Management (Frontend)

### Global Providers
- `ThemeProvider` - Theme switching
- `AuthProvider` - User authentication state
- `WaitlistProvider` - Landing page waitlist

### Feature Providers
Located in `features/[name]/providers/`

**Provider Template**:
```dart
class FeatureProvider extends ChangeNotifier {
  final FeatureService _service;
  
  List<Item> _data = [];
  bool _isLoading = false;
  String? _error;
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _data = await _service.fetchData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### UI Consumption
```dart
// Read (one-time)
final auth = context.read<AuthProvider>();

// Watch (rebuild on change)
final auth = context.watch<AuthProvider>();

// Consumer pattern (granular rebuild)
Consumer<AuthProvider>(
  builder: (context, auth, _) => Text(auth.user?.name ?? 'Guest'),
)
```

---

## 🎨 UI/UX Consistency

### Design System
**Colors**: `AppColors.primary`, `AppColors.secondary`, `AppColors.error`  
**Typography**: `AppTypography.headlineLarge`, `AppTypography.bodyMedium`  
**Spacing**: `AppSpacing.xs` (4), `sm` (8), `md` (16), `lg` (24), `xl` (32)

### Standard Patterns
```dart
// Loading state
if (provider.isLoading && provider.items.isEmpty) {
  return LoadingWidget();
}

// Error state
if (provider.error != null) {
  return ErrorWidget(message: provider.error, onRetry: () => provider.load());
}

// Empty state
if (provider.items.isEmpty) {
  return EmptyStateWidget(icon: Icons.inbox, message: 'No items');
}

// Content
ListView(children: provider.items.map((item) => ItemCard(item)).toList())
```

---

## 🗂️ Reusable Components

Located in `presentation/components/`

### Atomic Components (single purpose)
- `PrimaryButton` - Primary action button
- `SecondaryButton` - Secondary action button
- `LoadingWidget` - Loading spinner
- `ErrorWidget` - Error message with retry
- `EmptyStateWidget` - Empty state illustration

### Composite Components (combine atoms)
- `ProductCard` - Product display card
- `OrderItem` - Order line item
- `UserProfileHeader` - User header section

### Guidelines
- ✅ Fully customizable via parameters
- ✅ No business logic, only presentation
- ✅ Accept callbacks for user actions
- ✅ Reusable across features

---

## 🚀 Adding New Features

### Frontend (Step-by-step)

**1. Create structure**
```
features/[feature_name]/
├── models/[model].dart
├── services/[service].dart
├── providers/[provider].dart
└── pages/[page].dart
```

**2. Define model** → Add `fromJson`, `toJson`, `copyWith`

**3. Create service** → Handle API calls + error handling

**4. Create provider** → State management with loading/error/data

**5. Create pages** → Compose from reusable components

**6. Extract components** → If reusable, move to `presentation/components/`

### Backend (Step-by-step)

**1. Define route** → Add endpoint in `src/routes/[feature].js`

**2. Implement controller** → Handle requests, delegate to service

**3. Implement service** → Database logic, validation

**4. Error handling** → Use consistent error middleware

---

## 🐛 Common Debugging Tips

### Frontend
- Check `ChangeNotifier` is calling `notifyListeners()`
- Verify Provider scope is correct (global vs feature)
- Use `Consumer` to rebuild only necessary widgets
- Check for null checks in getters
- Verify API token is sent in headers

### Backend
- Check error middleware is catching exceptions
- Verify SQL queries are parameterized (prevent injection)
- Check JWT verification middleware is applied
- Verify database connection pool
- Check CORS origins are whitelist

---

## 📊 Database Schema (Key Tables)

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(255),
  role VARCHAR(50),  -- consumer, dealer, admin
  created_at TIMESTAMP
);

-- Products table
CREATE TABLE products (
  id UUID PRIMARY KEY,
  name VARCHAR(255),
  description TEXT,
  price DECIMAL(10,2),
  category VARCHAR(100),
  dealer_id UUID REFERENCES users(id),
  stock INT,
  created_at TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  total_amount DECIMAL(10,2),
  status VARCHAR(50),  -- pending, shipped, delivered
  created_at TIMESTAMP
);

-- Order items
CREATE TABLE order_items (
  id UUID PRIMARY KEY,
  order_id UUID REFERENCES orders(id),
  product_id UUID REFERENCES products(id),
  quantity INT,
  price DECIMAL(10,2)
);
```

---

## 🔑 Important Files to Know

### Frontend
- `lib/main.dart` - App entry point (provider setup)
- `lib/app.dart` - App widget config
- `lib/auth_gate.dart` - Navigation hub (auth routing)
- `lib/core/routing/app_routes.dart` - Route definitions
- `lib/core/theme/theme_provider.dart` - Theme management
- `pubspec.yaml` - Dependencies

### Backend
- `src/server.js` - Entry point
- `src/app.js` - Express app configuration
- `src/middleware/auth.js` - JWT verification
- `.env` - Environment variables
- `package.json` - Dependencies

---

## 🚢 Deployment Checklist

### Frontend (Netlify/Vercel)
- [ ] `.env` variables configured
- [ ] Build command: `flutter build web`
- [ ] Static files in `build/web/`
- [ ] Custom domain set up
- [ ] HTTPS enabled

### Backend
- [ ] Environment variables set
- [ ] Database migrations run
- [ ] JWT secret configured
- [ ] CORS origins whitelist set
- [ ] API base URL updated in frontend `.env`

---

## 📚 Reference Documents

- **Architecture Deep Dive**: See `architecture.md`
- **API Specifications**: See `api-contracts.md`
- **Code Standards**: See `coding-guidelines.md`
- **Feature Tracker**: See `feature-status.md`
- **Implementation Prompts**: See `prompts/base-prompt.md`
- **Module Template**: See `prompts/module-template.md`

---

## ✅ Quick Checklist for AI Assistance

When asking for help implementing features:

1. ✅ Reference `prompts/base-prompt.md` for code generation principles
2. ✅ Use `prompts/module-template.md` for new modules
3. ✅ Follow naming conventions from `coding-guidelines.md`
4. ✅ Implement with error handling (see patterns)
5. ✅ Reuse existing components and services
6. ✅ Add loading/error/empty states
7. ✅ Update `feature-status.md` when complete
8. ✅ Keep files modular and single-responsibility

---

## 🔗 Quick Links

- **Frontend Root**: `client/lib/`
- **Backend Root**: `server/src/`
- **Routes**: `client/lib/core/routing/app_routes.dart`
- **Theme**: `client/lib/core/theme/`
- **API Client**: `client/lib/core/network/`
- **Features**: `client/lib/features/`
- **Components**: `client/lib/presentation/components/`
- **Backend Routes**: `server/src/routes/`
- **Controllers**: `server/src/controllers/`

---

## 📞 Need Help?

**For feature implementation**: Use `prompts/base-prompt.md`  
**For new modules**: Use `prompts/module-template.md`  
**For architecture questions**: See `architecture.md`  
**For API integration**: Check `api-contracts.md`  
**For code standards**: Review `coding-guidelines.md`
