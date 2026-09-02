import 'package:dio/dio.dart';

/// Interceptor that automatically attaches Bearer authentication token
/// to outgoing HTTP requests and handles unauthorized responses.
class AuthInterceptor extends QueuedInterceptor {
  String? _authToken;
  void Function()? onUnauthorized;

  AuthInterceptor({
    String? initialToken,
    this.onUnauthorized,
  }) : _authToken = initialToken;

  /// Current authentication token.
  String? get token => _authToken;

  /// Update the active authentication token.
  void setToken(String? token) {
    _authToken = token;
  }

  /// Clear the active token.
  void clearToken() {
    _authToken = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_authToken != null && _authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
