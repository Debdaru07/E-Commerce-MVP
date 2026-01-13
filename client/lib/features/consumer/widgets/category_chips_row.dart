import 'package:flutter/material.dart';
import 'category_chip.dart';

class CategoryChipsRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const CategoryChipsRow({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'New',
      'Audio',
      'Laptops',
      'Wearables',
      'Accessories',
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          return CategoryChip(
            label: categories[index],
            selected: index == selectedIndex,
            onTap: () => onChanged(index),
          );
        },
      ),
    );
  }
}
