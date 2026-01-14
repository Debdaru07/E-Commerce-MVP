import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['base_url']!;

  // AUTH
  static String get adminLogin => dotenv.env['ADMIN_LOGIN']!;
  static String get dealerLogin => dotenv.env['DEALER_LOGIN']!;
  static String get consumerLogin => dotenv.env['CONSUMER_LOGIN']!;
}
