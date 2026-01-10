import 'package:flutter/material.dart';
import '../components/inputs/email_input.dart';
import '../components/common/section_header.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: Column(
        children: [
          SectionHeader(
            title: 'Supercharge your Workflow with AI',
            subtitle:
                'The all-in-one platform designed for modern teams. Automate tasks, gain insights, and build faster.',
          ),
          SizedBox(height: 32),
          EmailInput(),
        ],
      ),
    );
  }
}
