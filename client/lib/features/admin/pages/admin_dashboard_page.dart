import 'package:flutter/material.dart';

import '../layout/admin_scaffold.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/page_header.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      body: SingleChildScrollView(
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
      ),
    );
  }
}
