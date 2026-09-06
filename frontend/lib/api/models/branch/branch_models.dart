import '../pagination_model.dart';

/// Single branch model representing an organization sub-unit.
class BranchModel {
  final String id;
  final String name;
  final String slug;
  final String? code;
  final String? email;
  final String? phone;
  final String? altPhone;
  final String? whatsapp;
  final String? logo;
  final String branchType;
  final String instituteType;
  final String? establishedYear;
  final String? website;
  final String? description;
  final String? address;
  final String? city;
  final String? district;
  final String? block;
  final String? state;
  final String country;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final String? directorName;
  final String? directorGender;
  final DateTime? directorDob;
  final String? directorBloodGroup;
  final int numComputers;
  final int numFaculty;
  final int numRooms;
  final double? numFees;
  final DateTime? registrationDate;
  final DateTime? validDate;
  final DateTime? expiryDate;
  final DateTime? renewalDate;
  final String? referralCode;
  final bool onlineEnrollment;
  final bool smsNotifications;
  final bool emailNotifications;
  final String status;
  final int usersCount;
  final int studentsCount;
  final int staffCount;
  final DateTime? createdAt;

  const BranchModel({
    required this.id,
    required this.name,
    required this.slug,
    this.code,
    this.email,
    this.phone,
    this.altPhone,
    this.whatsapp,
    this.logo,
    this.branchType = 'main',
    this.instituteType = 'computer',
    this.establishedYear,
    this.website,
    this.description,
    this.address,
    this.city,
    this.district,
    this.block,
    this.state,
    this.country = 'IN',
    this.pincode,
    this.latitude,
    this.longitude,
    this.directorName,
    this.directorGender,
    this.directorDob,
    this.directorBloodGroup,
    this.numComputers = 0,
    this.numFaculty = 0,
    this.numRooms = 0,
    this.numFees,
    this.registrationDate,
    this.validDate,
    this.expiryDate,
    this.renewalDate,
    this.referralCode,
    this.onlineEnrollment = true,
    this.smsNotifications = false,
    this.emailNotifications = true,
    this.status = 'ACTIVE',
    this.usersCount = 0,
    this.studentsCount = 0,
    this.staffCount = 0,
    this.createdAt,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final countJson = json['_count'] as Map<String, dynamic>? ?? {};

    return BranchModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      code: json['code'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      altPhone: json['altPhone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      logo: json['logo'] as String?,
      branchType: json['branchType'] as String? ?? 'main',
      instituteType: json['instituteType'] as String? ?? 'computer',
      establishedYear: json['establishedYear'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      block: json['block'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String? ?? 'IN',
      pincode: json['pincode'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      directorName: json['directorName'] as String?,
      directorGender: json['directorGender'] as String?,
      directorDob: json['directorDob'] != null
          ? DateTime.tryParse(json['directorDob'].toString())
          : null,
      directorBloodGroup: json['directorBloodGroup'] as String?,
      numComputers: json['numComputers'] as int? ?? 0,
      numFaculty: json['numFaculty'] as int? ?? 0,
      numRooms: json['numRooms'] as int? ?? 0,
      numFees: json['numFees'] != null
          ? (json['numFees'] as num).toDouble()
          : null,
      registrationDate: json['registrationDate'] != null
          ? DateTime.tryParse(json['registrationDate'].toString())
          : null,
      validDate: json['validDate'] != null
          ? DateTime.tryParse(json['validDate'].toString())
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'].toString())
          : null,
      renewalDate: json['renewalDate'] != null
          ? DateTime.tryParse(json['renewalDate'].toString())
          : null,
      referralCode: json['referralCode'] as String?,
      onlineEnrollment: json['onlineEnrollment'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? false,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      status: (json['status'] as String? ?? 'ACTIVE').toUpperCase(),
      usersCount: json['usersCount'] as int? ??
          countJson['users'] as int? ??
          0,
      studentsCount: json['studentsCount'] as int? ??
          countJson['students'] as int? ??
          0,
      staffCount: json['staffCount'] as int? ??
          countJson['teachers'] as int? ??
          0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

/// Aggregated metrics for the organization's branch portfolio.
class BranchStatsModel {
  final int totalBranches;
  final int activeBranches;
  final int inactiveBranches;
  final int totalStudents;
  final int totalStaff;

  const BranchStatsModel({
    this.totalBranches = 0,
    this.activeBranches = 0,
    this.inactiveBranches = 0,
    this.totalStudents = 0,
    this.totalStaff = 0,
  });

  factory BranchStatsModel.fromJson(Map<String, dynamic> json) {
    return BranchStatsModel(
      totalBranches: json['totalBranches'] as int? ?? 0,
      activeBranches: json['activeBranches'] as int? ?? 0,
      inactiveBranches: json['inactiveBranches'] as int? ?? 0,
      totalStudents: json['totalStudents'] as int? ?? 0,
      totalStaff: json['totalStaff'] as int? ?? 0,
    );
  }
}

/// Request payload to create a new Branch.
class CreateBranchRequest {
  final String name;
  final String? code;
  final String branchType;
  final String instituteType;
  final String? establishedYear;
  final String? website;
  final String? description;
  final String? address;
  final String? city;
  final String? district;
  final String? block;
  final String? state;
  final String country;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? altPhone;
  final String? whatsapp;
  final String? email;
  final String? directorName;
  final String? directorGender;
  final String? directorDob;
  final String? directorBloodGroup;
  final int numComputers;
  final int numFaculty;
  final int numRooms;
  final double? numFees;
  final String? registrationDate;
  final String? validDate;
  final String? expiryDate;
  final String? renewalDate;
  final String? referralCode;
  final bool activeStatus;
  final bool onlineEnrollment;
  final bool smsNotifications;
  final bool emailNotifications;

  // Optional admin user credentials
  final String? adminName;
  final String? adminUsername;
  final String? adminPassword;
  final String? adminEmail;
  final String? adminPhone;

  const CreateBranchRequest({
    required this.name,
    this.code,
    this.branchType = 'main',
    this.instituteType = 'computer',
    this.establishedYear,
    this.website,
    this.description,
    this.address,
    this.city,
    this.district,
    this.block,
    this.state,
    this.country = 'IN',
    this.pincode,
    this.latitude,
    this.longitude,
    this.phone,
    this.altPhone,
    this.whatsapp,
    this.email,
    this.directorName,
    this.directorGender,
    this.directorDob,
    this.directorBloodGroup,
    this.numComputers = 0,
    this.numFaculty = 0,
    this.numRooms = 0,
    this.numFees,
    this.registrationDate,
    this.validDate,
    this.expiryDate,
    this.renewalDate,
    this.referralCode,
    this.activeStatus = true,
    this.onlineEnrollment = true,
    this.smsNotifications = false,
    this.emailNotifications = true,
    this.adminName,
    this.adminUsername,
    this.adminPassword,
    this.adminEmail,
    this.adminPhone,
  });

  Map<String, dynamic> toJson() => {
        'name': name.trim(),
        if (code != null && code!.trim().isNotEmpty) 'code': code!.trim(),
        'branchType': branchType,
        'instituteType': instituteType,
        if (establishedYear != null && establishedYear!.trim().isNotEmpty)
          'establishedYear': establishedYear!.trim(),
        if (website != null && website!.trim().isNotEmpty)
          'website': website!.trim(),
        if (description != null && description!.trim().isNotEmpty)
          'description': description!.trim(),
        if (address != null && address!.trim().isNotEmpty)
          'address': address!.trim(),
        if (city != null && city!.trim().isNotEmpty) 'city': city!.trim(),
        if (district != null && district!.trim().isNotEmpty)
          'district': district!.trim(),
        if (block != null && block!.trim().isNotEmpty) 'block': block!.trim(),
        if (state != null && state!.trim().isNotEmpty) 'state': state!.trim(),
        'country': country,
        if (pincode != null && pincode!.trim().isNotEmpty)
          'pincode': pincode!.trim(),
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
        if (altPhone != null && altPhone!.trim().isNotEmpty)
          'altPhone': altPhone!.trim(),
        if (whatsapp != null && whatsapp!.trim().isNotEmpty)
          'whatsapp': whatsapp!.trim(),
        if (email != null && email!.trim().isNotEmpty)
          'email': email!.trim().toLowerCase(),
        if (directorName != null && directorName!.trim().isNotEmpty)
          'directorName': directorName!.trim(),
        if (directorGender != null) 'directorGender': directorGender,
        if (directorDob != null && directorDob!.trim().isNotEmpty)
          'directorDob': directorDob!.trim(),
        if (directorBloodGroup != null)
          'directorBloodGroup': directorBloodGroup,
        'numComputers': numComputers,
        'numFaculty': numFaculty,
        'numRooms': numRooms,
        if (numFees != null) 'numFees': numFees,
        if (registrationDate != null && registrationDate!.trim().isNotEmpty)
          'registrationDate': registrationDate!.trim(),
        if (validDate != null && validDate!.trim().isNotEmpty)
          'validDate': validDate!.trim(),
        if (expiryDate != null && expiryDate!.trim().isNotEmpty)
          'expiryDate': expiryDate!.trim(),
        if (renewalDate != null && renewalDate!.trim().isNotEmpty)
          'renewalDate': renewalDate!.trim(),
        if (referralCode != null && referralCode!.trim().isNotEmpty)
          'referralCode': referralCode!.trim(),
        'activeStatus': activeStatus,
        'onlineEnrollment': onlineEnrollment,
        'smsNotifications': smsNotifications,
        'emailNotifications': emailNotifications,
        if (adminName != null && adminName!.trim().isNotEmpty)
          'adminName': adminName!.trim(),
        if (adminUsername != null && adminUsername!.trim().isNotEmpty)
          'adminUsername': adminUsername!.trim(),
        if (adminPassword != null && adminPassword!.trim().isNotEmpty)
          'adminPassword': adminPassword!.trim(),
        if (adminEmail != null && adminEmail!.trim().isNotEmpty)
          'adminEmail': adminEmail!.trim().toLowerCase(),
        if (adminPhone != null && adminPhone!.trim().isNotEmpty)
          'adminPhone': adminPhone!.trim(),
      };
}

/// Paginated branches API response.
class PaginatedBranchesResponse {
  final List<BranchModel> branches;
  final BranchStatsModel stats;
  final PaginationMeta meta;

  const PaginatedBranchesResponse({
    required this.branches,
    required this.stats,
    required this.meta,
  });

  factory PaginatedBranchesResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List? ?? [];
    final branches = rawData
        .map((b) => BranchModel.fromJson(b as Map<String, dynamic>))
        .toList();

    final statsJson = json['stats'] as Map<String, dynamic>? ?? {};
    final stats = BranchStatsModel.fromJson(statsJson);

    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final meta = PaginationMeta.fromJson(metaJson);

    return PaginatedBranchesResponse(
      branches: branches,
      stats: stats,
      meta: meta,
    );
  }
}
