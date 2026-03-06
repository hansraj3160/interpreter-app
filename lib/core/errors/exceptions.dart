class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException() : super(message: 'No Internet Connection. Please check your network.');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super(message: 'Unauthorized. Please login again.', statusCode: 401);
}