import 'package:dio/dio.dart';

import '../../core/auth/token_storage.dart';

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
    if (options.headers['Authorization'] == null) {
      final isPlatformEndpoint = options.path.startsWith('/platfrom') ||
          options.path.startsWith('/platform');
      final token = isPlatformEndpoint
          ? TokenStorage.getPlatformToken()
          : (TokenStorage.getUserToken() ?? _authToken);

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path.toLowerCase();
      // Never trigger auto-logout if the failing request is itself an authentication,
      // session termination, login, or token refresh endpoint.
      final isAuthEndpoint = path.contains('/auth/login') ||
          path.contains('/auth/logout') ||
          path.contains('/auth/refresh-token') ||
          path.contains('/platform/login') ||
          path.contains('/platform/logout');

      if (!isAuthEndpoint) {
        onUnauthorized?.call();
      }
    }
    handler.next(err);
  }
}
