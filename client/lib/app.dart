import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/services/waitlist_service.dart';
import 'providers/waitlist_provider.dart';
import 'presentation/pages/landing_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => WaitlistProvider(WaitlistService()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.mode,
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}
