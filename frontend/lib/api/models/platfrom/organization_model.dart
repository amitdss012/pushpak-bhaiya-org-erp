import '../pagination_model.dart';
import 'subscription_plan_model.dart';

/// User representation for Organization Owner / Admin.
class UserModel {
  final String id;
  final String firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String status;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.status = 'ACTIVE',
    this.createdAt,
  });

  String get fullName =>
      lastName != null && lastName!.isNotEmpty ? '$firstName $lastName' : firstName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String?,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

/// Active subscription entity attached to an organization.
class ActiveSubscriptionModel {
  final String id;
  final String planId;
  final String status;
  final String billingCycle;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? trialEndsAt;
  final SubscriptionPlanModel? plan;

  const ActiveSubscriptionModel({
    required this.id,
    required this.planId,
    required this.status,
    required this.billingCycle,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.trialEndsAt,
    this.plan,
  });

  factory ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return ActiveSubscriptionModel(
      id: json['id'] as String? ?? '',
      planId: json['planId'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      currentPeriodStart: json['currentPeriodStart'] != null
          ? DateTime.parse(json['currentPeriodStart'].toString())
          : DateTime.now(),
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.parse(json['currentPeriodEnd'].toString())
          : DateTime.now(),
      trialEndsAt: json['trialEndsAt'] != null
          ? DateTime.tryParse(json['trialEndsAt'].toString())
          : null,
      plan: json['plan'] != null
          ? SubscriptionPlanModel.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'status': status,
      'billingCycle': billingCycle,
      'currentPeriodStart': currentPeriodStart.toIso8601String(),
      'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
      'trialEndsAt': trialEndsAt?.toIso8601String(),
      'plan': plan?.toJson(),
    };
  }
}

/// Subscription history entry in Organization details.
class SubscriptionHistoryItemModel {
  final String id;
  final String status;
  final String billingCycle;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? trialEndsAt;
  final DateTime? cancelledAt;
  final Map<String, dynamic>? plan;

  const SubscriptionHistoryItemModel({
    required this.id,
    required this.status,
    required this.billingCycle,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.trialEndsAt,
    this.cancelledAt,
    this.plan,
  });

  factory SubscriptionHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryItemModel(
      id: json['id'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      currentPeriodStart: json['currentPeriodStart'] != null
          ? DateTime.parse(json['currentPeriodStart'].toString())
          : DateTime.now(),
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.parse(json['currentPeriodEnd'].toString())
          : DateTime.now(),
      trialEndsAt: json['trialEndsAt'] != null
          ? DateTime.tryParse(json['trialEndsAt'].toString())
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.tryParse(json['cancelledAt'].toString())
          : null,
      plan: json['plan'] as Map<String, dynamic>?,
    );
  }
}

/// Organization entity in paginated list views.
class OrganizationListItemModel {
  final String id;
  final String name;
  final String slug;
  final String? email;
  final String? phone;
  final String? logo;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ActiveSubscriptionModel? activeSubscription;
  final UserModel? owner;
  final int branchesCount;
  final int usersCount;

  const OrganizationListItemModel({
    required this.id,
    required this.name,
    required this.slug,
    this.email,
    this.phone,
    this.logo,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.activeSubscription,
    this.owner,
    this.branchesCount = 0,
    this.usersCount = 0,
  });

  factory OrganizationListItemModel.fromJson(Map<String, dynamic> json) {
    return OrganizationListItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      logo: json['logo'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      activeSubscription: json['activeSubscription'] != null
          ? ActiveSubscriptionModel.fromJson(
              json['activeSubscription'] as Map<String, dynamic>,
            )
          : null,
      owner: json['owner'] != null
          ? UserModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      branchesCount: (json['_count']?['branches'] as num?)?.toInt() ?? 0,
      usersCount: (json['_count']?['users'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Paginated organizations response wrapper.
class PaginatedOrganizationsResponse {
  final List<OrganizationListItemModel> data;
  final PaginationMeta pagination;

  const PaginatedOrganizationsResponse({
    required this.data,
    required this.pagination,
  });

  factory PaginatedOrganizationsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?)
            ?.map((e) =>
                OrganizationListItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final pagination = PaginationMeta.fromJson(
      json['pagination'] as Map<String, dynamic>? ?? {},
    );

    return PaginatedOrganizationsResponse(
      data: list,
      pagination: pagination,
    );
  }
}

/// Detailed single Organization profile.
class OrganizationDetailModel {
  final String id;
  final String name;
  final String slug;
  final String? email;
  final String? phone;
  final String? logo;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ActiveSubscriptionModel? activeSubscription;
  final List<SubscriptionHistoryItemModel> subscriptions;
  final UserModel? owner;
  final int branchesCount;
  final int usersCount;

  const OrganizationDetailModel({
    required this.id,
    required this.name,
    required this.slug,
    this.email,
    this.phone,
    this.logo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.activeSubscription,
    this.subscriptions = const [],
    this.owner,
    this.branchesCount = 0,
    this.usersCount = 0,
  });

  factory OrganizationDetailModel.fromJson(Map<String, dynamic> json) {
    final subList = (json['subscriptions'] as List<dynamic>?)
            ?.map((e) => SubscriptionHistoryItemModel.fromJson(
                e as Map<String, dynamic>))
            .toList() ??
        [];

    return OrganizationDetailModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      logo: json['logo'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pincode: json['pincode'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      activeSubscription: json['activeSubscription'] != null
          ? ActiveSubscriptionModel.fromJson(
              json['activeSubscription'] as Map<String, dynamic>,
            )
          : null,
      subscriptions: subList,
      owner: json['owner'] != null
          ? UserModel.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      branchesCount: (json['stats']?['branchesCount'] as num?)?.toInt() ?? 0,
      usersCount: (json['stats']?['usersCount'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Request DTO for onboarding a new organization.
class OnboardOrganizationRequest {
  final Map<String, dynamic> organization;
  final Map<String, dynamic> subscription;
  final Map<String, dynamic> owner;

  const OnboardOrganizationRequest({
    required this.organization,
    required this.subscription,
    required this.owner,
  });

  Map<String, dynamic> toJson() {
    return {
      'organization': organization,
      'subscription': subscription,
      'owner': owner,
    };
  }
}

/// Response DTO after onboarding an organization.
class OnboardOrganizationResponse {
  final Map<String, dynamic> organization;
  final Map<String, dynamic> subscription;
  final UserModel owner;

  const OnboardOrganizationResponse({
    required this.organization,
    required this.subscription,
    required this.owner,
  });

  factory OnboardOrganizationResponse.fromJson(Map<String, dynamic> json) {
    return OnboardOrganizationResponse(
      organization: json['organization'] as Map<String, dynamic>? ?? {},
      subscription: json['subscription'] as Map<String, dynamic>? ?? {},
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// Request DTO for updating organization profile.
class UpdateOrganizationRequest {
  final String? name;
  final String? slug;
  final String? email;
  final String? phone;
  final String? logo;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? status;

  const UpdateOrganizationRequest({
    this.name,
    this.slug,
    this.email,
    this.phone,
    this.logo,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (logo != null) 'logo': logo,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (pincode != null) 'pincode': pincode,
      if (status != null) 'status': status,
    };
  }
}

/// Request DTO for upgrading/updating organization subscription plan & status.
class UpdateOrgSubscriptionRequest {
  final String? planId;
  final String? billingCycle;
  final String? status;
  final String? currentPeriodEnd;
  final String? trialEndsAt;

  const UpdateOrgSubscriptionRequest({
    this.planId,
    this.billingCycle,
    this.status,
    this.currentPeriodEnd,
    this.trialEndsAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (planId != null) 'planId': planId,
      if (billingCycle != null) 'billingCycle': billingCycle,
      if (status != null) 'status': status,
      if (currentPeriodEnd != null) 'currentPeriodEnd': currentPeriodEnd,
      if (trialEndsAt != null) 'trialEndsAt': trialEndsAt,
    };
  }
}

/// Parameters for querying the paginated organizations list.
class GetOrganizationsParams {
  final int page;
  final int limit;
  final String? search;
  final String? status;
  final String? planId;
  final String sortBy;
  final String sortOrder;

  const GetOrganizationsParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.status,
    this.planId,
    this.sortBy = 'createdAt',
    this.sortOrder = 'desc',
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null && search!.isNotEmpty) 'search': search,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (planId != null && planId!.isNotEmpty) 'planId': planId,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }
}

