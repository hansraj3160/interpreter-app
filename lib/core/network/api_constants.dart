class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://interpreter.ruhsolution.com/api';
  
  // Timeouts (Milliseconds)
  static const int connectionTimeout = 40000; // 10 seconds
  static const int receiveTimeout = 40000;    // 10 seconds

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String updateInterpreterProfile = '/interpreter/update-profile';
  static const String uploadInterpreterDocs = '/interpreter/upload-docs';
  static const String getProfile = '/auth/client/get-profile';
  static const String getInterpreters = '/interpreter/list';
}