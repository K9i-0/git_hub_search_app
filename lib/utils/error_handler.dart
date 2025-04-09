// Base exception class for API-related errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

// Network related exceptions
class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

// Rate limiting exceptions
class ApiRateLimitException extends ApiException {
  ApiRateLimitException(String message) : super(message);
}

// Server-side errors
class ServerException extends ApiException {
  ServerException(String message) : super(message);
}

// Client-side errors
class ClientException extends ApiException {
  ClientException(String message) : super(message);
}

// Helper class to provide user-friendly error messages
class ErrorHelper {
  static String getMessageForUser(Exception exception) {
    if (exception is ApiRateLimitException) {
      return 'GitHub API rate limit exceeded. Please try again later.';
    } else if (exception is NetworkException) {
      return 'Network error. Please check your connection and try again.';
    } else if (exception is ServerException) {
      return 'GitHub server error. Please try again later.';
    } else if (exception is ApiException) {
      return exception.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}