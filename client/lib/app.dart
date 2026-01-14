import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // 🚦 CENTRAL ROUTING (ONLY THIS)
      initialRoute: AppRoutes.landing,
      onGenerateRoute: AppRouter.generate,
    );
  }
}
