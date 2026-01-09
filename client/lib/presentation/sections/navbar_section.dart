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
              boxShadow: scrolled
                  ? [
                      BoxShadow(
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        color: Colors.black.withOpacity(0.12),
                      ),
                    ]
                  : [],
              border: Border(
                bottom: BorderSide(
                  color: scrolled
                      ? Colors.white.withOpacity(0.08)
                      : Colors.transparent,
                ),
              ),
            ),

            // 👇 RESPONSIVE FIX IS HERE
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth >= 900;

                return Row(
                  children: [
                    const Icon(Icons.dataset, size: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'SaaS Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),

                    if (isDesktop)
                      const _DesktopNav()
                    else
                      const _MobileNav(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _MobileNav extends StatelessWidget {
  const _MobileNav();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        // TODO: open mobile drawer
      },
    );
  }
}
