import 'package:flutter/material.dart';
import '../../presentation/pages/landing_page.dart';
import '../../features/auth/pages/login_choice_page.dart';
import '../../features/auth/pages/login_consumer_page.dart';
import '../../features/auth/pages/login_dealer_page.dart';
import '../../features/auth/pages/signup_consumer_page.dart';
import '../../features/auth/pages/signup_dealer_page.dart';
import '../../features/consumer/pages/consumer_home_page.dart';
import '../../features/dealer/pages/dealer_dashboard_page.dart';
import '../../features/admin/pages/admin_dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());

      case AppRoutes.loginChoice:
        return MaterialPageRoute(builder: (_) => const LoginChoicePage());

      case AppRoutes.loginConsumer:
        return MaterialPageRoute(builder: (_) => const LoginConsumerPage());

      case AppRoutes.loginDealer:
        return MaterialPageRoute(builder: (_) => const LoginDealerPage());

      case AppRoutes.signupConsumer:
        return MaterialPageRoute(builder: (_) => const SignupConsumerPage());

      case AppRoutes.signupDealer:
        return MaterialPageRoute(builder: (_) => const SignupDealerPage());

      case AppRoutes.consumerApp:
        return MaterialPageRoute(builder: (_) => const ConsumerHomePage());

      case AppRoutes.dealerDashboard:
        return MaterialPageRoute(builder: (_) => const DealerDashboardPage());

      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
