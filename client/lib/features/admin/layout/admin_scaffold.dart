import 'package:flutter/material.dart';

import 'admin_header.dart';
import 'admin_sidebar.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;

  const AdminScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131022),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                const AdminHeader(),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
