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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  ),
                  child: const Center(
                    child: Icon(Icons.code, size: 80),
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
        children: [
          Icon(Icons.check_circle,
              size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
