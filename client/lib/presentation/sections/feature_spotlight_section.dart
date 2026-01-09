import 'package:flutter/material.dart';
import '../components/common/section_header.dart';

class FeatureSpotlightSection extends StatelessWidget {
  const FeatureSpotlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 32),
      child: Column(
        children: [
          const SectionHeader(
            title: 'AI-Powered Development',
            subtitle:
                'Write better code faster with intelligent suggestions and automation.',
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write code faster with intelligent suggestions',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Our AI engine understands your codebase and helps refactor, generate documentation, and catch bugs early.',
                    ),
                    SizedBox(height: 24),
                    _Bullet(text: 'Context-aware code completion'),
                    _Bullet(text: 'Automatic documentation generation'),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  ),
                  clipBehavior: Clip.antiAlias, // IMPORTANT for rounded corners
                  child: Stack(
                    children: [
                      Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB-D3XsJ8kvVciMNxqwKLgsuSujH-JcXzc1fhUBmOPJfwg0rYWAUEbkdzjx9p00kM-6GACERnfPPaXZ8hn4Ui621PHj0TOPAAQebPB4HJ23IJFxOC5SZ2zDSqoRE_SUR_9ZNhX6E-_pFsRxCM0tKWtPaAGDr-CQYxwNZVu9q31VOFEsnVvkW6qa8Ogqp1eLU7heAnnQEXIxUH8nWVbMT3Xw4jWcKJTVYJr6NSaU5YLTyiUgnqIqVjzdhbu4ElOlUSl04aRdCcrreyw',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                      // Subtle dark overlay (matches HTML look)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.25),
                              Colors.black.withOpacity(0.45),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),

          // ✅ FIX: allow text to wrap instead of overflowing
          Expanded(
            child: Text(
              text,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
