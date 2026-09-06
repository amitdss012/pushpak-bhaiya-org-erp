import '../pagination_model.dart';

/// Organization summary attached to a user profile.
class UserOrganizationInfo {
  final String id;
  final String name;
  final String slug;
  final String? logo;

  const UserOrganizationInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
  });

  factory UserOrganizationInfo.fromJson(Map<String, dynamic> json) {
    return UserOrganizationInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'logo': logo,
      };
}

/// Branch summary attached to a user profile.
class UserBranchInfo {
  final String id;
  final String name;
  final String slug;
  final String? code;

  const UserBranchInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.code,
  });

  factory UserBranchInfo.fromJson(Map<String, dynamic> json) {
    return UserBranchInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'code': code,
      };
}

/// Permission item assigned to a role.
class UserPermissionItem {
  final String id;
  final String key;
  final String name;
  final String module;
  final String action;

  const UserPermissionItem({
    required this.id,
    required this.key,
    required this.name,
    required this.module,
    required this.action,
  });

  factory UserPermissionItem.fromJson(Map<String, dynamic> json) {
    return UserPermissionItem(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      module: json['module'] as String? ?? '',
      action: json['action'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'module': module,
        'action': action,
      };
}

/// Role item attached to a user.
class UserRoleItem {
  final String id;
  final String name;
  final String slug;
  final String scope;
  final String? description;
  final List<UserPermissionItem> permissions;

  const UserRoleItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.scope,
    this.description,
    this.permissions = const [],
  });

  factory UserRoleItem.fromJson(Map<String, dynamic> json) {
    final roleObj = json['role'] as Map<String, dynamic>? ?? json;
    final permsRaw = roleObj['rolePermissions'] as List? ?? [];
    final permissions = permsRaw
        .map((p) => p['permission'] as Map<String, dynamic>?)
        .where((p) => p != null)
        .map((p) => UserPermissionItem.fromJson(p!))
        .toList();

    return UserRoleItem(
      id: roleObj['id'] as String? ?? '',
      name: roleObj['name'] as String? ?? '',
      slug: roleObj['slug'] as String? ?? '',
      scope: roleObj['scope'] as String? ?? 'BRANCH',
      description: roleObj['description'] as String?,
      permissions: permissions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'scope': scope,
        'description': description,
        'permissions': permissions.map((p) => p.toJson()).toList(),
      };
}

/// Student persona link summary.
class UserStudentInfo {
  final String id;
  final String? enrollmentNo;
  final String? applicationNo;
  final String admissionStatus;

  const UserStudentInfo({
    required this.id,
    this.enrollmentNo,
    this.applicationNo,
    this.admissionStatus = 'APPROVED',
  });

  factory UserStudentInfo.fromJson(Map<String, dynamic> json) {
    return UserStudentInfo(
      id: json['id'] as String? ?? '',
      enrollmentNo: json['enrollmentNo'] as String?,
      applicationNo: json['applicationNo'] as String?,
      admissionStatus: json['admissionStatus'] as String? ?? 'APPROVED',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'enrollmentNo': enrollmentNo,
        'applicationNo': applicationNo,
        'admissionStatus': admissionStatus,
      };
}

/// Teacher persona link summary.
class UserTeacherInfo {
  final String id;
  final String employeeCode;
  final String designation;
  final String status;

  const UserTeacherInfo({
    required this.id,
    required this.employeeCode,
    required this.designation,
    this.status = 'ACTIVE',
  });

  factory UserTeacherInfo.fromJson(Map<String, dynamic> json) {
    return UserTeacherInfo(
      id: json['id'] as String? ?? '',
      employeeCode: json['employeeCode'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeCode': employeeCode,
        'designation': designation,
        'status': status,
      };
}

/// Parent persona link summary.
class UserParentInfo {
  final String id;
  final String? occupation;

  const UserParentInfo({
    required this.id,
    this.occupation,
  });

  factory UserParentInfo.fromJson(Map<String, dynamic> json) {
    return UserParentInfo(
      id: json['id'] as String? ?? '',
      occupation: json['occupation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'occupation': occupation,
      };
}

/// Primary User Model representing an authenticated user account.
class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;
  final String status;
  final String scope;
  final String organizationId;
  final String? branchId;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserOrganizationInfo? organization;
  final UserBranchInfo? branch;
  final List<UserRoleItem> roles;
  final UserStudentInfo? student;
  final UserTeacherInfo? teacher;
  final UserParentInfo? parent;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
    this.status = 'ACTIVE',
    this.scope = 'BRANCH',
    required this.organizationId,
    this.branchId,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.organization,
    this.branch,
    this.roles = const [],
    this.student,
    this.teacher,
    this.parent,
  });

  String get fullName {
    if (lastName == null || lastName!.trim().isEmpty) {
      return firstName;
    }
    return '$firstName $lastName'.trim();
  }

  String get primaryRole {
    if (roles.isNotEmpty) {
      return roles.first.name;
    }
    if (isStudent) return 'Student';
    if (isTeacher) return 'Teacher';
    if (isParent) return 'Parent';
    return scope == 'ORGANIZATION' ? 'Organization Admin' : 'Branch Staff';
  }

  bool get isStudent => student != null;
  bool get isTeacher => teacher != null;
  bool get isParent => parent != null;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rolesRaw = json['userRoles'] as List? ?? [];
    final roles = rolesRaw
        .map((r) => UserRoleItem.fromJson(r as Map<String, dynamic>))
        .toList();

    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      scope: json['scope'] as String? ?? 'BRANCH',
      organizationId: json['organizationId'] as String? ?? '',
      branchId: json['branchId'] as String?,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      organization: json['organization'] != null
          ? UserOrganizationInfo.fromJson(
              json['organization'] as Map<String, dynamic>)
          : null,
      branch: json['branch'] != null
          ? UserBranchInfo.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      roles: roles,
      student: json['student'] != null
          ? UserStudentInfo.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      teacher: json['teacher'] != null
          ? UserTeacherInfo.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      parent: json['parent'] != null
          ? UserParentInfo.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'avatar': avatar,
        'status': status,
        'scope': scope,
        'organizationId': organizationId,
        'branchId': branchId,
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'organization': organization?.toJson(),
        'branch': branch?.toJson(),
        'roles': roles.map((r) => r.toJson()).toList(),
        'student': student?.toJson(),
        'teacher': teacher?.toJson(),
        'parent': parent?.toJson(),
      };
}

/// Request payload for User Login.
class UserLoginRequest {
  final String email;
  final String password;
  final String? organizationId;
  final String? deviceId;
  final String? deviceType;
  final String? deviceName;

  const UserLoginRequest({
    required this.email,
    required this.password,
    this.organizationId,
    this.deviceId,
    this.deviceType,
    this.deviceName,
  });

  Map<String, dynamic> toJson() => {
        'email': email.trim().toLowerCase(),
        'password': password,
        if (organizationId != null && organizationId!.isNotEmpty)
          'organizationId': organizationId,
        if (deviceId != null) 'deviceId': deviceId,
        if (deviceType != null) 'deviceType': deviceType,
        if (deviceName != null) 'deviceName': deviceName,
      };
}

/// Response payload from successful User Login.
class UserLoginResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String sessionId;

  const UserLoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
    );
  }
}

/// Request payload for Refreshing Token.
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'refreshToken': refreshToken,
      };
}

/// Response payload from Token Refresh.
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String sessionId;

  const RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
    );
  }
}

/// Request payload for Updating Profile.
class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? phone;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName!.trim(),
        if (lastName != null) 'lastName': lastName!.trim(),
        if (phone != null) 'phone': phone!.trim(),
      };
}

/// Request payload for Updating Avatar.
class UpdateAvatarRequest {
  final String avatar;

  const UpdateAvatarRequest({required this.avatar});

  Map<String, dynamic> toJson() => {
        'avatar': avatar.trim(),
      };
}

/// Request payload for Changing Password.
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
}

/// Request payload for Requesting Password Reset.
class ForgotPasswordRequest {
  final String email;
  final String? organizationId;

  const ForgotPasswordRequest({
    required this.email,
    this.organizationId,
  });

  Map<String, dynamic> toJson() => {
        'email': email.trim().toLowerCase(),
        if (organizationId != null && organizationId!.isNotEmpty)
          'organizationId': organizationId,
      };
}

/// Response payload for Forgot Password.
class ForgotPasswordResponse {
  final String message;
  final String? resetToken;

  const ForgotPasswordResponse({
    required this.message,
    this.resetToken,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] as String? ?? '',
      resetToken: json['resetToken'] as String?,
    );
  }
}

/// Request payload for Resetting Password with Token.
class ResetPasswordRequest {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'token': token.trim(),
        'newPassword': newPassword,
      };
}

/// Model representing an active logged-in device session.
class DeviceSessionModel {
  final String id;
  final String? deviceId;
  final String deviceType;
  final String? deviceName;
  final String? browser;
  final String? browserVersion;
  final String? os;
  final String? osVersion;
  final String? ipAddress;
  final String? location;
  final DateTime? loginAt;
  final DateTime? lastActiveAt;
  final bool isCurrent;

  const DeviceSessionModel({
    required this.id,
    this.deviceId,
    this.deviceType = 'UNKNOWN',
    this.deviceName,
    this.browser,
    this.browserVersion,
    this.os,
    this.osVersion,
    this.ipAddress,
    this.location,
    this.loginAt,
    this.lastActiveAt,
    this.isCurrent = false,
  });

  factory DeviceSessionModel.fromJson(Map<String, dynamic> json) {
    return DeviceSessionModel(
      id: json['id'] as String? ?? '',
      deviceId: json['deviceId'] as String?,
      deviceType: json['deviceType'] as String? ?? 'UNKNOWN',
      deviceName: json['deviceName'] as String?,
      browser: json['browser'] as String?,
      browserVersion: json['browserVersion'] as String?,
      os: json['os'] as String?,
      osVersion: json['osVersion'] as String?,
      ipAddress: json['ipAddress'] as String?,
      location: json['location'] as String?,
      loginAt: json['loginAt'] != null
          ? DateTime.tryParse(json['loginAt'].toString())
          : null,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.tryParse(json['lastActiveAt'].toString())
          : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }
}

/// Model representing an immutable security/auth audit log item.
class AuditLogModel {
  final String id;
  final String action;
  final String? targetEntity;
  final String? ipAddress;
  final String? userAgent;
  final dynamic metadata;
  final DateTime? createdAt;

  const AuditLogModel({
    required this.id,
    required this.action,
    this.targetEntity,
    this.ipAddress,
    this.userAgent,
    this.metadata,
    this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      targetEntity: json['targetEntity'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      metadata: json['metadata'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

/// Paginated audit logs response.
class PaginatedAuditLogsResponse {
  final List<AuditLogModel> logs;
  final int total;
  final int page;
  final int totalPages;

  const PaginatedAuditLogsResponse({
    required this.logs,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory PaginatedAuditLogsResponse.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List? ?? [];
    final logs = rawLogs
        .map((l) => AuditLogModel.fromJson(l as Map<String, dynamic>))
        .toList();

    return PaginatedAuditLogsResponse(
      logs: logs,
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ==========================================================================
// 5. User Management Models & Payloads (/user/users/*)
// ==========================================================================

/// Parameters for listing users with filters.
class GetUsersParams {
  final int page;
  final int limit;
  final String? search;
  final String? scope;
  final String? branchId;
  final String? status;
  final String? roleId;

  const GetUsersParams({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.scope,
    this.branchId,
    this.status,
    this.roleId,
  });

  Map<String, dynamic> toQueryParameters() => {
        'page': page,
        'limit': limit,
        if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
        if (scope != null && scope!.isNotEmpty) 'scope': scope,
        if (branchId != null && branchId!.isNotEmpty) 'branchId': branchId,
        if (status != null && status!.isNotEmpty) 'status': status,
        if (roleId != null && roleId!.isNotEmpty) 'roleId': roleId,
      };
}

/// Paginated Users Response matching the backend /user/users response.
class PaginatedUsersResponse {
  final List<UserModel> data;
  final PaginationMeta meta;

  const PaginatedUsersResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedUsersResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List? ?? [];
    final users = rawData
        .map((u) => UserModel.fromJson(u as Map<String, dynamic>))
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final meta = PaginationMeta.fromJson(metaJson);

    return PaginatedUsersResponse(
      data: users,
      meta: meta,
    );
  }
}

/// Request payload to create a new user.
class CreateUserInput {
  final String email;
  final String password;
  final String firstName;
  final String? lastName;
  final String? phone;
  final String? scope;
  final String? branchId;
  final List<String>? roleIds;

  const CreateUserInput({
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName,
    this.phone,
    this.scope,
    this.branchId,
    this.roleIds,
  });

  Map<String, dynamic> toJson() => {
        'email': email.trim().toLowerCase(),
        'password': password,
        'firstName': firstName.trim(),
        if (lastName != null && lastName!.trim().isNotEmpty)
          'lastName': lastName!.trim(),
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        if (scope != null && scope!.isNotEmpty) 'scope': scope,
        if (branchId != null && branchId!.isNotEmpty) 'branchId': branchId,
        if (roleIds != null && roleIds!.isNotEmpty) 'roleIds': roleIds,
      };
}

/// Request payload to update user status (ACTIVE, INACTIVE, SUSPENDED, INVITED).
class UpdateUserStatusInput {
  final String status;

  const UpdateUserStatusInput({required this.status});

  Map<String, dynamic> toJson() => {'status': status};
}

/// Request payload to assign roles to a user.
class AssignRolesToUserInput {
  final List<String> roleIds;

  const AssignRolesToUserInput({required this.roleIds});

  Map<String, dynamic> toJson() => {'roleIds': roleIds};
}

// ==========================================================================
// 6. Role & Permission Models & Payloads (/user/roles/* & /user/permissions/*)
// ==========================================================================

/// Parameters for listing roles.
class GetRolesParams {
  final int page;
  final int limit;
  final String? search;
  final String? scope;
  final String? branchId;

  const GetRolesParams({
    this.page = 1,
    this.limit = 50,
    this.search,
    this.scope,
    this.branchId,
  });

  Map<String, dynamic> toQueryParameters() => {
        'page': page,
        'limit': limit,
        if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
        if (scope != null && scope!.isNotEmpty) 'scope': scope,
        if (branchId != null && branchId!.isNotEmpty) 'branchId': branchId,
      };
}

/// Paginated Roles Response matching backend /user/roles response.
class PaginatedRolesResponse {
  final List<UserRoleItem> data;
  final PaginationMeta meta;

  const PaginatedRolesResponse({
    required this.data,
    required this.meta,
  });

  factory PaginatedRolesResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List? ?? [];
    final roles = rawList
        .map((r) => UserRoleItem.fromJson(r as Map<String, dynamic>))
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final meta = PaginationMeta.fromJson(metaJson);

    return PaginatedRolesResponse(
      data: roles,
      meta: meta,
    );
  }
}

/// Request payload to create a custom role.
class CreateRoleInput {
  final String name;
  final String? description;
  final String? scope;
  final String? branchId;
  final List<String>? permissionKeys;

  const CreateRoleInput({
    required this.name,
    this.description,
    this.scope,
    this.branchId,
    this.permissionKeys,
  });

  Map<String, dynamic> toJson() => {
        'name': name.trim(),
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        if (scope != null && scope!.isNotEmpty) 'scope': scope,
        if (branchId != null && branchId!.isNotEmpty) 'branchId': branchId,
        if (permissionKeys != null && permissionKeys!.isNotEmpty)
          'permissionKeys': permissionKeys,
      };
}

/// Request payload to assign/sync permissions to a role.
class AssignPermissionsToRoleInput {
  final List<String> permissionKeys;

  const AssignPermissionsToRoleInput({required this.permissionKeys});

  Map<String, dynamic> toJson() => {'permissionKeys': permissionKeys};
}

/// Full System Permission entity from /user/permissions.
class SystemPermissionModel {
  final String id;
  final String key;
  final String name;
  final String module;
  final String action;
  final String? description;
  final bool isSystem;
  final List<String> allowedScopes;

  const SystemPermissionModel({
    required this.id,
    required this.key,
    required this.name,
    required this.module,
    required this.action,
    this.description,
    this.isSystem = true,
    this.allowedScopes = const ['ORGANIZATION', 'BRANCH'],
  });

  factory SystemPermissionModel.fromJson(Map<String, dynamic> json) {
    final rawScopes = json['allowedScopes'] as List? ?? [];
    return SystemPermissionModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? json['key'] as String? ?? '',
      module: json['module'] as String? ?? 'General',
      action: json['action'] as String? ?? 'ACCESS',
      description: json['description'] as String?,
      isSystem: json['isSystem'] as bool? ?? true,
      allowedScopes: rawScopes.map((s) => s.toString()).toList(),
    );
  }
}
