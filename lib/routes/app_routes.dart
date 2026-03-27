part of 'app_pages.dart';

abstract class Routes {
  Routes._(); // Prevent instantiation

  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const CLIENT_DASHBOARD = '/client-dashboard';
  // Future routes yahan add honge, e.g.,
  // static const LOGIN = '/login';
  // static const DASHBOARD = '/dashboard';
}