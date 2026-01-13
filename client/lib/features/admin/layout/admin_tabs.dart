enum AdminTab {
  dashboard,
  users,
  dealers,
  products,
  categories,
  settings,
  roles,
}

extension AdminTabX on AdminTab {
  String get label {
    switch (this) {
      case AdminTab.dashboard:
        return 'Dashboard';
      case AdminTab.users:
        return 'Users';
      case AdminTab.dealers:
        return 'Dealers';
      case AdminTab.products:
        return 'Products';
      case AdminTab.categories:
        return 'Categories';
      case AdminTab.settings:
        return 'Settings';
      case AdminTab.roles:
        return 'Roles & Permissions';
    }
  }
}
