import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';

class LoginChoicePage extends StatefulWidget {
  const LoginChoicePage({super.key});

  @override
  State<LoginChoicePage> createState() => _LoginChoicePageState();
}

class _LoginChoicePageState extends State<LoginChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.loginConsumer),
              child: const Text('Login as Consumer'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.loginDealer),
              child: const Text('Login as Dealer'),
            ),
          ],
        ),
      ),
    );
  }
}
