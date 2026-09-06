import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/session/session_repo.dart';

/// Query hook to fetch paginated academic sessions.
QuerySnapshot<PaginatedSessionsResponse, Object> useSessionsQuery({
  GetSessionsParams params = const GetSessionsParams(),
  bool enabled = true,
}) {
  return useQuery(
    [
      'session',
      'sessions',
      params.page,
      params.limit,
      params.search,
      params.branchId,
    ],
    (_) => SessionRepo.getSessions(params: params),
    enabled: enabled,
  );
}

/// Query hook to fetch single academic session by ID.
QuerySnapshot<AcademicSessionModel, Object> useSessionQuery(
  String sessionId, {
  bool enabled = true,
}) {
  return useQuery(
    ['session', 'sessions', sessionId],
    (_) => SessionRepo.getSessionById(sessionId),
    enabled: enabled && sessionId.isNotEmpty,
  );
}

/// Query hook to fetch active academic session for branch.
QuerySnapshot<BranchAcademicSessionModel?, Object> useCurrentSessionQuery({
  String? branchId,
  bool enabled = true,
}) {
  return useQuery(
    ['session', 'current', branchId],
    (_) => SessionRepo.getCurrentSession(branchId: branchId),
    enabled: enabled,
  );
}

/// Mutation hook to create master academic session and map branches.
MutationSnapshot<AcademicSessionModel, Object, CreateSessionInput>
    useCreateSessionMutation({
  void Function(AcademicSessionModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Academic session created successfully',
}) {
  return useAppMutation(
    SessionRepo.createSession,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating master session metadata.
class UpdateSessionParams {
  final String sessionId;
  final UpdateSessionInput data;

  const UpdateSessionParams({
    required this.sessionId,
    required this.data,
  });
}

/// Mutation hook to update master academic session.
MutationSnapshot<AcademicSessionModel, Object, UpdateSessionParams>
    useUpdateSessionMutation({
  void Function(AcademicSessionModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Academic session updated successfully',
}) {
  return useAppMutation(
    (params) => SessionRepo.updateSession(params.sessionId, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for mapping branches to session.
class MapBranchesParams {
  final String sessionId;
  final List<String> branchIds;
  final bool isCurrent;

  const MapBranchesParams({
    required this.sessionId,
    required this.branchIds,
    this.isCurrent = false,
  });
}

/// Mutation hook to map branches to session.
MutationSnapshot<AcademicSessionModel, Object, MapBranchesParams>
    useMapBranchesMutation({
  void Function(AcademicSessionModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Branches mapped successfully',
}) {
  return useAppMutation(
    (params) => SessionRepo.mapBranches(
      sessionId: params.sessionId,
      branchIds: params.branchIds,
      isCurrent: params.isCurrent,
    ),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for setting active session for a branch.
class SetBranchCurrentSessionParams {
  final String branchId;
  final String branchAcademicSessionId;

  const SetBranchCurrentSessionParams({
    required this.branchId,
    required this.branchAcademicSessionId,
  });
}

/// Mutation hook to set branch's active academic session.
MutationSnapshot<BranchAcademicSessionModel, Object,
    SetBranchCurrentSessionParams> useSetBranchCurrentSessionMutation({
  void Function(BranchAcademicSessionModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Branch active session updated',
}) {
  return useAppMutation(
    (params) => SessionRepo.setBranchCurrentSession(
      branchId: params.branchId,
      branchAcademicSessionId: params.branchAcademicSessionId,
    ),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Mutation hook to delete master academic session.
MutationSnapshot<void, Object, String> useDeleteSessionMutation({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Academic session deleted successfully',
}) {
  return useAppMutation(
    SessionRepo.deleteSession,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
