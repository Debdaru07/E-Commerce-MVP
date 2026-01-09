import 'package:flutter/material.dart';
import '../components/cards/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: [
          FeatureCard(
            icon: Icons.cloud_sync,
            title: 'Real-time Sync',
            description: 'Instant updates across all devices.',
          ),
          FeatureCard(
            icon: Icons.monitor,
            title: 'Advanced Analytics',
            description: 'Powerful insights with visual dashboards.',
          ),
          FeatureCard(
            icon: Icons.diversity_3,
            title: 'Team Collaboration',
            description: 'Assign roles and manage workflows.',
          ),
        ],
      ),
    );
  }
}
