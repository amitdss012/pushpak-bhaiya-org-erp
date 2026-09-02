import 'package:dio/dio.dart';

import '../../core/errors/api_exception.dart';

/// Interceptor that translates DioException into strongly-typed ApiException instances.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        message: exception.message,
      ),
    );
  }

  ApiException _mapDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection failed. Please check your internet connection.',
          rawData: err.error,
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const ApiException(message: 'Invalid SSL certificate.');

      case DioExceptionType.badResponse:
        final response = err.response;
        final statusCode = response?.statusCode;
        final data = response?.data;

        String? backendMessage;
        Map<String, dynamic>? validationErrors;

        if (data is Map<String, dynamic>) {
          if (data['message'] is String && (data['message'] as String).isNotEmpty) {
            backendMessage = data['message'] as String;
          }
          if (data['errors'] is Map<String, dynamic>) {
            validationErrors = data['errors'] as Map<String, dynamic>;
          }
        } else if (data is String && data.isNotEmpty) {
          backendMessage = data;
        }

        switch (statusCode) {
          case 400:
            return ValidationException(
              message: backendMessage ?? 'Validation error occurred.',
              errors: validationErrors,
              statusCode: statusCode,
              rawData: data,
            );
          case 401:
            return UnauthorizedException(
              message: backendMessage ?? 'Unauthorized access. Please login again.',
              statusCode: statusCode,
              rawData: data,
            );
          case 403:
            return ForbiddenException(
              message: backendMessage ?? 'Access forbidden. Insufficient permissions.',
              statusCode: statusCode,
              rawData: data,
            );
          case 404:
            return NotFoundException(
              message: backendMessage ?? 'The requested resource was not found.',
              statusCode: statusCode,
              rawData: data,
            );
          case 409:
            return ConflictException(
              message: backendMessage ?? 'A conflict occurred with the existing resource.',
              statusCode: statusCode,
              rawData: data,
            );
          case 500:
          case 502:
          case 503:
          case 504:
            return ServerException(
              message: backendMessage ?? 'Server error ($statusCode). Please try again later.',
              statusCode: statusCode,
              rawData: data,
            );
          default:
            return ApiException(
              message: backendMessage ?? 'Request failed with status $statusCode.',
              statusCode: statusCode,
              errors: validationErrors,
              rawData: data,
            );
        }

      case DioExceptionType.unknown:
        if (err.error is ApiException) {
          return err.error as ApiException;
        }
        return UnknownApiException(
          message: err.message ?? 'An unexpected error occurred.',
          rawData: err.error,
        );
    }
  }
}
