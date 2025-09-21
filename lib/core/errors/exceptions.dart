/// Custom exception classes for handling different error scenarios
///
/// Exception thrown when a server error occurs
class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'Server error occurred'});
}

/// Exception thrown when a network error occurs
class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network error occurred'});
}

/// Exception thrown when a validation error occurs
class ValidationException implements Exception {
  final String message;
  final String? field;

  ValidationException({required this.message, this.field});
}

/// Exception thrown when an authentication error occurs
class AuthException implements Exception {
  final String message;

  AuthException({this.message = 'Authentication error occurred'});
}

/// Exception thrown when a parsing error occurs
class ParsingException implements Exception {
  final String message;
  final dynamic data;

  ParsingException({required this.message, this.data});
}
