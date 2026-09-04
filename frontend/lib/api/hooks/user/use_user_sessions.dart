import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Query hook to fetch all active device sessions for authenticated user.
QuerySnapshot<List<DeviceSessionModel>, Object> useUserSessions({
  bool enabled = true,
}) {
  return useQuery(
    const ['user', 'sessions'],
    (_) => UserRepo.getSessions(),
    enabled: enabled,
  );
}

/// Mutation hook to remotely terminate a specific device session.
MutationSnapshot<void, Object, String> useRevokeSession({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Device session terminated',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    (sessionId) => UserRepo.revokeSession(sessionId),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Query hook to fetch paginated security & login audit logs for user.
QuerySnapshot<PaginatedAuditLogsResponse, Object> useUserActivityLogs({
  int page = 1,
  int limit = 20,
  bool enabled = true,
}) {
  return useQuery(
    ['user', 'activity-logs', page, limit],
    (_) => UserRepo.getActivityLogs(page: page, limit: limit),
    enabled: enabled,
  );
}
