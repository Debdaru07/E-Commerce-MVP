import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../widgets/management_header.dart';
import '../../widgets/status_pill.dart';

class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

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
            title: 'Categories',
            subtitle: 'Manage and organize your product taxonomy.',
            actionLabel: 'Add Category',
            onAction: () {},
          ),

          const SizedBox(height: 24),

          // ================= FILTER BAR =================
          _filterBar(),

          const SizedBox(height: 24),

          // ================= TABLE =================
          Expanded(
            child: _categoryTable(screenWidth),
          ),
        ],
      ),
    );
  }

  // ================= FILTER BAR =================
  Widget _filterBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                hintText: 'Filter categories...',
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

          // Status filter
          _dropdown('All Status'),

          const SizedBox(width: 8),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            color: AppColors.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.borderDark),
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
  Widget _categoryTable(double screenWidth) {
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
            dataRowHeight: 76,
            headingRowColor: WidgetStateProperty.all(AppColors.backgroundDark),
            headingTextStyle: AppTextStyles.labelSmall,
            dataTextStyle: AppTextStyles.body,
            columnSpacing: 32,
            columns: const [
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('DESCRIPTION')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('ITEMS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: [
              _CategoryRow(
                icon: Icons.devices,
                iconColor: Colors.indigoAccent,
                name: 'Electronics',
                description:
                    'Computers, smartphones, and accessories for the modern office.',
                status: 'Active',
                items: '1,248',
              ),
              _CategoryRow(
                icon: Icons.chair,
                iconColor: Colors.orangeAccent,
                name: 'Office Furniture',
                description:
                    'Ergonomic chairs, desks, and workspace organization units.',
                status: 'Active',
                items: '856',
              ),
              _CategoryRow(
                icon: Icons.add_shopping_cart_outlined,
                iconColor: Colors.pinkAccent,
                name: 'Legacy Merchandise',
                description:
                    'Old branded t-shirts and mugs. No longer in production.',
                status: 'Inactive',
                items: '0',
              ),
              _CategoryRow(
                icon: Icons.cloud,
                iconColor: Colors.cyanAccent,
                name: 'SaaS Subscriptions',
                description: 'Digital licenses for third-party tools.',
                status: 'Active',
                items: '42',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= CATEGORY ROW =================
class _CategoryRow extends DataRow {
  _CategoryRow({
    required IconData icon,
    required Color iconColor,
    required String name,
    required String description,
    required String status,
    required String items,
  }) : super(
          cells: [
            DataCell(
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Text(name),
                ],
              ),
            ),
            DataCell(
              SizedBox(
                width: 320,
                child: Text(
                  description,
                  style: AppTextStyles.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            DataCell(StatusPill(status)),
            DataCell(
              Text(
                items,
                style: AppTextStyles.caption.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.edit, size: 18, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Icon(Icons.delete, size: 18, color: Colors.redAccent),
                ],
              ),
            ),
          ],
        );
}
