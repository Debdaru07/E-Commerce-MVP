# Project Overview

## Purpose
E-Commerce MVP is a scalable e-commerce platform designed to connect consumers and dealers through a centralized digital marketplace. It provides separate user experiences for different roles (Consumer, Dealer, Admin) with real-time management and commerce capabilities.

## Target Users
- **Consumers**: Browse, search, and purchase products from dealers
- **Dealers**: Manage inventory, process orders, and track sales
- **Admins**: Oversee platform operations, user management, and analytics

## Tech Stack

### Frontend
- **Framework**: Flutter (Web & Mobile)
- **Language**: Dart
- **State Management**: Provider
- **UI Design**: Material Design
- **Package Management**: Pub
- **HTTP Client**: Built-in networking layer
- **Authentication**: JWT tokens stored in secure storage
- **Styling**: Google Fonts, Lucide Icons, Custom Material theme

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Supabase (PostgreSQL)
- **Authentication**: JWT (jsonwebtoken)
- **Security**: bcrypt for password hashing
- **CORS**: Enabled for cross-origin requests
- **Environment Management**: dotenv
- **Package Manager**: npm

### Infrastructure
- **Frontend Deployment**: Netlify / Vercel (Flutter Web)
- **Mobile Build**: Gradle (Android), Xcode (iOS)
- **Desktop Support**: Windows, macOS, Linux (CMake)

## Core Features

### Authentication & Authorization
- Multi-role authentication system (Consumer, Dealer, Admin)
- JWT-based session management
- Secure password hashing with bcrypt
- Role-based access control (RBAC)

### Consumer Features
- Product discovery and browsing
- Shopping cart management
- Order placement and tracking
- User profile management

### Dealer Features
- Inventory management
- Order management and fulfillment
- Sales analytics dashboard
- Dealer profile management

### Admin Features
- User and dealer management
- Platform content moderation
- System analytics and reporting
- Configuration management

## Project Structure Overview
```
E-Commerce-MVP/
├── client/                 # Flutter web/mobile frontend
│   ├── lib/               # Dart source code
│   ├── android/           # Android build configuration
│   ├── ios/               # iOS build configuration
│   ├── web/               # Web build assets
│   ├── linux/             # Linux build configuration
│   ├── macos/             # macOS build configuration
│   ├── windows/           # Windows build configuration
│   └── pubspec.yaml       # Flutter dependencies
│
└── server/                # Node.js/Express backend
    ├── src/               # Source code
    ├── package.json       # Node dependencies
    └── .env               # Environment variables

```

## Design Philosophy
- **Modular Architecture**: Features are self-contained and reusable
- **Separation of Concerns**: Clear division between UI, services, and data layers
- **DRY Principle**: Code reusability through shared components and services
- **Cross-Platform**: Single codebase for web and mobile
- **Security First**: Input validation, secure authentication, encrypted communication

## Development Workflow
1. **Frontend**: Develop in Dart/Flutter, test locally, deploy to Netlify/Vercel
2. **Backend**: Develop with Node.js/Express, use nodemon for hot reload
3. **Database**: Manage with Supabase CLI and migrations
4. **Authentication**: Handle via secure JWT token exchange
