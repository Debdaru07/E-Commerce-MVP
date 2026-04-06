import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/consumer_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/product_ui_model.dart';
import '../providers/product_provider.dart';

class ConsumerHomePage extends StatefulWidget {
  const ConsumerHomePage({super.key});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  @override
  void initState() {
    super.initState();
    // Load products and categories on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    // In a real app, you'd get this from AuthProvider
    // For now, we can load without token since products are public
    await productProvider.loadProducts();
    await productProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categories = productProvider.categories;
    final filteredProducts = productProvider.filteredProducts;

    return Scaffold(
      appBar: const ConsumerAppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Categories
                if (categories.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All'),
                            selected: productProvider.selectedCategoryId == null,
                            onSelected: (_) {
                              productProvider.setSelectedCategory(null);
                            },
                          ),
                        ),
                        ...categories.map((category) {
                          final isSelected =
                              productProvider.selectedCategoryId == category.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (_) {
                                productProvider.setSelectedCategory(category.id);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                else if (productProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                const SizedBox(height: 16),
                // Products Grid
                if (productProvider.isLoading && filteredProducts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading products...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.78,
                      ),
                      itemBuilder: (_, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: ProductUIModel(
                            name: product.title,
                            price: product.unitPrice,
                            oldPrice: null,
                            rating: product.rating,
                            badge:
                                product.stock < 5 ? 'Low Stock' : null,
                            imageUrl: product.imageUrls.isNotEmpty
                                ? product.imageUrls[0]
                                : 'https://picsum.photos/400/600?random=$index',
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
