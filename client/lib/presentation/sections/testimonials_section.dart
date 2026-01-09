import 'package:flutter/material.dart';
import '../components/cards/testimonial_card.dart';
import '../components/common/section_header.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: Column(
        children: [
          SectionHeader(
            title: 'Loved by developers',
            subtitle: 'Teams around the world trust our platform.',
          ),
          SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              TestimonialCard(
                name: 'Sarah Jenkins',
                role: 'CTO, TechFlow',
                message:
                    'This platform completely transformed how our team collaborates.',
                rating: 5,
              ),
              TestimonialCard(
                name: 'Mark Chen',
                role: 'Product Lead',
                message:
                    'The analytics dashboard is the best I’ve used so far.',
                rating: 5,
              ),
              TestimonialCard(
                name: 'Alex Rivera',
                role: 'DevOps Engineer',
                message: 'Rock solid uptime and fantastic support.',
                rating: 4.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
