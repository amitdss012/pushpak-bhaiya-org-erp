import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/organization/org_rbac_repo.dart';

/* ==========================================================================
   1. User Query & Mutation Hooks
   ========================================================================== */

/// Query hook to fetch users for the organization with search/filters.
QuerySnapshot<List<OrgUserModel>, Object> useOrgUsersQuery({
  String? search,
  String? role,
  String? department,
  String? status,
  bool enabled = true,
}) {
  return useQuery(
    ['org', 'users', search, role, department, status],
    (_) => OrgRbacRepo.getUsers(
      search: search,
      role: role,
      department: department,
      status: status,
    ),
    enabled: enabled,
  );
}

/// Mutation hook to create a new organization user.
MutationSnapshot<OrgUserModel, Object, CreateOrgUserRequest>
    useCreateOrgUserMutation({
  void Function(OrgUserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'User created successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.createUser,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating a user.
class UpdateOrgUserParams {
  final String id;
  final UpdateOrgUserRequest data;

  const UpdateOrgUserParams({
    required this.id,
    required this.data,
  });
}

/// Mutation hook to update an existing user.
MutationSnapshot<OrgUserModel, Object, UpdateOrgUserParams>
    useUpdateOrgUserMutation({
  void Function(OrgUserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'User updated successfully',
}) {
  return useAppMutation(
    (params) => OrgRbacRepo.updateUser(params.id, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Mutation hook to assign roles to a user.
MutationSnapshot<OrgUserModel, Object, AssignUserRolesRequest>
    useAssignUserRolesMutation({
  void Function(OrgUserModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Roles assigned successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.assignRolesToUser,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for resetting user password.
class ResetUserPasswordParams {
  final String userId;
  final String newPassword;

  const ResetUserPasswordParams({
    required this.userId,
    required this.newPassword,
  });
}

/// Mutation hook to reset user password.
MutationSnapshot<void, Object, ResetUserPasswordParams>
    useResetUserPasswordMutation({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Password reset successfully',
}) {
  return useAppMutation(
    (params) => OrgRbacRepo.resetPassword(params.userId, params.newPassword),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Mutation hook to delete a user.
MutationSnapshot<void, Object, String> useDeleteOrgUserMutation({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'User deleted successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.deleteUser,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/* ==========================================================================
   2. Role Query & Mutation Hooks
   ========================================================================== */

/// Query hook to fetch all organization roles.
QuerySnapshot<List<OrgRoleModel>, Object> useOrgRolesQuery({
  String? scope,
  bool enabled = true,
}) {
  return useQuery(
    ['org', 'roles', scope],
    (_) => OrgRbacRepo.getRoles(scope: scope),
    enabled: enabled,
  );
}

/// Query hook to fetch a single role by ID with permissions.
QuerySnapshot<OrgRoleModel, Object> useOrgRoleQuery(
  String roleId, {
  bool enabled = true,
}) {
  return useQuery(
    ['org', 'role', roleId],
    (_) => OrgRbacRepo.getRoleById(roleId),
    enabled: enabled && roleId.isNotEmpty,
  );
}

/// Mutation hook to create a custom role.
MutationSnapshot<OrgRoleModel, Object, CreateOrgRoleRequest>
    useCreateOrgRoleMutation({
  void Function(OrgRoleModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Role created successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.createRole,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating a role.
class UpdateOrgRoleParams {
  final String id;
  final UpdateOrgRoleRequest data;

  const UpdateOrgRoleParams({
    required this.id,
    required this.data,
  });
}

/// Mutation hook to update an existing role.
MutationSnapshot<OrgRoleModel, Object, UpdateOrgRoleParams>
    useUpdateOrgRoleMutation({
  void Function(OrgRoleModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Role updated successfully',
}) {
  return useAppMutation(
    (params) => OrgRbacRepo.updateRole(params.id, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Mutation hook to delete a role.
MutationSnapshot<void, Object, String> useDeleteOrgRoleMutation({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Role deleted successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.deleteRole,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/* ==========================================================================
   3. Permission Query & Mutation Hooks
   ========================================================================== */

/// Query hook to fetch all permission definitions categorized by module.
QuerySnapshot<List<OrgPermissionCategory>, Object> useOrgPermissionsQuery({
  bool enabled = true,
}) {
  return useQuery(
    ['org', 'permissions'],
    (_) => OrgRbacRepo.getAllPermissions(),
    enabled: enabled,
  );
}

/// Mutation hook to update permissions assigned to a role.
MutationSnapshot<OrgRoleModel, Object, UpdateRolePermissionsRequest>
    useUpdateRolePermissionsMutation({
  void Function(OrgRoleModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Permissions updated successfully',
}) {
  return useAppMutation(
    OrgRbacRepo.updateRolePermissions,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
