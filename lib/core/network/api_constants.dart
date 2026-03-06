class ApiConstants {
  ApiConstants._();

  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'https://api.interpreterbooking.com/v1';
  
  // Timeouts (Milliseconds)
  static const int connectionTimeout = 10000; // 10 seconds
  static const int receiveTimeout = 10000;    // 10 seconds

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String getProfile = '/users/profile';
}