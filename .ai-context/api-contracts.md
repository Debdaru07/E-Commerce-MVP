# API Contracts

## Base Configuration

- **Base URL**: `${SERVER_URL}/api` (define in `.env`)
- **Protocol**: HTTPS (production), HTTP (development)
- **Content-Type**: `application/json`
- **Response Format**: JSON

## Authentication

### JWT Token Header
```
Authorization: Bearer <jwt_token>
```

### Token Structure
```
Header: { "alg": "HS256", "typ": "JWT" }
Payload: { "userId": "xxx", "role": "consumer|dealer|admin", "iat": timestamp, "exp": timestamp }
```

### Token Lifespan
- **Access Token**: 24 hours
- **Refresh Token**: 7 days (if implemented)

## Authentication Endpoints

### POST /auth/register
**Public endpoint** - User registration

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "firstName": "John",
  "lastName": "Doe",
  "role": "consumer" | "dealer" | "admin"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGc...",
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "consumer",
      "createdAt": "2024-01-15T10:00:00Z"
    }
  },
  "message": "Registration successful"
}
```

**Error (400)**:
```json
{
  "success": false,
  "error": "EMAIL_ALREADY_EXISTS",
  "message": "Email already registered"
}
```

### POST /auth/login
**Public endpoint** - User login

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGc...",
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "consumer"
    }
  },
  "message": "Login successful"
}
```

**Error Responses**:
- `(401)` Invalid credentials
- `(404)` User not found

### POST /auth/logout
**Protected endpoint** - User logout (invalidate token)

**Response (200)**:
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

## Consumer Endpoints

### GET /consumer/products
**Public endpoint** - List all products

**Query Parameters**:
```
?page=1&limit=20&category=electronics&search=phone&sortBy=price&order=asc
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "uuid",
        "name": "iPhone 15",
        "description": "Latest Apple phone",
        "price": 999.99,
        "category": "electronics",
        "stock": 50,
        "dealerId": "dealer-uuid",
        "dealerName": "Tech Store",
        "imageUrl": "https://...",
        "rating": 4.5,
        "reviewCount": 120,
        "createdAt": "2024-01-10T00:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 10,
      "totalItems": 200,
      "itemsPerPage": 20
    }
  }
}
```

### GET /consumer/products/:id
**Public endpoint** - Get product details

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "iPhone 15",
    "description": "...",
    "price": 999.99,
    "stock": 50,
    "dealer": {
      "id": "uuid",
      "name": "Tech Store",
      "rating": 4.8,
      "responseTime": "2h"
    },
    "specs": { "color": "black", "storage": "256GB" },
    "images": ["url1", "url2"],
    "reviews": [...]
  }
}
```

### POST /consumer/orders
**Protected endpoint (consumer role)** - Create new order

**Request Body**:
```json
{
  "items": [
    {
      "productId": "uuid",
      "quantity": 2,
      "price": 999.99
    }
  ],
  "shippingAddress": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "postalCode": "10001",
    "country": "USA"
  },
  "paymentMethod": "credit_card"
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "orderId": "uuid",
    "status": "pending",
    "totalAmount": 1999.98,
    "items": [...],
    "createdAt": "2024-01-15T10:00:00Z",
    "estimatedDelivery": "2024-01-20T00:00:00Z"
  }
}
```

### GET /consumer/orders
**Protected endpoint (consumer role)** - Get user's orders

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "orderId": "uuid",
        "status": "delivered",
        "totalAmount": 1999.98,
        "itemCount": 2,
        "createdAt": "2024-01-15T10:00:00Z",
        "deliveredAt": "2024-01-18T00:00:00Z"
      }
    ]
  }
}
```

### GET /consumer/cart
**Protected endpoint (consumer role)** - Get shopping cart

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "productId": "uuid",
        "name": "iPhone 15",
        "quantity": 1,
        "price": 999.99,
        "total": 999.99
      }
    ],
    "subtotal": 999.99,
    "tax": 79.99,
    "total": 1079.98
  }
}
```

## Dealer Endpoints

### GET /dealer/inventory
**Protected endpoint (dealer role)** - Get dealer's product inventory

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "uuid",
        "name": "iPhone 15",
        "category": "electronics",
        "stock": 50,
        "price": 999.99,
        "cost": 700.00,
        "margin": 42.9,
        "salesCount": 120,
        "lastUpdated": "2024-01-15T10:00:00Z"
      }
    ]
  }
}
```

### POST /dealer/products
**Protected endpoint (dealer role)** - Add new product

**Request Body**:
```json
{
  "name": "iPhone 15",
  "description": "Latest Apple smartphone",
  "price": 999.99,
  "cost": 700.00,
  "category": "electronics",
  "stock": 50,
  "images": ["url1", "url2"],
  "specs": { "color": "black", "storage": "256GB" }
}
```

**Response (201)**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "iPhone 15",
    "status": "active"
  }
}
```

### PUT /dealer/products/:id
**Protected endpoint (dealer role)** - Update product

**Request Body**: Same as POST with updatable fields

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "message": "Product updated successfully"
  }
}
```

### GET /dealer/orders
**Protected endpoint (dealer role)** - Get orders for dealer's products

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "orderId": "uuid",
        "customerId": "uuid",
        "customerName": "John Doe",
        "items": [
          {
            "productId": "uuid",
            "productName": "iPhone 15",
            "quantity": 1,
            "price": 999.99
          }
        ],
        "status": "pending",
        "totalAmount": 999.99,
        "createdAt": "2024-01-15T10:00:00Z"
      }
    ]
  }
}
```

### PUT /dealer/orders/:orderId/status
**Protected endpoint (dealer role)** - Update order status

**Request Body**:
```json
{
  "status": "processing" | "shipped" | "delivered" | "cancelled"
}
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "orderId": "uuid",
    "status": "shipped",
    "trackingNumber": "TRACK123456"
  }
}
```

## Admin Endpoints

### GET /admin/users
**Protected endpoint (admin role)** - List all users

**Query Parameters**:
```
?page=1&limit=50&role=consumer&search=john
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "users": [
      {
        "id": "uuid",
        "email": "user@example.com",
        "firstName": "John",
        "role": "consumer",
        "status": "active",
        "joinedAt": "2024-01-10T00:00:00Z"
      }
    ],
    "pagination": { "currentPage": 1, "totalPages": 5, "totalItems": 200 }
  }
}
```

### PUT /admin/users/:userId/status
**Protected endpoint (admin role)** - Update user status

**Request Body**:
```json
{
  "status": "active" | "suspended" | "deactivated"
}
```

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "userId": "uuid",
    "status": "suspended",
    "updatedAt": "2024-01-15T10:00:00Z"
  }
}
```

### GET /admin/analytics
**Protected endpoint (admin role)** - Get platform analytics

**Response (200)**:
```json
{
  "success": true,
  "data": {
    "totalUsers": 5000,
    "activeDeals": 150,
    "totalOrders": 25000,
    "totalRevenue": 1250000.00,
    "growthMetrics": {
      "usersGrowth": 15.5,
      "ordersGrowth": 8.2,
      "revenueGrowth": 12.3
    },
    "period": "last_30_days"
  }
}
```

## Error Handling

### Error Response Format
```json
{
  "success": false,
  "error": "ERROR_CODE",
  "message": "Human readable error message",
  "details": {}
}
```

### Common Error Codes
- `INVALID_CREDENTIALS` (401) - Login failed
- `UNAUTHORIZED` (403) - Insufficient permissions
- `NOT_FOUND` (404) - Resource not found
- `VALIDATION_ERROR` (400) - Input validation failed
- `SERVER_ERROR` (500) - Internal server error
- `RATE_LIMITED` (429) - Too many requests
- `TOKEN_EXPIRED` (401) - JWT token expired
- `INVALID_TOKEN` (401) - JWT token invalid

### Validation Errors
```json
{
  "success": false,
  "error": "VALIDATION_ERROR",
  "message": "Input validation failed",
  "details": {
    "email": "Invalid email format",
    "password": "Password must be at least 8 characters"
  }
}
```

## Rate Limiting

- **Standard Endpoints**: 100 requests/minute per IP
- **Authentication Endpoints**: 5 requests/minute per IP
- **Response Headers**: `X-RateLimit-Limit`, `X-RateLimit-Remaining`

## CORS Configuration

**Allowed Origins**:
- `http://localhost:3000` (development)
- `https://yourdomain.com` (production)

**Allowed Methods**: GET, POST, PUT, DELETE, PATCH

**Allowed Headers**: Content-Type, Authorization
