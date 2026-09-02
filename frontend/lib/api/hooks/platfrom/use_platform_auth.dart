import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/platfrom/platform_auth_repo.dart';

/// Mutation hook for platform admin login.
MutationSnapshot<PlatformLoginResponse, Object, PlatformLoginRequest>
    usePlatformLogin({
  void Function(PlatformLoginResponse data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Login successful',
}) {
  return useAppMutation(
    PlatformAuthRepo.login,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Query hook to fetch the authenticated platform admin profile.
QuerySnapshot<PlatformAdminModel, Object> usePlatformProfile({
  bool enabled = true,
}) {
  return useQuery(
    const ['platform', 'profile'],
    (_) => PlatformAuthRepo.getProfile(),
    enabled: enabled,
  );
}

/// Mutation hook for platform admin logout.
MutationSnapshot<void, Object, void> usePlatformLogout({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Logged out successfully',
}) {
  return useAppMutation(
    (_) => PlatformAuthRepo.logout(),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
