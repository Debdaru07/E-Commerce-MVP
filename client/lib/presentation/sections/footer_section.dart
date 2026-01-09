import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        children: [
          Divider(),
          SizedBox(height: 24),
          Wrap(
            spacing: 48,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _FooterColumn(
                title: 'Product',
                links: ['Features', 'Pricing', 'Changelog'],
              ),
              _FooterColumn(
                title: 'Company',
                links: ['About', 'Careers', 'Blog'],
              ),
              _FooterColumn(
                title: 'Legal',
                links: ['Privacy Policy', 'Terms'],
              ),
            ],
          ),
          SizedBox(height: 32),
          Text(
            '© 2024 SaaS Product Inc. All rights reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...links.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(e),
            )),
      ],
    );
  }
}
