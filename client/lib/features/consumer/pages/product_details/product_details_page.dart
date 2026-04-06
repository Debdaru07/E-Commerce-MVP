import 'package:flutter/material.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../models/product_ui_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductUIModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// MAIN PRODUCT SECTION
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: _Gallery(product)),
                            const SizedBox(width: 48),
                            Expanded(
                                flex: 5, child: _StickyProductInfo(product)),
                          ],
                        )
                      else ...[
                        _Gallery(product),
                        const SizedBox(height: 32),
                        _ProductInfo(product),
                      ],

                      const SizedBox(height: 80),

                      /// YOU MIGHT ALSO LIKE
                      _RelatedProductsSection(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Gallery                                  */
/* -------------------------------------------------------------------------- */

class _Gallery extends StatelessWidget {
  final ProductUIModel product;

  const _Gallery(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 3 ? 0 : 12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                      border: index == 0
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              Sticky Product Info                            */
/* -------------------------------------------------------------------------- */

class _StickyProductInfo extends StatelessWidget {
  final ProductUIModel product;

  const _StickyProductInfo(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _ProductInfo(product),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               Product Details                               */
/* -------------------------------------------------------------------------- */

class _ProductInfo extends StatelessWidget {
  final ProductUIModel product;

  const _ProductInfo(this.product);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wireless Mechanical',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          product.name,
          style: AppTextStyles.heading.copyWith(fontSize: 32, height: 1.2),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: AppTextStyles.display.copyWith(fontSize: 36),
            ),
            if (product.oldPrice != null) ...[
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '\$${product.oldPrice}',
                  style: AppTextStyles.caption.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Experience the ultimate typing precision with premium materials, '
          'next-gen performance, and a refined sound profile.',
          style: AppTextStyles.body.copyWith(height: 1.6),
        ),
        const SizedBox(height: 36),
        _PrimaryButton(
          label: 'Add to Cart',
          icon: Icons.shopping_bag_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SecondaryButton(label: 'Buy Now', onTap: () {}),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                         You Might Also Like Section                         */
/* -------------------------------------------------------------------------- */

class _RelatedProductsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = List.generate(
      4,
      (i) => ProductUIModel(
        name: 'Product $i',
        price: 49 + i * 20,
        rating: 4.5,
        imageUrl: 'https://picsum.photos/500/500?random=$i',
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'You might also like',
              style: AppTextStyles.heading.copyWith(fontSize: 24),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('View all →'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (context, index) {
            return RelatedProductCard(product: products[index]);
          },
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              Related Product Card                           */
/* -------------------------------------------------------------------------- */

class RelatedProductCard extends StatelessWidget {
  final ProductUIModel product;

  const RelatedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          /// IMAGE (fixed)
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 32),
              ),
            ),
          ),

          /// CONTENT (flexible, bounded)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Category
                  Text(
                    'Accessories',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                  const SizedBox(height: 6),

                  /// Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(), // 🔥 prevents overflow

                  /// Price + Rating
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Buttons                                   */
/* -------------------------------------------------------------------------- */

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.caption.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.caption.copyWith(fontSize: 16),
        ),
        child: Text(label),
      ),
    );
  }
}
