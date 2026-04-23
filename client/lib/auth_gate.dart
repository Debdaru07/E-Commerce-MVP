import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'shared/models/user_role.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/admin/pages/admin_dashboard_page.dart';
import 'features/dealer/pages/dealer_dashboard_page.dart';
import 'features/consumer/pages/consumer_home_page.dart';
import 'presentation/pages/landing_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _calledRestore = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_calledRestore) {
      _calledRestore = true;
      context.read<AuthProvider>().restoreSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.isAuthenticated) {
      // Route based on user role
      return Navigator(
        onGenerateRoute: (settings) {
          Widget page;
          
          switch (auth.userRole) {
            case UserRole.admin:
              page = const AdminDashboardPage();
            case UserRole.dealer:
              page = const DealerDashboardPage();
            case UserRole.consumer:
              page = const ConsumerHomePage();
            case null:
              page = const LandingPage();
          }

          return MaterialPageRoute(builder: (_) => page);
        },
      );
    }

    return Navigator(
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LandingPage()),
    );
  }
}
