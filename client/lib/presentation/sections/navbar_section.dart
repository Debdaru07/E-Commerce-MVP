import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/buttons/primary_button.dart';
import '../components/buttons/outline_button.dart';

class NavbarSection extends StatelessWidget {
  final bool scrolled;

  const NavbarSection({
    super.key,
    required this.scrolled,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: scrolled ? 12 : 0,
            sigmaY: scrolled ? 12 : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(scrolled ? 0.85 : 1),
              border: Border(
                bottom: BorderSide(
                  color: scrolled
                      ? Colors.white.withOpacity(0.08)
                      : Colors.transparent,
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.dataset, size: 28),
                SizedBox(width: 8),
                Text(
                  'SaaS Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
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
          ),
        ),
      ),
    );
  }
}
