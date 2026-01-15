import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _Gallery(product)),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: _StickyProductInfo(product),
                      ),
                    ],
                  );
                }

                return ListView(
                  children: [
                    _Gallery(product),
                    const SizedBox(height: 32),
                    _ProductInfo(product),
                  ],
                );
              },
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
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
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
                          ? Border.all(
                              color: AppColors.primary,
                              width: 2,
                            )
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
        /// Category / Tag
        Text(
          'Wireless Mechanical',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),

        /// Title
        Text(
          product.name,
          style: AppTextStyles.heading.copyWith(
            fontSize: 32,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        /// Price Row
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

        /// Description
        Text(
          'Experience the ultimate typing precision with premium materials, '
          'next-gen performance, and a refined sound profile.',
          style: AppTextStyles.body.copyWith(height: 1.6),
        ),
        const SizedBox(height: 36),

        /// CTA Buttons
        _PrimaryButton(
          label: 'Add to Cart',
          icon: Icons.shopping_bag_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SecondaryButton(
          label: 'Buy Now',
          onTap: () {},
        ),
      ],
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
          elevation: 0,
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
