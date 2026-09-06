import '../pagination_model.dart';

/// Creator summary attached to an academic session or branch mapping.
class SessionCreatorInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  const SessionCreatorInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory SessionCreatorInfo.fromJson(Map<String, dynamic> json) {
    return SessionCreatorInfo(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}

/// Branch summary in session mappings.
class SessionBranchInfo {
  final String id;
  final String name;
  final String slug;
  final String? code;

  const SessionBranchInfo({
    required this.id,
    required this.name,
    required this.slug,
    this.code,
  });

  factory SessionBranchInfo.fromJson(Map<String, dynamic> json) {
    return SessionBranchInfo(
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

/// Branch mapping for an Academic Session.
class BranchAcademicSessionModel {
  final String id;
  final String academicSessionId;
  final String branchId;
  final SessionBranchInfo? branch;
  final bool isCurrent;
  final String? createdById;
  final SessionCreatorInfo? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BranchAcademicSessionModel({
    required this.id,
    required this.academicSessionId,
    required this.branchId,
    this.branch,
    required this.isCurrent,
    this.createdById,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchAcademicSessionModel.fromJson(Map<String, dynamic> json) {
    return BranchAcademicSessionModel(
      id: json['id'] as String? ?? '',
      academicSessionId: json['academicSessionId'] as String? ?? '',
      branchId: json['branchId'] as String? ?? '',
      branch: json['branch'] != null && json['branch'] is Map<String, dynamic>
          ? SessionBranchInfo.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      isCurrent: json['isCurrent'] as bool? ?? false,
      createdById: json['createdById'] as String?,
      createdBy: json['createdBy'] != null &&
              json['createdBy'] is Map<String, dynamic>
          ? SessionCreatorInfo.fromJson(
              json['createdBy'] as Map<String, dynamic>)
          : null,
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
        'academicSessionId': academicSessionId,
        'branchId': branchId,
        'branch': branch?.toJson(),
        'isCurrent': isCurrent,
        'createdById': createdById,
        'createdBy': createdBy?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

/// Master Academic Session model.
class AcademicSessionModel {
  final String id;
  final String organizationId;
  final String name;
  final String? code;
  final int startYear;
  final int endYear;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? createdById;
  final SessionCreatorInfo? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BranchAcademicSessionModel> branchMappings;

  const AcademicSessionModel({
    required this.id,
    required this.organizationId,
    required this.name,
    this.code,
    required this.startYear,
    required this.endYear,
    required this.startDate,
    required this.endDate,
    this.description,
    this.createdById,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.branchMappings = const [],
  });

  bool isCurrentForBranch(String branchId) {
    final mapping = branchMappings.where((m) => m.branchId == branchId);
    if (mapping.isEmpty) return false;
    return mapping.first.isCurrent;
  }

  String get formattedYears => '$startYear - $endYear';

  factory AcademicSessionModel.fromJson(Map<String, dynamic> json) {
    return AcademicSessionModel(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String?,
      startYear: (json['startYear'] as num?)?.toInt() ?? 0,
      endYear: (json['endYear'] as num?)?.toInt() ?? 0,
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      endDate: DateTime.tryParse(json['endDate']?.toString() ?? '') ??
          DateTime.now(),
      description: json['description'] as String?,
      createdById: json['createdById'] as String?,
      createdBy: json['createdBy'] != null &&
              json['createdBy'] is Map<String, dynamic>
          ? SessionCreatorInfo.fromJson(
              json['createdBy'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      branchMappings: json['branchMappings'] != null &&
              json['branchMappings'] is List
          ? (json['branchMappings'] as List)
              .map((m) =>
                  BranchAcademicSessionModel.fromJson(m as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'name': name,
        'code': code,
        'startYear': startYear,
        'endYear': endYear,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'description': description,
        'createdById': createdById,
        'createdBy': createdBy?.toJson(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'branchMappings': branchMappings.map((m) => m.toJson()).toList(),
      };
}

/// Input for creating master session and optionally mapping branches.
class CreateSessionInput {
  final String name;
  final String? code;
  final int startYear;
  final int endYear;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final List<String> branchIds;
  final bool isCurrentForBranches;

  const CreateSessionInput({
    required this.name,
    this.code,
    required this.startYear,
    required this.endYear,
    required this.startDate,
    required this.endDate,
    this.description,
    this.branchIds = const [],
    this.isCurrentForBranches = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (code != null) 'code': code,
        'startYear': startYear,
        'endYear': endYear,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        if (description != null) 'description': description,
        'branchIds': branchIds,
        'isCurrentForBranches': isCurrentForBranches,
      };
}

/// Input for updating master session details.
class UpdateSessionInput {
  final String? name;
  final String? code;
  final int? startYear;
  final int? endYear;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;

  const UpdateSessionInput({
    this.name,
    this.code,
    this.startYear,
    this.endYear,
    this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (code != null) 'code': code,
        if (startYear != null) 'startYear': startYear,
        if (endYear != null) 'endYear': endYear,
        if (startDate != null) 'startDate': startDate!.toIso8601String(),
        if (endDate != null) 'endDate': endDate!.toIso8601String(),
        if (description != null) 'description': description,
      };
}

/// Query parameters for fetching sessions.
class GetSessionsParams {
  final int page;
  final int limit;
  final String? search;
  final String? branchId;

  const GetSessionsParams({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.branchId,
  });

  Map<String, dynamic> toQueryParams() => {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search!.isNotEmpty) 'search': search,
        if (branchId != null && branchId!.isNotEmpty) 'branchId': branchId,
      };
}

/// Paginated sessions response wrapper.
class PaginatedSessionsResponse {
  final List<AcademicSessionModel> sessions;
  final PaginationMeta meta;

  const PaginatedSessionsResponse({
    required this.sessions,
    required this.meta,
  });

  factory PaginatedSessionsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['sessions'] as List<dynamic>?)
            ?.map((e) =>
                AcademicSessionModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    return PaginatedSessionsResponse(
      sessions: list,
      meta: PaginationMeta.fromJson(metaJson),
    );
  }
}
