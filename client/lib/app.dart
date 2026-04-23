import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'shared/routing/app_router.dart';
import 'shared/routing/app_routes.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // ✅ IMPORTANT: use initialRoute instead of home
      initialRoute: AppRoutes.landing,

      // ✅ Use your router
      onGenerateRoute: AppRouter.generate,
    );
  }
}