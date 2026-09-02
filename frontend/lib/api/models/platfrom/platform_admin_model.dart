/// Platform administrator user entity.
class PlatformAdminModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final DateTime? emailVerifiedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlatformAdminModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.isActive = true,
    this.emailVerifiedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PlatformAdminModel.fromJson(Map<String, dynamic> json) {
    return PlatformAdminModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      emailVerifiedAt: json['emailVerifiedAt'] != null
          ? DateTime.tryParse(json['emailVerifiedAt'].toString())
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'isActive': isActive,
      'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

/// Request payload for Platform Admin Login.
class PlatformLoginRequest {
  final String email;
  final String password;

  const PlatformLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim().toLowerCase(),
      'password': password,
    };
  }
}

/// Response payload returned upon successful Platform Admin Login.
class PlatformLoginResponse {
  final PlatformAdminModel admin;
  final String token;

  const PlatformLoginResponse({
    required this.admin,
    required this.token,
  });

  factory PlatformLoginResponse.fromJson(Map<String, dynamic> json) {
    return PlatformLoginResponse(
      admin: PlatformAdminModel.fromJson(
        json['admin'] as Map<String, dynamic>? ?? {},
      ),
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin': admin.toJson(),
      'token': token,
    };
  }
}
