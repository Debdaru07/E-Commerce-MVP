import 'package:flutter/material.dart';

class TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String message;
  final double rating;

  const TestimonialCard({
    super.key,
    required this.name,
    required this.role,
    required this.message,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Stars(rating: rating),
          const SizedBox(height: 16),
          Text(
            '"$message"',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(role, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        rating.floor(),
        (_) => const Icon(Icons.star, size: 18, color: Colors.amber),
      ),
    );
  }
}
