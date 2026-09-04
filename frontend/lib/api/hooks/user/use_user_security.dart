import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Mutation hook to change password for authenticated user.
MutationSnapshot<void, Object, ChangePasswordRequest> useChangePassword({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Password changed successfully',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.changePassword,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook to request password reset token.
MutationSnapshot<ForgotPasswordResponse, Object, ForgotPasswordRequest>
    useForgotPassword({
  void Function(ForgotPasswordResponse data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Password reset request submitted',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.forgotPassword,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook to reset password using token.
MutationSnapshot<void, Object, ResetPasswordRequest> useResetPassword({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Password reset successfully. Please log in.',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.resetPassword,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}
