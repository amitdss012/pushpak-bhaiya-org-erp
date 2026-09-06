import '../pagination_model.dart';

/// Single permission assigned to a role or available in the system.
class OrgPermissionItem {
  final String id;
  final String key;
  final String name;
  final String module;
  final String? description;
  final bool isDefault;
  final bool isLocked;

  const OrgPermissionItem({
    required this.id,
    required this.key,
    required this.name,
    required this.module,
    this.description,
    this.isDefault = false,
    this.isLocked = false,
  });

  factory OrgPermissionItem.fromJson(Map<String, dynamic> json) {
    return OrgPermissionItem(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['label'] as String? ?? '',
      module: json['module'] as String? ?? 'General',
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? json['locked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'module': module,
        'description': description,
        'isDefault': isDefault,
        'isLocked': isLocked,
      };
}

/// Category/Module containing grouped permissions for the Access Control Matrix.
class OrgPermissionCategory {
  final String id;
  final String name;
  final String description;
  final List<OrgPermissionItem> permissions;

  const OrgPermissionCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory OrgPermissionCategory.fromJson(Map<String, dynamic> json) {
    final rawPerms = json['permissions'] as List? ?? [];
    return OrgPermissionCategory(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      permissions: rawPerms
          .map((p) => OrgPermissionItem.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'permissions': permissions.map((p) => p.toJson()).toList(),
      };
}

/// Organization Role model.
class OrgRoleModel {
  final String id;
  final String name;
  final String slug;
  final String scope;
  final String? description;
  final bool isDefault;
  final bool isSystem;
  final int userCount;
  final List<String> permissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgRoleModel({
    required this.id,
    required this.name,
    required this.slug,
    this.scope = 'ORGANIZATION',
    this.description,
    this.isDefault = false,
    this.isSystem = false,
    this.userCount = 0,
    this.permissions = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory OrgRoleModel.fromJson(Map<String, dynamic> json) {
    List<String> perms = [];
    if (json['permissions'] is List && (json['permissions'] as List).isNotEmpty) {
      perms = (json['permissions'] as List)
          .map((e) => e is Map ? (e['key'] ?? e['id'] ?? '') : e.toString())
          .where((e) => e.isNotEmpty)
          .cast<String>()
          .toList();
    } else if (json['rolePermissions'] is List) {
      perms = (json['rolePermissions'] as List)
          .map((e) {
            if (e is Map) {
              if (e['permission'] is Map) {
                return (e['permission']['key'] ?? e['permission']['id'] ?? '').toString();
              }
              return (e['key'] ?? e['permissionKey'] ?? e['permissionId'] ?? e['id'] ?? '').toString();
            }
            return e.toString();
          })
          .where((e) => e.isNotEmpty)
          .cast<String>()
          .toList();
    }

    return OrgRoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['roleName'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      scope: json['scope'] as String? ?? 'ORGANIZATION',
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isSystem: json['isSystem'] as bool? ?? false,
      userCount: json['userCount'] as int? ?? json['_count']?['users'] as int? ?? 0,
      permissions: perms,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'scope': scope,
        'description': description,
        'isDefault': isDefault,
        'isSystem': isSystem,
        'userCount': userCount,
        'permissions': permissions,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

/// Organization User representation.
class OrgUserModel {
  final String id;
  final String userId;
  final String firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? avatar;
  final String department;
  final String status;
  final String scope;
  final String? branchId;
  final String? branchName;
  final List<OrgRoleModel> roles;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrgUserModel({
    required this.id,
    required this.userId,
    required this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.avatar,
    this.department = 'General',
    this.status = 'ACTIVE',
    this.scope = 'ORGANIZATION',
    this.branchId,
    this.branchName,
    this.roles = const [],
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
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
    return 'Staff Member';
  }

  factory OrgUserModel.fromJson(Map<String, dynamic> json) {
    List<OrgRoleModel> parsedRoles = [];
    if (json['roles'] is List) {
      parsedRoles = (json['roles'] as List)
          .map((r) => r is Map<String, dynamic>
              ? OrgRoleModel.fromJson(r)
              : OrgRoleModel(id: r.toString(), name: r.toString(), slug: r.toString()))
          .toList();
    } else if (json['role'] is String && (json['role'] as String).isNotEmpty) {
      final roleStr = json['role'] as String;
      parsedRoles = [OrgRoleModel(id: roleStr, name: roleStr, slug: roleStr.toLowerCase())];
    }

    return OrgUserModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? json['name']?.toString().split(' ').first ?? '',
      lastName: json['lastName'] as String? ??
          (json['name'] != null && json['name'].toString().contains(' ')
              ? json['name'].toString().split(' ').sublist(1).join(' ')
              : null),
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      department: json['department'] as String? ?? 'General',
      status: (json['status'] as String? ?? 'ACTIVE').toUpperCase(),
      scope: json['scope'] as String? ?? 'ORGANIZATION',
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String? ?? json['branch']?['name'] as String?,
      roles: parsedRoles,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'].toString())
          : (json['lastLogin'] != null ? DateTime.tryParse(json['lastLogin'].toString()) : null),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : (json['createdDate'] != null ? DateTime.tryParse(json['createdDate'].toString()) : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'department': department,
        'status': status,
        'scope': scope,
        'branchId': branchId,
        'branchName': branchName,
        'roles': roles.map((r) => r.toJson()).toList(),
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

/// Request payload to create an Organization User.
class CreateOrgUserRequest {
  final String firstName;
  final String? lastName;
  final String email;
  final String password;
  final String? phone;
  final String? department;
  final String? branchId;
  final String status;
  final List<String> roleIds;
  final bool sendWelcomeEmail;

  const CreateOrgUserRequest({
    required this.firstName,
    this.lastName,
    required this.email,
    required this.password,
    this.phone,
    this.department,
    this.branchId,
    this.status = 'ACTIVE',
    this.roleIds = const [],
    this.sendWelcomeEmail = true,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName.trim(),
        if (lastName != null && lastName!.trim().isNotEmpty)
          'lastName': lastName!.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        if (department != null && department!.trim().isNotEmpty)
          'department': department!.trim(),
        if (branchId != null && branchId!.trim().isNotEmpty)
          'branchId': branchId!.trim(),
        'status': status,
        'roleIds': roleIds,
        'sendWelcomeEmail': sendWelcomeEmail,
      };
}

/// Request payload to update an Organization User.
class UpdateOrgUserRequest {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? department;
  final String? branchId;
  final String? status;
  final List<String>? roleIds;

  const UpdateOrgUserRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.department,
    this.branchId,
    this.status,
    this.roleIds,
  });

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName!.trim(),
        if (lastName != null) 'lastName': lastName!.trim(),
        if (email != null) 'email': email!.trim().toLowerCase(),
        if (phone != null) 'phone': phone!.trim(),
        if (department != null) 'department': department!.trim(),
        if (branchId != null) 'branchId': branchId!.trim(),
        if (status != null) 'status': status,
        if (roleIds != null) 'roleIds': roleIds,
      };
}

/// Request payload to assign roles to a user.
class AssignUserRolesRequest {
  final String userId;
  final List<String> roleIds;
  final String? primaryRoleId;

  const AssignUserRolesRequest({
    required this.userId,
    required this.roleIds,
    this.primaryRoleId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'roleIds': roleIds,
        if (primaryRoleId != null) 'primaryRoleId': primaryRoleId,
      };
}

/// Request payload to create a custom Role.
class CreateOrgRoleRequest {
  final String name;
  final String? slug;
  final String scope;
  final String? description;
  final bool isDefault;
  final List<String> permissions;

  const CreateOrgRoleRequest({
    required this.name,
    this.slug,
    this.scope = 'ORGANIZATION',
    this.description,
    this.isDefault = false,
    this.permissions = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name.trim(),
        'slug': (slug != null && slug!.trim().isNotEmpty)
            ? slug!.trim().toLowerCase()
            : name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_'),
        'scope': scope,
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        'isDefault': isDefault,
        'permissionKeys': permissions,
        'permissions': permissions,
      };
}

/// Request payload to update a Role.
class UpdateOrgRoleRequest {
  final String? name;
  final String? description;
  final String? scope;
  final bool? isDefault;
  final List<String>? permissions;

  const UpdateOrgRoleRequest({
    this.name,
    this.description,
    this.scope,
    this.isDefault,
    this.permissions,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name!.trim(),
        if (description != null) 'description': description!.trim(),
        if (scope != null) 'scope': scope,
        if (isDefault != null) 'isDefault': isDefault,
        if (permissions != null) 'permissionKeys': permissions,
        if (permissions != null) 'permissions': permissions,
      };
}

/// Request payload to update permissions assigned to a role.
class UpdateRolePermissionsRequest {
  final String roleId;
  final List<String> permissions;

  const UpdateRolePermissionsRequest({
    required this.roleId,
    required this.permissions,
  });

  Map<String, dynamic> toJson() => {
        'roleId': roleId,
        'permissionKeys': permissions,
        'permissions': permissions,
      };
}

/// Paginated Users Response.
class PaginatedOrgUsersResponse {
  final List<OrgUserModel> users;
  final PaginationMeta meta;

  const PaginatedOrgUsersResponse({
    required this.users,
    required this.meta,
  });

  factory PaginatedOrgUsersResponse.fromJson(Map<String, dynamic> json) {
    final rawUsers = json['users'] as List? ?? json['data'] as List? ?? [];
    final users = rawUsers
        .map((u) => OrgUserModel.fromJson(u as Map<String, dynamic>))
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final meta = PaginationMeta.fromJson(metaJson);

    return PaginatedOrgUsersResponse(
      users: users,
      meta: meta,
    );
  }
}
