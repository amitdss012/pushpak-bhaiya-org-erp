import '../../api_client.dart';
import '../../models/models.dart';

/// Repository for subscription plans API operations.
class SubscriptionPlansRepo {
  SubscriptionPlansRepo._();

  /// Retrieve all subscription plans (ordered by sortOrder).
  static Future<List<SubscriptionPlanModel>> getPlans({
    bool? isActive,
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/platform/plans',
      queryParameters: {
        if (isActive != null) 'isActive': isActive.toString(),
      },
    );
    final list = (response.data?['data'] as List<dynamic>?) ?? [];
    return list
        .map((e) => SubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Retrieve a single subscription plan by ID.
  static Future<SubscriptionPlanModel> getPlanById(String id) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/platform/plans/$id',
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return SubscriptionPlanModel.fromJson(rawData);
  }

  /// Create a new subscription plan.
  static Future<SubscriptionPlanModel> createPlan(
    CreatePlanRequest request,
  ) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/platform/plans',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return SubscriptionPlanModel.fromJson(rawData);
  }

  /// Update an existing subscription plan.
  static Future<SubscriptionPlanModel> updatePlan(
    String id,
    UpdatePlanRequest request,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/platform/plans/$id',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return SubscriptionPlanModel.fromJson(rawData);
  }

  /// Delete a subscription plan.
  static Future<void> deletePlan(String id) async {
    await ApiClient().delete<Map<String, dynamic>>('/platform/plans/$id');
  }
}
