import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../widgets/filter_toolbar.dart';
import '../../widgets/management_header.dart';
import '../../widgets/status_pill.dart';

class UsersManagementPage extends StatelessWidget {
  const UsersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Reused Header
          ManagementHeader(
            title: 'User Management',
            subtitle:
                'Manage access, permissions, and status for your team members.',
            actionLabel: 'Add New User',
            onAction: () {},
          ),

          const SizedBox(height: 24),

          _statsRow(),

          const SizedBox(height: 24),

          // ✅ Reused Toolbar
          const FilterToolbar(
            hintText: 'Search users by name, email...',
            filters: ['All Roles', 'Admins', 'Editors', 'Viewers'],
          ),

          const SizedBox(height: 24),

          Expanded(
            child: _usersTable(screenWidth),
          ),
        ],
      ),
    );
  }

  // ================= STATS =================
  Widget _statsRow() {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Users',
            value: '1,240',
            icon: Icons.group,
            trend: '12%',
            trendUp: true,
            trendColor: Colors.greenAccent,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _StatCard(
            title: 'Active Users',
            value: '1,100',
            icon: Icons.person_outline,
            trend: '5%',
            trendUp: true,
            trendColor: Colors.greenAccent,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: _StatCard(
            title: 'Pending Invites',
            value: '140',
            icon: Icons.mail_outline,
            trend: '2%',
            trendUp: false,
            trendColor: Colors.orangeAccent,
          ),
        ),
      ],
    );
  }

  // ================= DATA TABLE =================
  Widget _usersTable(double screenWidth) {
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
            dataRowHeight: 72,
            headingRowColor: WidgetStateProperty.all(AppColors.backgroundDark),
            headingTextStyle: AppTextStyles.labelSmall,
            dataTextStyle: AppTextStyles.body,
            columnSpacing: 32,
            columns: const [
              DataColumn(label: SizedBox(width: 24)),
              DataColumn(label: Text('NAME')),
              DataColumn(label: Text('ROLE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('LAST LOGIN')),
              DataColumn(label: Text('ACTIONS')),
            ],
            rows: [
              _UserRow(
                name: 'Sophia Williams',
                email: 'sophia@example.com',
                role: 'Admin',
                status: 'Active',
                lastLogin: 'Oct 24, 2023\n12:30 PM',
              ),
              _UserRow(
                name: 'Ethan Hunt',
                email: 'ethan.h@example.com',
                role: 'Editor',
                status: 'Active',
                lastLogin: 'Oct 23, 2023\n09:15 AM',
              ),
              _UserRow(
                name: 'James Lee',
                email: 'j.lee@example.com',
                role: 'Viewer',
                status: 'Offline',
                lastLogin: 'Sep 15, 2023\n04:45 PM',
              ),
              _UserRow(
                name: 'Michael Chen',
                email: 'm.chen@example.com',
                role: 'Editor',
                status: 'Pending',
                lastLogin: 'Invited 2h ago',
              ),
              _UserRow(
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
}

// ================= USER ROW =================
class _UserRow extends DataRow {
  _UserRow({
    required String name,
    required String email,
    required String role,
    required String status,
    required String lastLogin,
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
                  Text(email, style: AppTextStyles.caption),
                ],
              ),
            ),
            DataCell(Text(role, style: AppTextStyles.caption)),
            DataCell(StatusPill(status)),
            DataCell(Text(lastLogin, style: AppTextStyles.caption)),
            const DataCell(
              Icon(Icons.more_vert, color: AppColors.textSecondary),
            ),
          ],
        );
}

// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String trend;
  final bool trendUp;
  final Color trendColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendUp,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              Icon(icon, size: 20, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              _trendBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trendBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            trendUp ? Icons.trending_up : Icons.trending_down,
            size: 14,
            color: trendColor,
          ),
          const SizedBox(width: 2),
          Text(
            trend,
            style: AppTextStyles.labelSmall.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
