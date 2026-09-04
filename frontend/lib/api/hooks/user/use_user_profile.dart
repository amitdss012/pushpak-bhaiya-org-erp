import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Query hook to fetch the authenticated user profile with roles, permissions, and persona.
QuerySnapshot<UserModel, Object> useUserProfile({
  bool enabled = true,
}) {
  return useQuery(
    const ['user', 'profile'],
    (_) => UserRepo.getProfile(),
    enabled: enabled,
  );
}

/// Mutation hook to update user personal details (firstName, lastName, phone).
MutationSnapshot<UserModel, Object, UpdateProfileRequest> useUpdateProfile({
  void Function(UserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Profile updated successfully',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.updateProfile,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}

/// Mutation hook to update user avatar image URL.
MutationSnapshot<UserModel, Object, UpdateAvatarRequest> useUpdateAvatar({
  void Function(UserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Avatar updated successfully',
  bool showSuccessToast = true,
  bool showErrorToast = true,
}) {
  return useAppMutation(
    UserRepo.updateAvatar,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
    showSuccessToast: showSuccessToast,
    showErrorToast: showErrorToast,
  );
}
