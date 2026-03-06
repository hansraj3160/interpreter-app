part of 'app_pages.dart';

abstract class Routes {
  Routes._(); // Prevent instantiation

  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';   // Naya
  static const SIGNUP = '/signup';
  // Future routes yahan add honge, e.g.,
  // static const LOGIN = '/login';
  // static const DASHBOARD = '/dashboard';
}