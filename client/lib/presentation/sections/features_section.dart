import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/cards/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: [
          FeatureCard(
            icon: LucideIcons.cloudCog,
            title: 'Real-time Sync',
            description: 'Instant updates across all devices.',
          ),
          const FeatureCard(
            icon: LucideIcons.barChart3,
            title: 'Advanced Analytics',
            description: 'Powerful insights with visual dashboards.',
          ),
          const FeatureCard(
            icon: LucideIcons.users,
            title: 'Team Collaboration',
            description: 'Assign roles and manage workflows.',
          ),
        ],
      ),
    );
  }
}
