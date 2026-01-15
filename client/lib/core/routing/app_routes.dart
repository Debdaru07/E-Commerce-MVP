class AppRoutes {
  // 🌍 Public
  static const landing = '/';

  // 🔐 Auth – Consumer
  static const loginConsumer = '/auth/consumer/login';
  static const signupConsumer = '/auth/consumer/signup';

  // 🔐 Auth – Dealer
  static const loginDealer = '/auth/dealer/login';
  static const signupDealer = '/auth/dealer/signup';

  // 🔐 Auth – Admin (HARD-CODED / hidden)
  static const loginAdmin = '/auth/admin/login';

  // 🚀 Apps
  static const consumerApp = '/consumer';
  static const dealerDashboard = '/dealer';
  static const adminDashboard = '/admin';
}
