import 'package:flutter/material.dart';

class SocialProofSection extends StatelessWidget {
  const SocialProofSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 40,
        children: const [
          _Logo(name: 'Acme'),
          _Logo(name: 'Energy'),
          _Logo(name: 'Token'),
          _Logo(name: 'Stack'),
          _Logo(name: 'Flow'),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String name;
  const _Logo({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
