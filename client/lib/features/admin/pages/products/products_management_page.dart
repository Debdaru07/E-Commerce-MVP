import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../widgets/management_header.dart';
import '../../widgets/status_pill.dart';

class ProductsManagementPage extends StatelessWidget {
  const ProductsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          ManagementHeader(
            title: 'Product Management',
            subtitle:
                'Manage your product catalog, inventory status, and dealers.',
            actionLabel: 'Add Product',
            onAction: () {},
          ),

          const SizedBox(height: 24),

          // ================= FILTERS =================
          _filtersRow(),

          const SizedBox(height: 24),

          // ================= TABLE =================
          Expanded(
            child: _productsTable(screenWidth),
          ),
        ],
      ),
    );
  }

  // ================= FILTER BAR =================
  Widget _filtersRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 5,
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                hintText: 'Search by product name, SKU, or ID...',
                hintStyle: AppTextStyles.caption,
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Dealer filter
          _dropdown('Filter by Dealer'),
          const SizedBox(width: 12),

          // Category filter
          _dropdown('Filter by Category'),
          const SizedBox(width: 12),

          // Export
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 20),
            color: AppColors.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.borderDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: AppTextStyles.caption),
          dropdownColor: AppColors.surfaceDark,
          iconEnabledColor: AppColors.textSecondary,
          items: const [],
          onChanged: (_) {},
        ),
      ),
    );
  }

  // ================= DATA TABLE =================
  Widget _productsTable(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth - 280 - 48,
          ),
          child: DataTable(
            headingRowHeight: 48,
            dataRowHeight: 78,
            headingRowColor: WidgetStateProperty.all(AppColors.backgroundDark),
            headingTextStyle: AppTextStyles.labelSmall,
            dataTextStyle: AppTextStyles.body,
            columnSpacing: 32,
            columns: const [
              DataColumn(label: Text('PRODUCT')),
              DataColumn(label: Text('DEALER')),
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('PRICE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: [
              _ProductRow(
                name: 'Ergonomic Office Chair',
                sku: '#SKU-90231',
                dealer: 'OfficeDepot Inc.',
                category: 'Furniture',
                price: '\$299.00',
                status: 'In Stock',
              ),
              _ProductRow(
                name: 'Wireless Mech Keyboard',
                sku: '#SKU-22910',
                dealer: 'TechGear Solutions',
                category: 'Electronics',
                price: '\$145.50',
                status: 'Low Stock',
              ),
              _ProductRow(
                name: '27-inch 4K Monitor',
                sku: '#SKU-88219',
                dealer: 'ScreenMasters',
                category: 'Electronics',
                price: '\$450.00',
                status: 'Out of Stock',
              ),
              _ProductRow(
                name: 'Smart Watch Series 5',
                sku: '#SKU-11234',
                dealer: 'TechGear Solutions',
                category: 'Accessories',
                price: '\$220.00',
                status: 'In Stock',
              ),
              _ProductRow(
                name: 'Sport Sneakers Red',
                sku: '#SKU-54321',
                dealer: 'FootwearDistributors',
                category: 'Apparel',
                price: '\$89.99',
                status: 'Draft',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= PRODUCT ROW =================
class _ProductRow extends DataRow {
  _ProductRow({
    required String name,
    required String sku,
    required String dealer,
    required String category,
    required String price,
    required String status,
  }) : super(
          cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name),
                  SizedBox(height: 4),
                  Text(sku, style: AppTextStyles.caption),
                ],
              ),
            ),
            DataCell(Text(dealer, style: AppTextStyles.caption)),
            DataCell(_categoryPill(category)),
            DataCell(Text(price)),
            DataCell(StatusPill(status)),
            DataCell(
              Icon(Icons.more_vert, color: AppColors.textSecondary),
            ),
          ],
        );
}

// ================= CATEGORY PILL =================
Widget _categoryPill(String category) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      category,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.primary,
      ),
    ),
  );
}
