part of 'app_pages.dart';

abstract class Routes {
  Routes._(); // Prevent instantiation

  static const SPLASH = '/splash';
  static const WELCOME = '/welcome';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const VERIFY_OTP = '/verify-otp';
  static const RESET_PASSWORD = '/reset-password';
  static const CLIENT_DASHBOARD = '/client-dashboard';
  static const INTERPRETER_SETUP_PROFILE = '/interpreter-setup-profile';
  static const INTERPRETER_UPLOAD_DOCS = '/interpreter-upload-docs';
  static const INTERPRETER_DASHBOARD = '/interpreter-dashboard';
  // Future routes yahan add honge, e.g.,
  // static const LOGIN = '/login';
  // static const DASHBOARD = '/dashboard';
}