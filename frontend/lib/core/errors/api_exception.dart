/// Base exception class for all API-related networking and HTTP errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final dynamic rawData;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.rawData,
  });

  @override
  String toString() => message;
}

/// Thrown when device has no internet connection or socket timeout occurs.
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'Connection failed. Please check your internet connection.',
    super.statusCode,
    super.rawData,
  });
}

/// Thrown when authentication fails (HTTP 401).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized access. Please login again.',
    super.statusCode = 401,
    super.rawData,
  });
}

/// Thrown when permission is denied (HTTP 403).
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Access forbidden. Insufficient permissions.',
    super.statusCode = 403,
    super.rawData,
  });
}

/// Thrown when a resource is not found (HTTP 404).
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
    super.rawData,
  });
}

/// Thrown when a conflict occurs (HTTP 409).
class ConflictException extends ApiException {
  const ConflictException({
    super.message = 'A conflict occurred with the existing resource.',
    super.statusCode = 409,
    super.rawData,
  });
}

/// Thrown when request body/query fails validation (HTTP 400).
class ValidationException extends ApiException {
  const ValidationException({
    super.message = 'Validation error occurred.',
    super.statusCode = 400,
    super.errors,
    super.rawData,
  });

  /// Helper to get the first validation error message if available.
  String get firstErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstVal = errors!.values.first;
      if (firstVal is String) return firstVal;
    }
    return message;
  }
}

/// Thrown when server returns 5xx internal server errors.
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.statusCode = 500,
    super.rawData,
  });
}

/// Generic unexpected API exception.
class UnknownApiException extends ApiException {
  const UnknownApiException({
    super.message = 'An unexpected error occurred.',
    super.statusCode,
    super.rawData,
  });
}
