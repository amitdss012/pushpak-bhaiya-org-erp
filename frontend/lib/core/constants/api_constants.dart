/// Centralized API configuration constants and networking parameters.
class ApiConstants {
  ApiConstants._();

  /// Base URL for backend REST API.
  /// Can be overridden at build/runtime using `--dart-define=API_BASE_URL=...`
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  /// Default timeout durations for HTTP requests.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
