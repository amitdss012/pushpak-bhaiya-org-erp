import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/platfrom/organizations_repo.dart';

/// Query hook to fetch paginated organizations with search & status filters.
QuerySnapshot<PaginatedOrganizationsResponse, Object> useOrganizationsQuery({
  GetOrganizationsParams params = const GetOrganizationsParams(),
  bool enabled = true,
}) {
  return useQuery(
    [
      'platform',
      'organizations',
      params.page,
      params.limit,
      params.search,
      params.status,
      params.planId,
      params.sortBy,
      params.sortOrder,
    ],
    (_) => OrganizationsRepo.getOrganizations(params),
    enabled: enabled,
  );
}

/// Query hook to fetch detailed organization profile by ID.
QuerySnapshot<OrganizationDetailModel, Object> useOrganizationQuery(
  String id, {
  bool enabled = true,
}) {
  return useQuery(
    ['platform', 'organizations', id],
    (_) => OrganizationsRepo.getOrganizationById(id),
    enabled: enabled && id.isNotEmpty,
  );
}

/// Mutation hook to onboard a new organization with plan & owner user.
MutationSnapshot<OnboardOrganizationResponse, Object,
        OnboardOrganizationRequest>
    useOnboardOrganizationMutation({
  void Function(OnboardOrganizationResponse data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Organization onboarded successfully',
}) {
  return useAppMutation(
    OrganizationsRepo.onboardOrganization,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating organization profile.
class UpdateOrganizationParams {
  final String id;
  final UpdateOrganizationRequest data;

  const UpdateOrganizationParams({
    required this.id,
    required this.data,
  });
}

/// Mutation hook to update organization profile and status.
MutationSnapshot<Map<String, dynamic>, Object, UpdateOrganizationParams>
    useUpdateOrganizationMutation({
  void Function(Map<String, dynamic> data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Organization updated successfully',
}) {
  return useAppMutation(
    (params) =>
        OrganizationsRepo.updateOrganization(params.id, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating organization subscription plan & status.
class UpdateOrgSubscriptionParams {
  final String id;
  final UpdateOrgSubscriptionRequest data;

  const UpdateOrgSubscriptionParams({
    required this.id,
    required this.data,
  });
}

/// Mutation hook to upgrade or update an organization's subscription plan & status.
MutationSnapshot<ActiveSubscriptionModel, Object, UpdateOrgSubscriptionParams>
    useUpdateOrgSubscriptionMutation({
  void Function(ActiveSubscriptionModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Subscription updated successfully',
}) {
  return useAppMutation(
    (params) =>
        OrganizationsRepo.updateOrgSubscription(params.id, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
