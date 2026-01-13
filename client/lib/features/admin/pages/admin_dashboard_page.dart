import 'package:flutter/material.dart';

import '../layout/admin_scaffold.dart';
import '../layout/admin_tabs.dart';
import '../providers/admin_state.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/page_header.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: ValueListenableBuilder<AdminTab>(
        valueListenable: AdminState.selectedTab,
        builder: (context, tab, _) {
          return _buildContent(tab);
        },
      ),
    );
  }

  Widget _buildContent(AdminTab tab) {
    switch (tab) {
      case AdminTab.dashboard:
        return const _DashboardContent();

      case AdminTab.users:
      case AdminTab.dealers:
      case AdminTab.products:
      case AdminTab.categories:
      case AdminTab.settings:
      case AdminTab.roles:
        return _SimpleLabelContent(title: tab.label);
    }
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(),
          SizedBox(height: 24),
          KpiGrid(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SimpleLabelContent extends StatelessWidget {
  final String title;

  const _SimpleLabelContent({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
