import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/product_ui_model.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'product_badge.dart';

class ProductCard extends StatelessWidget {
  final ProductUIModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE CONTAINER (KEY FIX)
          AspectRatio(
            aspectRatio: 4 / 5, // 👈 matches Image 1
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain, // 👈 IMPORTANT
                  ),
                ),

                // Badge
                if (product.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: ProductBadge(
                      text: product.badge!,
                      color: _badgeColor(product.badge!),
                    ),
                  ),

                // Favorite
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, size: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Text(
            product.name,
            style: AppTextStyles.subheading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (product.oldPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  '\$${product.oldPrice}',
                  style: AppTextStyles.caption.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _badgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'sale':
        return Colors.redAccent;
      case 'new':
        return Colors.green;
      case 'trending':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
