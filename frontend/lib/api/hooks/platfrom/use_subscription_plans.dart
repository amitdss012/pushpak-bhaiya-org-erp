import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/platfrom/subscription_plans_repo.dart';

/// Query hook to fetch all subscription plans (flat list ordered by sortOrder).
QuerySnapshot<List<SubscriptionPlanModel>, Object> useSubscriptionPlansQuery({
  bool? isActive,
  bool enabled = true,
}) {
  return useQuery(
    ['platform', 'plans', isActive],
    (_) => SubscriptionPlansRepo.getPlans(isActive: isActive),
    enabled: enabled,
  );
}

/// Query hook to fetch a single subscription plan by ID.
QuerySnapshot<SubscriptionPlanModel, Object> useSubscriptionPlanQuery(
  String id, {
  bool enabled = true,
}) {
  return useQuery(
    ['platform', 'plans', id],
    (_) => SubscriptionPlansRepo.getPlanById(id),
    enabled: enabled && id.isNotEmpty,
  );
}

/// Mutation hook to create a new subscription plan.
MutationSnapshot<SubscriptionPlanModel, Object, CreatePlanRequest>
    useCreateSubscriptionPlanMutation({
  void Function(SubscriptionPlanModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Subscription plan created successfully',
}) {
  return useAppMutation(
    SubscriptionPlansRepo.createPlan,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Parameters for updating a subscription plan.
class UpdatePlanParams {
  final String id;
  final UpdatePlanRequest data;

  const UpdatePlanParams({
    required this.id,
    required this.data,
  });
}

/// Mutation hook to update an existing subscription plan.
MutationSnapshot<SubscriptionPlanModel, Object, UpdatePlanParams>
    useUpdateSubscriptionPlanMutation({
  void Function(SubscriptionPlanModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Subscription plan updated successfully',
}) {
  return useAppMutation(
    (params) => SubscriptionPlansRepo.updatePlan(params.id, params.data),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}

/// Mutation hook to delete a subscription plan.
MutationSnapshot<void, Object, String> useDeleteSubscriptionPlanMutation({
  void Function(void data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Subscription plan deleted successfully',
}) {
  return useAppMutation(
    SubscriptionPlansRepo.deletePlan,
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
