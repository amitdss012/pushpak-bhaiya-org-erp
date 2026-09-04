import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Mutation hook for user login with credentials.
MutationSnapshot<UserLoginResponse, Object, UserLoginRequest> useUserLogin({
  void Function(UserLoginResponse data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Login successful',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.login,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook for refreshing JWT access & refresh tokens.
MutationSnapshot<RefreshTokenResponse, Object, RefreshTokenRequest>
useUserRefreshToken({
  void Function(RefreshTokenResponse data)? onSuccess,
  void Function(Object error)? onError,
  bool showSuccessToast = false,
  bool showErrorToast = false,
}) {
  return useAppMutation(
    UserRepo.refreshToken,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook for terminating current device session.
MutationSnapshot<void, Object, void> useUserLogout({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Logged out successfully',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    (_) => UserRepo.logout(),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook for terminating all active device sessions for user.
MutationSnapshot<void, Object, void> useUserLogoutAll({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'All device sessions terminated',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    (_) => UserRepo.logoutAll(),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}
