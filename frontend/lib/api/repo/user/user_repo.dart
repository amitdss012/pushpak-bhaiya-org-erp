import '../../api_client.dart';
import '../../models/models.dart';

/// Repository handling all User & Authentication REST API calls.
class UserRepo {
  UserRepo._();

  /* ==========================================================================
     1. Authentication & Session Management
     ========================================================================== */

  /// Authenticate user with credentials and register active device session.
  static Future<UserLoginResponse> login(UserLoginRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/auth/login',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    final loginResponse = UserLoginResponse.fromJson(rawData);

    if (loginResponse.accessToken.isNotEmpty) {
      ApiClient().setAuthToken(loginResponse.accessToken);
    }

    return loginResponse;
  }

  /// Rotate refresh token and issue new token pair.
  static Future<RefreshTokenResponse> refreshToken(
      RefreshTokenRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/auth/refresh-token',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    final refreshResponse = RefreshTokenResponse.fromJson(rawData);

    if (refreshResponse.accessToken.isNotEmpty) {
      ApiClient().setAuthToken(refreshResponse.accessToken);
    }

    return refreshResponse;
  }

  /// Terminate current device session and clear stored token.
  static Future<void> logout() async {
    try {
      await ApiClient().post<Map<String, dynamic>>('/user/auth/logout');
    } catch (_) {
      // Gracefully ignore network/backend errors during session termination
    } finally {
      ApiClient().clearAuthToken();
    }
  }

  /// Terminate all active device sessions for authenticated user.
  static Future<void> logoutAll() async {
    try {
      await ApiClient().post<Map<String, dynamic>>('/user/auth/logout-all');
    } catch (_) {
      // Gracefully ignore network/backend errors during session termination
    } finally {
      ApiClient().clearAuthToken();
    }
  }

  /* ==========================================================================
     2. Profile & Persona Management
     ========================================================================== */

  /// Retrieve authenticated user profile with roles, permissions, and persona.
  static Future<UserModel> getProfile() async {
    final response = await ApiClient().get<Map<String, dynamic>>('/user/profile');
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /// Update personal details (firstName, lastName, phone).
  static Future<UserModel> updateProfile(UpdateProfileRequest request) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/user/profile',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /// Update user avatar image URL.
  static Future<UserModel> updateAvatar(UpdateAvatarRequest request) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/user/profile/avatar',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /* ==========================================================================
     3. Password Lifecycle & Security
     ========================================================================== */

  /// Change password for authenticated user and invalidate other sessions.
  static Future<void> changePassword(ChangePasswordRequest request) async {
    await ApiClient().post<Map<String, dynamic>>(
      '/user/security/change-password',
      data: request.toJson(),
    );
  }

  /// Request password reset token with 1-hour expiration.
  static Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/security/forgot-password',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return ForgotPasswordResponse.fromJson(rawData);
  }

  /// Reset password using reset token.
  static Future<void> resetPassword(ResetPasswordRequest request) async {
    await ApiClient().post<Map<String, dynamic>>(
      '/user/security/reset-password',
      data: request.toJson(),
    );
  }

  /* ==========================================================================
     4. Device Sessions & Activity Logs
     ========================================================================== */

  /// List all active logged-in device sessions for authenticated user.
  static Future<List<DeviceSessionModel>> getSessions() async {
    final response =
        await ApiClient().get<Map<String, dynamic>>('/user/sessions');
    final rawList = response.data?['data'] as List? ?? [];
    return rawList
        .map((s) => DeviceSessionModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  /// Remotely terminate a specific device session.
  static Future<void> revokeSession(String sessionId) async {
    await ApiClient().delete<Map<String, dynamic>>('/user/sessions/$sessionId');
  }

  /// Retrieve paginated security and login audit history.
  static Future<PaginatedAuditLogsResponse> getActivityLogs({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/activity-logs',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return PaginatedAuditLogsResponse.fromJson(rawData);
  }
}
