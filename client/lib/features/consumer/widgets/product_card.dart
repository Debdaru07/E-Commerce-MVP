import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/product_ui_model.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../pages/product_details/product_details_page.dart';
import 'product_badge.dart';

class ProductCard extends StatelessWidget {
  final ProductUIModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 FIXED IMAGE HEIGHT (KEY)
          Container(
            height: 220, // 👈 adjust once, stable everywhere
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surfaceDark,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover, // matches Image 2
                ),
                if (product.badge != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: ProductBadge(
                      text: product.badge!,
                      color: _badgeColor(product.badge!),
                    ),
                  ),
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // TEXT SECTION (NOW SAFE)
          Text(
            product.name,
            style: AppTextStyles.subheading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

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
