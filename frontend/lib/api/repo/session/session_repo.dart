import '../../api_client.dart';
import '../../models/models.dart';

/// Repository handling all Academic Session REST API calls.
class SessionRepo {
  SessionRepo._();

  /// List paginated academic sessions.
  static Future<PaginatedSessionsResponse> getSessions({
    GetSessionsParams params = const GetSessionsParams(),
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/session',
      queryParameters: params.toQueryParams(),
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return PaginatedSessionsResponse.fromJson(rawData);
  }

  /// Get master academic session details by ID.
  static Future<AcademicSessionModel> getSessionById(String id) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/session/$id',
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AcademicSessionModel.fromJson(rawData);
  }

  /// Get active academic session for branch.
  static Future<BranchAcademicSessionModel?> getCurrentSession({
    String? branchId,
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/session/current',
      queryParameters: {
        if (branchId != null && branchId.isNotEmpty) 'branchId': branchId,
      },
    );

    final rawData = response.data?['data'] as Map<String, dynamic>?;
    if (rawData == null) return null;
    return BranchAcademicSessionModel.fromJson(rawData);
  }

  /// Create new master academic session and map to branches.
  static Future<AcademicSessionModel> createSession(
    CreateSessionInput input,
  ) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/session',
      data: input.toJson(),
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AcademicSessionModel.fromJson(rawData);
  }

  /// Update master academic session metadata.
  static Future<AcademicSessionModel> updateSession(
    String id,
    UpdateSessionInput input,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/session/$id',
      data: input.toJson(),
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AcademicSessionModel.fromJson(rawData);
  }

  /// Map branches to an academic session.
  static Future<AcademicSessionModel> mapBranches({
    required String sessionId,
    required List<String> branchIds,
    bool isCurrent = false,
  }) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/session/$sessionId/branches',
      data: {
        'branchIds': branchIds,
        'isCurrent': isCurrent,
      },
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AcademicSessionModel.fromJson(rawData);
  }

  /// Set the current/active academic session for a branch.
  static Future<BranchAcademicSessionModel> setBranchCurrentSession({
    required String branchId,
    required String branchAcademicSessionId,
  }) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/session/set-current',
      data: {
        'branchId': branchId,
        'branchAcademicSessionId': branchAcademicSessionId,
      },
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return BranchAcademicSessionModel.fromJson(rawData);
  }

  /// Soft-delete an academic session.
  static Future<void> deleteSession(String id) async {
    await ApiClient().delete<Map<String, dynamic>>(
      '/session/$id',
    );
  }
}
