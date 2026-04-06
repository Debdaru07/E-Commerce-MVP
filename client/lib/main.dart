import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app.dart';
import 'providers/waitlist_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/consumer/providers/product_provider.dart';
import 'features/consumer/providers/cart_provider.dart';
import 'shared/theme/theme_provider.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/repositories/wishlist_repository.dart';
import 'domain/repositories/waitlist_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/wishlist_repository_impl.dart';
import 'data/repositories/waitlist_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kReleaseMode) {
    await dotenv.load(
      fileName: ".env",
      isOptional: false,
    );
  }
  setUrlStrategy(PathUrlStrategy());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
        Provider<CategoryRepository>(create: (_) => CategoryRepositoryImpl()),
        Provider<UserRepository>(create: (_) => UserRepositoryImpl()),
        Provider<OrderRepository>(create: (_) => OrderRepositoryImpl()),
        Provider<WishlistRepository>(create: (_) => WishlistRepositoryImpl()),
        Provider<WaitlistRepository>(create: (_) => WaitlistRepositoryImpl()),
        ChangeNotifierProvider(create: (context) => WaitlistProvider(context.read<WaitlistRepository>())),
        ChangeNotifierProvider(create: (context) => AuthProvider(context.read<AuthRepository>())),
        ChangeNotifierProvider(create: (context) => ProductProvider(
            context.read<ProductRepository>(),
            context.read<CategoryRepository>(),
        )),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const App(),
    ),
  );
}
