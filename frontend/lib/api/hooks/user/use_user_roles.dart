import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Query hook to fetch paginated roles.
QuerySnapshot<PaginatedRolesResponse, Object> useRolesQuery({
  GetRolesParams params = const GetRolesParams(),
  bool enabled = true,
}) {
  return useQuery(
    [
      'user',
      'roles',
      params.page,
      params.limit,
      params.search,
      params.scope,
      params.branchId,
    ],
    (_) => UserRepo.getRoles(params),
    enabled: enabled,
  );
}

/// Query hook to fetch role details by ID.
QuerySnapshot<UserRoleItem, Object> useRoleQuery(
  String roleId, {
  bool enabled = true,
}) {
  return useQuery(
    ['user', 'roles', roleId],
    (_) => UserRepo.getRoleById(roleId),
    enabled: enabled && roleId.isNotEmpty,
  );
}

/// Mutation hook to create a custom role.
MutationSnapshot<UserRoleItem, Object, CreateRoleInput> useCreateRoleMutation({
  void Function(UserRoleItem data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Role created successfully',
}) {
  return useAppMutation(
    UserRepo.createRole,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for assigning permissions to a role.
class AssignPermissionsToRoleParams {
  final String roleId;
  final AssignPermissionsToRoleInput data;

  const AssignPermissionsToRoleParams({
    required this.roleId,
    required this.data,
  });
}

/// Mutation hook to assign/sync permissions to a role.
MutationSnapshot<UserRoleItem, Object, AssignPermissionsToRoleParams>
    useAssignPermissionsToRoleMutation({
  void Function(UserRoleItem data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Permissions updated successfully',
}) {
  return useAppMutation(
    (params) => UserRepo.assignPermissionsToRole(params.roleId, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
