import 'package:flutter/material.dart';

class DealerDashboardPage extends StatefulWidget {
  const DealerDashboardPage({super.key});

  @override
  State<DealerDashboardPage> createState() => _DealerDashboardPageState();
}

class _DealerDashboardPageState extends State<DealerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dealer Dashboard')),
      body: const Center(
        child: Text('Dealer analytics, orders, products'),
      ),
    );
  }
}
