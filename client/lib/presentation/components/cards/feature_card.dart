import 'package:flutter/material.dart';
import '../common/hover_wrapper.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return HoverWrapper(
      builder: (hovered) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 280,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: hovered
              ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
              : Theme.of(context).cardColor,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
