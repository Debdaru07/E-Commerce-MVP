# Architecture & System Design

## Frontend Architecture (Flutter/Dart)

### Folder Structure

```
client/lib/
├── main.dart              # Entry point with provider setup
├── app.dart               # App widget configuration
├── auth_gate.dart         # Authentication routing logic
│
├── core/                  # Shared utilities and services
│   ├── config/            # App configuration files
│   ├── constants/         # Application constants (API base URLs, etc.)
│   ├── network/           # HTTP client and API communication
│   ├── routing/           # Route definitions (AppRoutes)
│   ├── services/          # Core business logic services
│   ├── theme/             # Theme configuration and providers
│   └── utils/             # Helper functions and utilities
│
├── data/                  # Data layer (models, API calls)
│   ├── models/            # Data models for API responses
│   └── services/          # API service implementations
│
├── features/              # Feature-specific implementations
│   ├── admin/             # Admin dashboard feature
│   ├── auth/              # Authentication feature
│   ├── consumer/          # Consumer app feature
│   └── dealer/            # Dealer dashboard feature
│
├── presentation/          # UI layer (widgets, screens)
│   ├── components/        # Reusable UI components (buttons, cards, etc.)
│   ├── pages/             # Full page screens
│   ├── sections/          # Page sections (headers, footers, etc.)
│   └── utils/             # UI helper functions
│
└── providers/             # Global state providers
    ├── landing_provider.dart
    └── waitlist_provider.dart
```

### State Management (Provider)

**Architecture Pattern**: Provider Pattern with ChangeNotifier

**Global Providers**:
- `ThemeProvider`: Theme switching and styling state
- `AuthProvider`: Authentication state and user session
- `WaitlistProvider`: Landing page waitlist management

**Feature-Specific Providers**: Each feature (consumer, dealer, admin) maintains its own providers for:
- Feature state management
- API calls and data fetching
- Loading and error states

**Provider Usage**:
```dart
// Read state
final theme = context.read<ThemeProvider>();

// Listen to changes
final theme = context.watch<ThemeProvider>();

// Consumer pattern for granular rebuilds
Consumer<AuthProvider>(
  builder: (context, auth, _) => Text(auth.user?.name ?? 'Guest'),
)
```

### Data Flow

```
UI (Pages/Widgets)
    ↓
Providers (State Management)
    ↓
Services (Business Logic)
    ↓
Network Layer (HTTP)
    ↓
Backend API
```

### Feature Structure

Each feature folder follows a consistent pattern:

```
features/[feature_name]/
├── models/               # Feature-specific data models
├── providers/            # Feature state management
├── services/             # Feature business logic
└── pages/                # Feature UI screens
```

### Routing Architecture

- **Router Pattern**: Named routes defined in `AppRoutes` class
- **AuthGate**: Main navigation hub that routes based on authentication state
- **Route Categories**:
  - Public routes (landing)
  - Auth routes (login/signup for each role)
  - Protected routes (consumer, dealer, admin apps)

### API Communication

**Network Layer (`core/network/`)**:
- Centralized HTTP client
- Request/response interceptors
- Error handling and retry logic
- JWT token management
- Base URL and API endpoint definitions

**Service Pattern**:
- Controllers in `data/services/` handle API calls
- Services accept parameters and return typed responses
- Error handling bubbled to providers for UI feedback

## Backend Architecture (Node.js/Express)

### Project Structure

```
server/src/
├── server.js              # Entry point
├── app.js                 # Express app configuration
│
├── config/                # Configuration files
│   ├── environment.js     # Environment variables
│   ├── database.js        # Database connection
│   └── firebase.js        # Firebase (if used)
│
├── middleware/            # Express middleware
│   ├── auth.js            # JWT verification
│   ├── errorHandler.js    # Error handling
│   └── cors.js            # CORS configuration
│
├── routes/                # API endpoint definitions
│   ├── auth.js            # Authentication endpoints
│   ├── consumer.js        # Consumer endpoints
│   ├── dealer.js          # Dealer endpoints
│   └── admin.js           # Admin endpoints
│
├── controllers/           # Request handlers
│   ├── authController.js
│   ├── consumerController.js
│   ├── dealerController.js
│   └── adminController.js
│
└── utils/                 # Helper functions
    ├── validators.js      # Input validation
    ├── responses.js       # Response formatting
    └── errors.js          # Error classes
```

### API Communication Flow

```
Client (HTTP Request)
    ↓
Express Middleware (CORS, Auth)
    ↓
Routes (Endpoint matching)
    ↓
Controllers (Business logic)
    ↓
Supabase (Database operations)
    ↓
Controllers (Format response)
    ↓
Client (HTTP Response)
```

### Authentication Flow

1. **Login Request**: User provides credentials
2. **Password Verification**: bcrypt validates password against stored hash
3. **Token Generation**: JWT created with user ID and role
4. **Token Storage**: Client stores token in secure storage
5. **API Requests**: Token sent in Authorization header
6. **Token Verification**: Middleware verifies token on protected routes
7. **Logout**: Token removed from client storage

### Database Architecture

**Provider**: Supabase (PostgreSQL-based)

**Key Tables**:
- `users` - User accounts (consumers, dealers, admins)
- `products` - Product inventory
- `orders` - Order records
- `order_items` - Order line items
- `user_profiles` - Extended user information

**Relationships**: Foreign keys establish relationships between tables

## Design Patterns

### Frontend Patterns
- **Provider Pattern**: State management
- **Service Locator**: For dependency injection (core/services/)
- **Repository Pattern**: Abstraction layer between data and business logic
- **Widget Composition**: Reusable component building
- **Stateless Widgets**: Preferred for simple UI components

### Backend Patterns
- **MVC (Model-View-Controller)**: Controllers handle requests, business logic in services
- **Middleware Pattern**: Request/response processing pipeline
- **Repository Pattern**: Abstract database operations
- **Error Handling Middleware**: Centralized error management

## Communication Protocol

**Format**: RESTful JSON API

**Authentication**: JWT Bearer Token
```
Authorization: Bearer <jwt_token>
```

**Request/Response**:
```json
// Request
{
  "email": "user@example.com",
  "password": "securepassword"
}

// Response
{
  "success": true,
  "data": { "token": "...", "user": {...} },
  "message": "Login successful"
}
```

## Deployment Architecture

**Frontend**:
- Built as static site
- Deployed to Netlify (primary) or Vercel (backup)
- CDN distribution for assets

**Backend**:
- Node.js server running on cloud platform
- Environment variables managed securely
- Database hosted on Supabase cloud
- Auto-scaling configuration

## Security Considerations

- **Frontend**: Tokens in secure storage, HTTPS only
- **Backend**: Input validation, SQL injection prevention, rate limiting
- **Database**: Row-level security (RLS) policies
- **CORS**: Whitelist approved origins
- **Password**: bcrypt hashing with salt rounds
