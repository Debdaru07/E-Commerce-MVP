import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => kReleaseMode
      ? const String.fromEnvironment('BASE_URL')
      : dotenv.env['base_url']!;

  static String get adminLogin => kReleaseMode
      ? const String.fromEnvironment('ADMIN_LOGIN')
      : dotenv.env['ADMIN_LOGIN']!;

  static String get dealerLogin => kReleaseMode
      ? const String.fromEnvironment('DEALER_LOGIN')
      : dotenv.env['DEALER_LOGIN']!;

  static String get consumerLogin => kReleaseMode
      ? const String.fromEnvironment('CONSUMER_LOGIN')
      : dotenv.env['CONSUMER_LOGIN']!;

  static String get dealerSignup => kReleaseMode
      ? const String.fromEnvironment('DEALER_SIGNUP')
      : dotenv.env['DEALER_SIGNUP']!;

  static String get consumerSignup => kReleaseMode
      ? const String.fromEnvironment('CONSUMER_SIGNUP')
      : dotenv.env['CONSUMER_SIGNUP']!;
}
