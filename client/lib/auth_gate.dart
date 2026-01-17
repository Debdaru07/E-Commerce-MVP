import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/providers/auth_provider.dart';
import 'features/admin/pages/admin_dashboard_page.dart';
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
      return Navigator(
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    }

    return Navigator(
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LandingPage()),
    );
  }
}
