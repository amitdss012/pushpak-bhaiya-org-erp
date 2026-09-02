import '../../api_client.dart';
import '../../models/models.dart';

/// Repository for organization onboarding and management API operations.
class OrganizationsRepo {
  OrganizationsRepo._();

  /// Retrieve paginated organizations with search and filters.
  static Future<PaginatedOrganizationsResponse> getOrganizations(
    GetOrganizationsParams params,
  ) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/platform/organizations',
      queryParameters: params.toQueryParams(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return PaginatedOrganizationsResponse.fromJson(rawData);
  }

  /// Retrieve detailed organization profile by ID.
  static Future<OrganizationDetailModel> getOrganizationById(String id) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/platform/organizations/$id',
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OrganizationDetailModel.fromJson(rawData);
  }

  /// Onboard a new organization with plan & owner user.
  static Future<OnboardOrganizationResponse> onboardOrganization(
    OnboardOrganizationRequest request,
  ) async {
    final response = await ApiClient().post<Map<String, dynamic>>(
      '/platform/organizations/onboard',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OnboardOrganizationResponse.fromJson(rawData);
  }

  /// Update organization profile and status.
  static Future<Map<String, dynamic>> updateOrganization(
    String id,
    UpdateOrganizationRequest request,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/platform/organizations/$id',
      data: request.toJson(),
    );
    return response.data?['data'] as Map<String, dynamic>? ?? {};
  }

  /// Upgrade or update organization subscription plan & status.
  static Future<ActiveSubscriptionModel> updateOrgSubscription(
    String id,
    UpdateOrgSubscriptionRequest request,
  ) async {
    final response = await ApiClient().patch<Map<String, dynamic>>(
      '/platform/organizations/$id/subscription',
      data: request.toJson(),
    );
    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return ActiveSubscriptionModel.fromJson(rawData);
  }
}
