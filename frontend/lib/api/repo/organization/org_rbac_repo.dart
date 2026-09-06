import '../../api_client.dart';
import '../../models/models.dart';

/// Repository for Organization User, Role, and Permission Management (RBAC).
///
/// Communicates directly with backend `/api/v1/user/*` endpoints.
/// Does not fall back to static/mock dummy data, ensuring clean error states and authentic UI rendering.
class OrgRbacRepo {
  OrgRbacRepo._();

  // ==========================================================================
  // 1. User Operations
  // ==========================================================================

  /// Fetch users with search, role, and department filters
  static Future<List<OrgUserModel>> getUsers({
    String? search,
    String? role,
    String? department,
    String? status,
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/users',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (role != null && role != 'all') 'role': role,
        if (department != null && department != 'all') 'department': department,
        if (status != null && status != 'all') 'status': status,
      },
    );

    final data = response.data?['data'];
    List rawList = [];
    if (data is Map<String, dynamic>) {
      rawList = (data['users'] as List?) ?? (data['data'] as List?) ?? [];
    } else if (data is List) {
      rawList = data;
    }

    return rawList
        .map((u) => OrgUserModel.fromJson(u as Map<String, dynamic>))
        .toList();
  }

  /// Create a new user with credentials and assigned roles
  static Future<OrgUserModel> createUser(CreateOrgUserRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/users',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgUserModel.fromJson(rawData);
  }

  /// Update an existing user's details or status
  static Future<OrgUserModel> updateUser(
    String id,
    UpdateOrgUserRequest request,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/user/users/$id',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgUserModel.fromJson(rawData);
  }

  /// Assign roles to a user
  static Future<OrgUserModel> assignRolesToUser(
    AssignUserRolesRequest request,
  ) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/users/${request.userId}/roles',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgUserModel.fromJson(rawData);
  }

  /// Reset password for a user
  static Future<void> resetPassword(String userId, String newPassword) async {
    await ApiClient().post<Map<String, dynamic>>(
      '/user/users/$userId/reset-password',
      data: {'newPassword': newPassword},
    );
  }

  /// Delete or archive user
  static Future<void> deleteUser(String id) async {
    await ApiClient().delete<Map<String, dynamic>>('/user/users/$id');
  }

  // ==========================================================================
  // 2. Role Operations
  // ==========================================================================

  /// Fetch all Organization roles
  static Future<List<OrgRoleModel>> getRoles({String? scope}) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/roles',
      queryParameters: scope != null ? {'scope': scope} : null,
    );

    final data = response.data?['data'];
    List rawList = [];
    if (data is Map<String, dynamic>) {
      rawList = (data['data'] as List?) ?? (data['roles'] as List?) ?? [];
    } else if (data is List) {
      rawList = data;
    }

    return rawList
        .map((r) => OrgRoleModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single Role by ID with permissions
  static Future<OrgRoleModel> getRoleById(String roleId) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/roles/$roleId',
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgRoleModel.fromJson(rawData);
  }

  /// Create a new Role with optional initial permissions
  static Future<OrgRoleModel> createRole(CreateOrgRoleRequest request) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/user/roles',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgRoleModel.fromJson(rawData);
  }

  /// Update an existing Role
  static Future<OrgRoleModel> updateRole(
    String id,
    UpdateOrgRoleRequest request,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/user/roles/$id',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgRoleModel.fromJson(rawData);
  }

  /// Delete a custom Role
  static Future<void> deleteRole(String id) async {
    await ApiClient().delete<Map<String, dynamic>>('/user/roles/$id');
  }

  // ==========================================================================
  // 3. Permission Operations
  // ==========================================================================

  /// Get all available permission categories and definitions
  static Future<List<OrgPermissionCategory>> getAllPermissions() async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/user/permissions',
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final grouped = data['groupedByModule'];
      if (grouped is Map<String, dynamic>) {
        return grouped.entries.map((entry) {
          final moduleKey = entry.key;
          final perms = (entry.value as List? ?? [])
              .map((p) => OrgPermissionItem.fromJson(p as Map<String, dynamic>))
              .toList();
          return OrgPermissionCategory(
            id: moduleKey,
            name: _formatModuleName(moduleKey),
            description: 'Permissions for ${_formatModuleName(moduleKey)} module',
            permissions: perms,
          );
        }).toList();
      }

      if (data['permissions'] is List) {
        final permsList = (data['permissions'] as List)
            .map((p) => OrgPermissionItem.fromJson(p as Map<String, dynamic>))
            .toList();
        final Map<String, List<OrgPermissionItem>> groupMap = {};
        for (final p in permsList) {
          groupMap.putIfAbsent(p.module, () => []).add(p);
        }
        return groupMap.entries.map((entry) {
          return OrgPermissionCategory(
            id: entry.key,
            name: _formatModuleName(entry.key),
            description: 'Permissions for ${_formatModuleName(entry.key)} module',
            permissions: entry.value,
          );
        }).toList();
      }
    } else if (data is List) {
      return data
          .map((c) => OrgPermissionCategory.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  /// Assign / update permissions for a specific role
  static Future<OrgRoleModel> updateRolePermissions(
    UpdateRolePermissionsRequest request,
  ) async {
    final response = await ApiClient().put<Map<String, dynamic>>(
      '/user/roles/${request.roleId}/permissions',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrgRoleModel.fromJson(rawData);
  }

  static String _formatModuleName(String key) {
    if (key.isEmpty) return 'General';
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}
