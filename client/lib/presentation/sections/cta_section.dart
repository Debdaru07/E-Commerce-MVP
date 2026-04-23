import 'package:flutter/material.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/outline_button.dart';
import '../../shared/routing/app_routes.dart';

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row( // ❌ removed const
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to get started?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Start your free trial today.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // ✅ PRIMARY CTA → CONSUMER SIGNUP
                PrimaryButton(
                  text: 'Start Free Trial',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.signupConsumer,
                    );
                  },
                ),

                const SizedBox(width: 12),

                // ✅ SECONDARY CTA
                SizedBox(
                  width: 160,
                  child: OutlineButtonWidget(
                    text: 'Contact Sales',
                    onPressed: () {
                      // TODO: later → contact form / email / modal
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
