import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';

class LoginConsumerPage extends StatefulWidget {
  const LoginConsumerPage({super.key});

  @override
  State<LoginConsumerPage> createState() => _LoginConsumerPageState();
}

class _LoginConsumerPageState extends State<LoginConsumerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumer Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.consumerApp,
            );
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
