import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/sidebar_menu_item.dart';
import 'admin_tabs.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          right: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Column(
        children: [
          _SidebarHeader(),
          Expanded(child: _SidebarMenu()),
          _SidebarProfile(),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF7C4DFF)],
              ),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NexusAdmin',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 16,
                  letterSpacing: -0.2, // tracking-tight
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'SaaS Command Center',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: const [
        _MenuSection(title: 'Main Menu'),
        SidebarMenuItem(
          icon: Icons.dashboard,
          label: 'Dashboard',
          tab: AdminTab.dashboard,
        ),
        SidebarMenuItem(
          icon: Icons.group,
          label: 'Users',
          tab: AdminTab.users,
        ),
        SidebarMenuItem(
          icon: Icons.business_center,
          label: 'Dealers',
          tab: AdminTab.dealers,
        ),
        SidebarMenuItem(
          icon: Icons.inventory_2,
          label: 'Products',
          tab: AdminTab.products,
        ),
        SidebarMenuItem(
          icon: Icons.category,
          label: 'Categories',
          tab: AdminTab.categories,
        ),
        SizedBox(height: 24),
        _MenuSection(title: 'System'),
        SidebarMenuItem(
          icon: Icons.settings,
          label: 'Settings',
          tab: AdminTab.settings,
        ),
        SidebarMenuItem(
          icon: Icons.security,
          label: 'Roles & Permissions',
          tab: AdminTab.roles,
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;

  const _MenuSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall,
      ),
    );
  }
}

class _SidebarProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              'AG',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alexander G.',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Super Admin',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.more_vert,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
