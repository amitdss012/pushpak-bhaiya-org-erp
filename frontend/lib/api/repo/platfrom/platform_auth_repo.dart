import '../../api_client.dart';
import '../../models/models.dart';

/// Repository for platform admin authentication API operations.
class PlatformAuthRepo {
  PlatformAuthRepo._();

  /// Authenticate platform admin with email & password.
  static Future<PlatformLoginResponse> login(PlatformLoginRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/platform/login',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    final loginResponse = PlatformLoginResponse.fromJson(rawData);

    if (loginResponse.token.isNotEmpty) {
      ApiClient().setAuthToken(loginResponse.token);
    }

    return loginResponse;
  }

  /// Retrieve the authenticated platform admin profile.
  static Future<PlatformAdminModel> getProfile() async {
    final response =
        await ApiClient().get<Map<String, dynamic>>('/platform/profile');
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return PlatformAdminModel.fromJson(rawData);
  }

  /// Logout platform admin and clear stored token.
  static Future<void> logout() async {
    try {
      await ApiClient().post<Map<String, dynamic>>('/platform/logout');
    } catch (_) {
      // Gracefully ignore network/backend errors during session termination
    } finally {
      ApiClient().clearAuthToken();
    }
  }
}
