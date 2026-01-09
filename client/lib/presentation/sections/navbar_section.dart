import 'package:flutter/material.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/outline_button.dart';

class NavbarSection extends StatelessWidget {
  const NavbarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.dataset, size: 28),
          const SizedBox(width: 8),
          const Text(
            'SaaS Product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Spacer(),
          Row(
            children: const [
              TextButton(onPressed: null, child: Text('Features')),
              SizedBox(width: 16),
              TextButton(onPressed: null, child: Text('Pricing')),
              SizedBox(width: 16),
              TextButton(onPressed: null, child: Text('About')),
              SizedBox(width: 24),
              OutlineButtonWidget(text: 'Sign In'),
              SizedBox(width: 12),
              PrimaryButton(text: 'Get Started'),
            ],
          ),
        ],
      ),
    );
  }
}
