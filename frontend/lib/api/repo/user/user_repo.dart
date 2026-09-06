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

  // ==========================================================================
  // 5. User Management & Provisioning (/user/users/*)
  // ==========================================================================

  /// List paginated users with branch, role, and search filters.
  static Future<PaginatedUsersResponse> getUsers([
    GetUsersParams params = const GetUsersParams(),
  ]) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/users',
      queryParameters: params.toQueryParameters(),
    );
    final rawData = response.data ?? {};
    return PaginatedUsersResponse.fromJson(rawData);
  }

  /// Retrieve user details with assigned roles and relations by ID.
  static Future<UserModel> getUserById(String userId) async {
    final response =
        await ApiClient().get<Map<String, dynamic>>('/user/users/$userId');
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /// Create new user with credentials, scope, and initial roles.
  static Future<UserModel> createUser(CreateUserInput input) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/users',
      data: input.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /// Update user status (ACTIVE, INACTIVE, SUSPENDED, INVITED).
  static Future<UserModel> updateUserStatus(
    String userId,
    UpdateUserStatusInput input,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/user/users/$userId/status',
      data: input.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  /// Assign/sync roles to a user.
  static Future<UserModel> assignRolesToUser(
    String userId,
    AssignRolesToUserInput input,
  ) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/users/$userId/roles',
      data: input.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserModel.fromJson(rawData);
  }

  // ==========================================================================
  // 6. Role Management & RBAC (/user/roles/*)
  // ==========================================================================

  /// List paginated roles for organization / branch.
  static Future<PaginatedRolesResponse> getRoles([
    GetRolesParams params = const GetRolesParams(),
  ]) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/roles',
      queryParameters: params.toQueryParameters(),
    );
    final rawData = response.data ?? {};
    return PaginatedRolesResponse.fromJson(rawData);
  }

  /// Retrieve role details with assigned permissions by ID.
  static Future<UserRoleItem> getRoleById(String roleId) async {
    final response =
        await ApiClient().get<Map<String, dynamic>>('/user/roles/$roleId');
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserRoleItem.fromJson(rawData);
  }

  /// Create new custom role with scope enforcement and initial permissions.
  static Future<UserRoleItem> createRole(CreateRoleInput input) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/roles',
      data: input.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserRoleItem.fromJson(rawData);
  }

  /// Assign/sync atomic permissions to a role.
  static Future<UserRoleItem> assignPermissionsToRole(
    String roleId,
    AssignPermissionsToRoleInput input,
  ) async {
    final response = await ApiClient().put<Map<String, dynamic>>(
      '/user/roles/$roleId/permissions',
      data: input.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return UserRoleItem.fromJson(rawData);
  }

  // ==========================================================================
  // 7. System Permissions Catalog (/user/permissions/*)
  // ==========================================================================

  /// List all atomic system permissions for UI selectors.
  static Future<List<SystemPermissionModel>> getPermissions() async {
    final response =
        await ApiClient().get<Map<String, dynamic>>('/user/permissions');
    final rawList = response.data?['data'] as List? ?? [];
    return rawList
        .map((p) => SystemPermissionModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
