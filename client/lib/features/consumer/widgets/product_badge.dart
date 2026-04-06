import 'package:flutter/material.dart';
import '../../../../shared/constants/app_text_styles.dart';

class ProductBadge extends StatelessWidget {
  final String text;
  final Color color;

  const ProductBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
