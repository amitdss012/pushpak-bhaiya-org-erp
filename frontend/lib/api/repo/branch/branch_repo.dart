import 'package:dio/dio.dart';
import '../../api_client.dart';
import '../../models/models.dart';

/// Repository handling Branch operations communicating with `/api/v1/branch` endpoints.
class BranchRepo {
  BranchRepo._();

  /// Provision a new branch with optional Cloudinary logo upload via multipart FormData.
  static Future<BranchModel> createBranch(
    CreateBranchRequest request, {
    List<int>? logoBytes,
    String? logoFileName,
  }) async {
    dynamic postData;

    if (logoBytes != null && logoBytes.isNotEmpty) {
      final formMap = Map<String, dynamic>.from(request.toJson());
      formMap['logo'] = MultipartFile.fromBytes(
        logoBytes,
        filename: logoFileName ?? 'branch_logo.png',
      );
      postData = FormData.fromMap(formMap);
    } else {
      postData = request.toJson();
    }

    final response = await ApiClient().post<Map<String, dynamic>>(
      '/branch',
      data: postData,
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return BranchModel.fromJson(rawData);
  }

  /// Retrieve paginated branches list with KPI summary stats and filters.
  static Future<PaginatedBranchesResponse> getBranches({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? branchType,
    String? city,
  }) async {
    final response = await ApiClient().get<Map<String, dynamic>>(
      '/branch',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (status != null && status.isNotEmpty && status.toLowerCase() != 'all')
          'status': status.toUpperCase(),
        if (branchType != null && branchType.isNotEmpty && branchType.toLowerCase() != 'all')
          'branchType': branchType,
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
      },
    );

    final rawData = response.data?['data'] as Map<String, dynamic>? ?? {};
    return PaginatedBranchesResponse.fromJson(rawData);
  }
}
