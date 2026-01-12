import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';

class LoginDealerPage extends StatefulWidget {
  const LoginDealerPage({super.key});

  @override
  State<LoginDealerPage> createState() => _LoginDealerPageState();
}

class _LoginDealerPageState extends State<LoginDealerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dealer Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.dealerDashboard,
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
