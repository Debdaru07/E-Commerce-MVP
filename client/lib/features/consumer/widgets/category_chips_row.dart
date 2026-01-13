import 'package:flutter/material.dart';
import 'category_chip.dart';

class CategoryChipsRow extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CategoryChipsRow({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      const _Category('All', Icons.apps),
      const _Category('New', Icons.bolt),
      const _Category('Audio', Icons.headphones),
      const _Category('Laptops', Icons.laptop_mac),
      const _Category('Wearables', Icons.watch),
      const _Category('Accessories', Icons.cable),
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          return CategoryChip(
            label: category.label,
            icon: category.icon,
            selected: index == selectedIndex,
            onTap: () => onChanged(index),
          );
        },
      ),
    );
  }
}

class _Category {
  final String label;
  final IconData icon;

  const _Category(this.label, this.icon);
}
