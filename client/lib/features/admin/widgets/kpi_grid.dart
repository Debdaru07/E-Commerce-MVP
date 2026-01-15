import 'package:flutter/material.dart';

import 'kpi_card.dart';

class KpiGrid extends StatelessWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        KpiCard(
          title: 'Total Users',
          value: '12,450',
          icon: Icons.group,
          color: Colors.blue,
        ),
        KpiCard(
          title: 'Dealers',
          value: '85',
          icon: Icons.business_center,
          color: Colors.indigo,
        ),
        KpiCard(
          title: 'Products',
          value: '3,200',
          icon: Icons.inventory_2,
          color: Colors.purple,
        ),
        KpiCard(
          title: 'Categories',
          value: '24',
          icon: Icons.category,
          color: Colors.orange,
        ),
      ],
    );
  }
}
