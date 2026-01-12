import 'package:flutter/material.dart';

class SignupConsumerPage extends StatefulWidget {
  const SignupConsumerPage({super.key});

  @override
  State<SignupConsumerPage> createState() => _SignupConsumerPageState();
}

class _SignupConsumerPageState extends State<SignupConsumerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consumer Signup')),
      body: const Center(
        child: Text('Consumer signup form here'),
      ),
    );
  }
}
