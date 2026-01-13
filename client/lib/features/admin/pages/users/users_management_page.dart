import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class UsersManagementPage extends StatelessWidget {
  const UsersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 24),
          _statsRow(),
          const SizedBox(height: 24),
          _toolbar(),
          const SizedBox(height: 24),
          Expanded(child: _usersTable(context)),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Management', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              'Manage access, permissions, and status for your team members.',
              style: AppTextStyles.subheading,
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Add New User',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ================= STATS =================
  Widget _statsRow() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(title: 'Total Users', value: '1,240'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(title: 'Active Users', value: '1,100'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatCard(title: 'Pending Invites', value: '140'),
        ),
      ],
    );
  }

  // ================= TOOLBAR =================
  Widget _toolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                hintText: 'Search users by name, email...',
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
          _chip('All Roles', active: true),
          _chip('Admins'),
          _chip('Editors'),
          _chip('Viewers'),
        ],
      ),
    );
  }

  Widget _chip(String label, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ================= DATA TABLE =================
  Widget _usersTable(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
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
            dataRowHeight: 72,
            headingRowColor: WidgetStateProperty.all(AppColors.backgroundDark),
            dividerThickness: 0.6,
            columnSpacing: 32,
            headingTextStyle: AppTextStyles.labelSmall,
            dataTextStyle: AppTextStyles.body,
            columns: const [
              DataColumn(label: SizedBox(width: 24)),
              DataColumn(label: Text('NAME')),
              DataColumn(label: Text('ROLE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('LAST LOGIN')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: [
              _row(
                name: 'Sophia Williams',
                email: 'sophia@example.com',
                role: 'Admin',
                status: 'Active',
                lastLogin: 'Oct 24, 2023\n12:30 PM',
              ),
              _row(
                name: 'Ethan Hunt',
                email: 'ethan.h@example.com',
                role: 'Editor',
                status: 'Active',
                lastLogin: 'Oct 23, 2023\n09:15 AM',
              ),
              _row(
                name: 'James Lee',
                email: 'j.lee@example.com',
                role: 'Viewer',
                status: 'Offline',
                lastLogin: 'Sep 15, 2023\n04:45 PM',
              ),
              _row(
                name: 'Michael Chen',
                email: 'm.chen@example.com',
                role: 'Editor',
                status: 'Pending',
                lastLogin: 'Invited 2h ago',
              ),
              _row(
                name: 'Olivia Martinez',
                email: 'omartinez@example.com',
                role: 'Viewer',
                status: 'Active',
                lastLogin: 'Oct 20, 2023\n10:05 AM',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static DataRow _row({
    required String name,
    required String email,
    required String role,
    required String status,
    required String lastLogin,
  }) {
    return DataRow(
      cells: [
        const DataCell(Checkbox(value: false, onChanged: null)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: AppTextStyles.body),
              const SizedBox(height: 4),
              Text(email, style: AppTextStyles.caption),
            ],
          ),
        ),
        DataCell(Text(role, style: AppTextStyles.caption)),
        DataCell(_statusPill(status)),
        DataCell(
          Text(lastLogin, style: AppTextStyles.caption),
        ),
        const DataCell(
          Icon(Icons.more_vert, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  static Widget _statusPill(String status) {
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.greenAccent;
        break;
      case 'Pending':
        color = Colors.orangeAccent;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(color: color),
      ),
    );
  }
}

// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }
}
