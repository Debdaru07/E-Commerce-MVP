import 'package:flutter/material.dart';
import '../widgets/category_chips_row.dart';
import '../widgets/consumer_app_bar.dart';
import '../widgets/product_card.dart';
import '../models/product_ui_model.dart';

class ConsumerHomePage extends StatefulWidget {
  const ConsumerHomePage({super.key});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  int _selectedCategory = 0;

  final products = List.generate(
    10,
    (i) => ProductUIModel(
      name: 'Product $i',
      price: 99 + i * 10,
      oldPrice: i.isEven ? 129 : null,
      rating: 4.6,
      badge: i == 0 ? 'Sale' : null,
      imageUrl: 'https://picsum.photos/400/600?random=$i',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConsumerAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CategoryChipsRow(
              selectedIndex: _selectedCategory,
              onChanged: (i) => setState(() => _selectedCategory = i),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (_, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
