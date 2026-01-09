import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SocialProofSection extends StatelessWidget {
  const SocialProofSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text(
            'Trusted by forward-thinking companies',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 40,
            runSpacing: 24,
            children: const [
              _Logo(name: 'Acme', icon: LucideIcons.gem),
              _Logo(name: 'Energy', icon: LucideIcons.zap),
              _Logo(name: 'Token', icon: LucideIcons.coins),
              _Logo(name: 'Stack', icon: LucideIcons.layers),
              _Logo(name: 'Flow', icon: LucideIcons.waves),
            ],
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String name;
  final IconData icon;

  const _Logo({
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color;

    return Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
