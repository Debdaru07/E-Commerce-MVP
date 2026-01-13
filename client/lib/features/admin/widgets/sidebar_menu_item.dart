import 'package:flutter/material.dart';

import '../layout/admin_tabs.dart';
import '../providers/admin_state.dart';

class SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AdminTab tab;

  const SidebarMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AdminTab>(
      valueListenable: AdminState.selectedTab,
      builder: (_, selectedTab, __) {
        final bool isActive = selectedTab == tab;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4B2BEE) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              AdminState.selectedTab.value = tab;
            },
            dense: true,
          ),
        );
      },
    );
  }
}
