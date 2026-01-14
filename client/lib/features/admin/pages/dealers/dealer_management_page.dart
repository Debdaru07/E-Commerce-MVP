import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../widgets/filter_toolbar.dart';
import '../../widgets/management_header.dart';
import '../../widgets/status_pill.dart';

class DealerManagementPage extends StatelessWidget {
  const DealerManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ManagementHeader(
            title: 'Dealer Management',
            subtitle:
                'Manage your dealer network, track performance, and approve new partners.',
            actionLabel: 'Add Dealer',
            onAction: () {},
          ),
          const SizedBox(height: 24),
          const FilterToolbar(
            hintText: 'Search by dealer name, ID or email...',
            filters: ['All Status', 'Active', 'Pending'],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _dealerTable(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _dealerTable(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: screenWidth - 280 - 48),
          child: DataTable(
            headingRowHeight: 48,
            dataRowHeight: 76,
            headingRowColor: WidgetStateProperty.all(AppColors.backgroundDark),
            headingTextStyle: AppTextStyles.labelSmall,
            dataTextStyle: AppTextStyles.body,
            columns: const [
              DataColumn(label: SizedBox(width: 24)),
              DataColumn(label: Text('DEALER')),
              DataColumn(label: Text('CONTACT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('PRODUCTS')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: [
              _DealerRow(
                name: 'Cyber Motors Inc.',
                dealerId: '#DL-8832',
                email: 'contact@cybermotors.com',
                phone: '+1 (555) 123-4567',
                status: 'Active',
                products: '142',
              ),
              _DealerRow(
                name: 'Northway Auto Group',
                dealerId: '#DL-9941',
                email: 'admin@northway.io',
                phone: '+1 (555) 987-6543',
                status: 'Pending',
                products: '0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DealerRow extends DataRow {
  _DealerRow({
    required String name,
    required String dealerId,
    required String email,
    required String phone,
    required String status,
    required String products,
  }) : super(
          cells: [
            const DataCell(Checkbox(value: false, onChanged: null)),
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name),
                  const SizedBox(height: 4),
                  Text(dealerId, style: AppTextStyles.caption),
                ],
              ),
            ),
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(email),
                  const SizedBox(height: 4),
                  Text(phone, style: AppTextStyles.caption),
                ],
              ),
            ),
            DataCell(StatusPill(status)),
            DataCell(Text(products)),
            const DataCell(
              Icon(Icons.more_vert, color: AppColors.textSecondary),
            ),
          ],
        );
}
