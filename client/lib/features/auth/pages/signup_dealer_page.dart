import 'package:flutter/material.dart';

class SignupDealerPage extends StatefulWidget {
  const SignupDealerPage({super.key});

  @override
  State<SignupDealerPage> createState() => _SignupDealerPageState();
}

class _SignupDealerPageState extends State<SignupDealerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dealer Signup')),
      body: const Center(
        child: Text('Dealer signup form here'),
      ),
    );
  }
}
