// lib/core/errors/exceptions.dart

/// Base class for all custom exceptions to allow for easier type checking
/// if needed, though direct type checking of specific exceptions is more common.
abstract class AppException implements Exception {
  final String _message;
  final String? _prefix;

  AppException([this._message = "", this._prefix]);

  @override
  String toString() {
    return "${_prefix ?? ""}$_message";
  }
}

/// Represents errors originating from the server during API calls.
/// Typically corresponds to HTTP status codes 5xx or unexpected responses.
class ServerException extends AppException {
  ServerException([String message = "An unexpected server error occurred."])
      : super(message, "Server Error: ");
}

/// Represents errors due to invalid client requests during API calls.
/// Typically corresponds to HTTP status codes 4xx (e.g., 400 Bad Request, 401 Unauthorized, 403 Forbidden).
class ClientException extends AppException {
  ClientException([String message = "There was an issue with your request."])
      : super(message, "Client Error: ");
}

/// Specifically for 404 Not Found errors from the API.
class NotFoundException extends AppException {
  NotFoundException([String message = "The requested resource was not found."])
      : super(message, "Not Found: ");
}

/// Represents errors originating from the local cache (e.g., SharedPreferences, SQLite).
class CacheException extends AppException {
  CacheException([String message = "Could not access or save cache data."])
      : super(message, "Cache Error: ");
}

/// Represents a situation where an operation requires an internet connection, but none is available.
class NoInternetException extends AppException {
  NoInternetException([String message = "No internet connection available."])
      : super(message, "Network Error: ");
}

/// Represents errors during input conversion or validation.
class InputValidationException extends AppException {
  InputValidationException([String message = "Invalid input provided."])
      : super(message, "Input Error: ");
}

/// Represents errors during authentication processes.
class AuthenticationException extends AppException {
  AuthenticationException([String message = "Authentication failed."])
      : super(message, "Authentication Error: ");
}

// You can add more specific exceptions as your app grows, for example:
// class PermissionDeniedException extends AppException {
//   PermissionDeniedException([String message = "Permission denied."])
//       : super(message, "Permission Error: ");
// }

// class TimeoutException extends AppException {
//   TimeoutException([String message = "The operation timed out."])
//       : super(message, "Timeout: ");
// }