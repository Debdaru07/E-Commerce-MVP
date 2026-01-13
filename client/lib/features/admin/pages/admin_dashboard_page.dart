import 'package:flutter/material.dart';

import '../layout/admin_scaffold.dart';
import '../layout/admin_tabs.dart';
import '../providers/admin_state.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/page_header.dart';
import '../widgets/quick_actions_card.dart';
import 'dealers/dealer_management_page.dart';
import 'products/products_management_page.dart';
import 'users/users_management_page.dart';

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
        return const UsersManagementPage();
      case AdminTab.dealers:
        return const DealerManagementPage();
      case AdminTab.products:
        return const ProductsManagementPage();
      case AdminTab.categories:
      case AdminTab.settings:
      case AdminTab.roles:
        return _SimpleLabelContent(title: tab.label);
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                               DASHBOARD BODY                               */
/* -------------------------------------------------------------------------- */

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
          DashboardMainGrid(),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               MAIN GRID                                    */
/* -------------------------------------------------------------------------- */

class DashboardMainGrid extends StatelessWidget {
  const DashboardMainGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1100;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.66,
                child: const Column(
                  children: [
                    PlatformGrowthCard(),
                    SizedBox(height: 24),
                    RecentActivityCard(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: constraints.maxWidth * 0.32,
                child: const DashboardSidebar(),
              ),
            ],
          );
        }

        return const Column(
          children: [
            PlatformGrowthCard(),
            SizedBox(height: 24),
            RecentActivityCard(),
            SizedBox(height: 24),
            DashboardSidebar(),
          ],
        );
      },
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               LEFT SIDE                                    */
/* -------------------------------------------------------------------------- */

class PlatformGrowthCard extends StatelessWidget {
  const PlatformGrowthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C192E),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Platform Growth",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "New users vs dealers over time",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: "Last 7 Days",
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xFF292348),
                  items: const [
                    DropdownMenuItem(
                      value: "Last 7 Days",
                      child: Text("Last 7 Days"),
                    ),
                    DropdownMenuItem(
                      value: "Last 30 Days",
                      child: Text("Last 30 Days"),
                    ),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SizedBox(
              height: 220,
              child: Placeholder(), // Replace with chart later
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C192E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  "View All",
                  style: TextStyle(color: Color(0xFF4B2BEE)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return const ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text("Sarah Jenkins"),
                subtitle: Text('Added new dealer "AutoMax"'),
                trailing: Chip(
                  label: Text("Completed"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               RIGHT SIDE                                   */
/* -------------------------------------------------------------------------- */

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        QuickActionsCard(),
        SizedBox(height: 24),
        StorageStatusCard(),
        SizedBox(height: 24),
        HelpCard(),
      ],
    );
  }
}

class StorageStatusCard extends StatelessWidget {
  const StorageStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Color(0xFF1C192E),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Storage Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text("Database Size 45.2 / 100 GB"),
            SizedBox(height: 8),
            LinearProgressIndicator(value: 0.45),
            SizedBox(height: 16),
            Text("Media Files 120.5 / 500 GB"),
            SizedBox(height: 8),
            LinearProgressIndicator(value: 0.24),
          ],
        ),
      ),
    );
  }
}

class HelpCard extends StatelessWidget {
  const HelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF4B2BEE),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need Help?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Check our documentation for admin guides."),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {},
              child: const Text(
                "View Docs",
                style: TextStyle(color: Color(0xFF4B2BEE)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              FALLBACK TAB                                  */
/* -------------------------------------------------------------------------- */

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
