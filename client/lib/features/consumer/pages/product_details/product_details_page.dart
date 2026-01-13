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
                final isDesktop = constraints.maxWidth > 900;

                return isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: _Gallery(product)),
                          const SizedBox(width: 48),
                          Expanded(flex: 5, child: _ProductInfo(product)),
                        ],
                      )
                    : ListView(
                        children: [
                          _Gallery(product),
                          const SizedBox(height: 24),
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
            (_) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(12),
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
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: AppTextStyles.display.copyWith(fontSize: 32),
            ),
            if (product.oldPrice != null) ...[
              const SizedBox(width: 12),
              Text(
                '\$${product.oldPrice}',
                style: AppTextStyles.caption.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Experience premium build quality with next-gen performance and stunning design.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 32),
        _PrimaryButton(
          label: 'Add to Cart',
          icon: Icons.shopping_bag,
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
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
