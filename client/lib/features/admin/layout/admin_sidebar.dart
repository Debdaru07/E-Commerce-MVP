import 'package:flutter/material.dart';

import '../widgets/sidebar_menu_item.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1C192E),
        border: Border(
          right: BorderSide(color: Color(0xFF2E294E)),
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
                colors: [Color(0xFF4B2BEE), Color(0xFF7C4DFF)],
              ),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NexusAdmin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'SaaS Command Center',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9B92C9),
                ),
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
          active: true,
        ),
        SidebarMenuItem(
          icon: Icons.group,
          label: 'Users',
        ),
        SidebarMenuItem(
          icon: Icons.business_center,
          label: 'Dealers',
        ),
        SidebarMenuItem(
          icon: Icons.inventory_2,
          label: 'Products',
        ),
        SidebarMenuItem(
          icon: Icons.category,
          label: 'Categories',
        ),
        SizedBox(height: 24),
        _MenuSection(title: 'System'),
        SidebarMenuItem(
          icon: Icons.settings,
          label: 'Settings',
        ),
        SidebarMenuItem(
          icon: Icons.security,
          label: 'Roles & Permissions',
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
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF9B92C9),
        ),
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
          top: BorderSide(color: Color(0xFF2E294E)),
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF4B2BEE),
            child: Text(
              'AG',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alexander G.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'Super Admin',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9B92C9),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_vert,
            color: Color(0xFF9B92C9),
          ),
        ],
      ),
    );
  }
}
