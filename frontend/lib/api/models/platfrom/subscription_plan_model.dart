/// Subscription Plan entity model representing SaaS subscription tiers.
class SubscriptionPlanModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double priceMonthly;
  final double priceYearly;
  final String currency;
  final int maxBranches;
  final int maxStudentsPerBranch;
  final int maxTeachersPerBranch;
  final Map<String, dynamic> features;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int activeSubscriptionsCount;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.priceMonthly,
    required this.priceYearly,
    this.currency = 'INR',
    required this.maxBranches,
    required this.maxStudentsPerBranch,
    required this.maxTeachersPerBranch,
    this.features = const {},
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
    this.activeSubscriptionsCount = 0,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      priceMonthly: (json['priceMonthly'] as num?)?.toDouble() ?? 0.0,
      priceYearly: (json['priceYearly'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      maxBranches: (json['maxBranches'] as num?)?.toInt() ?? 1,
      maxStudentsPerBranch:
          (json['maxStudentsPerBranch'] as num?)?.toInt() ?? 0,
      maxTeachersPerBranch:
          (json['maxTeachersPerBranch'] as num?)?.toInt() ?? 0,
      features: (json['features'] as Map<String, dynamic>?) ?? {},
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      activeSubscriptionsCount:
          (json['_count']?['subscriptions'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'priceMonthly': priceMonthly,
      'priceYearly': priceYearly,
      'currency': currency,
      'maxBranches': maxBranches,
      'maxStudentsPerBranch': maxStudentsPerBranch,
      'maxTeachersPerBranch': maxTeachersPerBranch,
      'features': features,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '_count': {'subscriptions': activeSubscriptionsCount},
    };
  }
}

/// Request payload for creating a new Subscription Plan.
class CreatePlanRequest {
  final String name;
  final String? slug;
  final String? description;
  final double priceMonthly;
  final double priceYearly;
  final String currency;
  final int maxBranches;
  final int maxStudentsPerBranch;
  final int maxTeachersPerBranch;
  final Map<String, dynamic> features;
  final bool isActive;
  final int sortOrder;

  const CreatePlanRequest({
    required this.name,
    this.slug,
    this.description,
    required this.priceMonthly,
    required this.priceYearly,
    this.currency = 'INR',
    required this.maxBranches,
    required this.maxStudentsPerBranch,
    required this.maxTeachersPerBranch,
    this.features = const {},
    this.isActive = true,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (slug != null && slug!.isNotEmpty) 'slug': slug,
      if (description != null) 'description': description,
      'priceMonthly': priceMonthly,
      'priceYearly': priceYearly,
      'currency': currency,
      'maxBranches': maxBranches,
      'maxStudentsPerBranch': maxStudentsPerBranch,
      'maxTeachersPerBranch': maxTeachersPerBranch,
      'features': features,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}

/// Request payload for updating an existing Subscription Plan.
class UpdatePlanRequest {
  final String? name;
  final String? slug;
  final String? description;
  final double? priceMonthly;
  final double? priceYearly;
  final String? currency;
  final int? maxBranches;
  final int? maxStudentsPerBranch;
  final int? maxTeachersPerBranch;
  final Map<String, dynamic>? features;
  final bool? isActive;
  final int? sortOrder;

  const UpdatePlanRequest({
    this.name,
    this.slug,
    this.description,
    this.priceMonthly,
    this.priceYearly,
    this.currency,
    this.maxBranches,
    this.maxStudentsPerBranch,
    this.maxTeachersPerBranch,
    this.features,
    this.isActive,
    this.sortOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (priceMonthly != null) 'priceMonthly': priceMonthly,
      if (priceYearly != null) 'priceYearly': priceYearly,
      if (currency != null) 'currency': currency,
      if (maxBranches != null) 'maxBranches': maxBranches,
      if (maxStudentsPerBranch != null)
        'maxStudentsPerBranch': maxStudentsPerBranch,
      if (maxTeachersPerBranch != null)
        'maxTeachersPerBranch': maxTeachersPerBranch,
      if (features != null) 'features': features,
      if (isActive != null) 'isActive': isActive,
      if (sortOrder != null) 'sortOrder': sortOrder,
    };
  }
}
