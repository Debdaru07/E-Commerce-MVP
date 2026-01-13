import 'package:flutter/material.dart';

import '../layout/admin_tabs.dart';

class AdminState {
  static final ValueNotifier<AdminTab> selectedTab =
      ValueNotifier(AdminTab.dashboard);
}
