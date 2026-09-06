import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Query hook to fetch paginated users with filters.
QuerySnapshot<PaginatedUsersResponse, Object> useUsersQuery({
  GetUsersParams params = const GetUsersParams(),
  bool enabled = true,
}) {
  return useQuery(
    [
      'user',
      'users',
      params.page,
      params.limit,
      params.search,
      params.scope,
      params.branchId,
      params.status,
      params.roleId,
    ],
    (_) => UserRepo.getUsers(params),
    enabled: enabled,
  );
}

/// Query hook to fetch single user by ID.
QuerySnapshot<UserModel, Object> useUserQuery(
  String userId, {
  bool enabled = true,
}) {
  return useQuery(
    ['user', 'users', userId],
    (_) => UserRepo.getUserById(userId),
    enabled: enabled && userId.isNotEmpty,
  );
}

/// Mutation hook to create a new user.
MutationSnapshot<UserModel, Object, CreateUserInput> useCreateUserMutation({
  void Function(UserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'User created successfully',
}) {
  return useAppMutation(
    UserRepo.createUser,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating user status.
class UpdateUserStatusParams {
  final String userId;
  final UpdateUserStatusInput data;

  const UpdateUserStatusParams({
    required this.userId,
    required this.data,
  });
}

/// Mutation hook to update user lifecycle status (ACTIVE, INACTIVE, SUSPENDED).
MutationSnapshot<UserModel, Object, UpdateUserStatusParams>
    useUpdateUserStatusMutation({
  void Function(UserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'User status updated successfully',
}) {
  return useAppMutation(
    (params) => UserRepo.updateUserStatus(params.userId, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for assigning roles to a user.
class AssignRolesToUserParams {
  final String userId;
  final AssignRolesToUserInput data;

  const AssignRolesToUserParams({
    required this.userId,
    required this.data,
  });
}

/// Mutation hook to assign/sync roles to a user.
MutationSnapshot<UserModel, Object, AssignRolesToUserParams>
    useAssignRolesToUserMutation({
  void Function(UserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Roles assigned successfully',
}) {
  return useAppMutation(
    (params) => UserRepo.assignRolesToUser(params.userId, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
