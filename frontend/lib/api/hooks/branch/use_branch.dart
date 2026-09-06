import 'package:flutter_query/flutter_query.dart';

import '../../../core/utils/use_app_mutation.dart';
import '../../models/models.dart';
import '../../repo/branch/branch_repo.dart';

/// Parameters for creating a branch with an optional uploaded logo.
class CreateBranchParams {
  final CreateBranchRequest request;
  final List<int>? logoBytes;
  final String? logoFileName;

  const CreateBranchParams({
    required this.request,
    this.logoBytes,
    this.logoFileName,
  });
}

/// Query hook to retrieve paginated branches and KPI metrics.
QuerySnapshot<PaginatedBranchesResponse, Object> useBranchesQuery({
  int page = 1,
  int limit = 20,
  String? search,
  String? status,
  String? branchType,
  String? city,
  bool enabled = true,
}) {
  return useQuery(
    ['branches', page, limit, search, status, branchType, city],
    (_) => BranchRepo.getBranches(
      page: page,
      limit: limit,
      search: search,
      status: status,
      branchType: branchType,
      city: city,
    ),
    enabled: enabled,
  );
}

/// Mutation hook to create a new branch with optional Cloudinary logo upload.
MutationSnapshot<BranchModel, Object, CreateBranchParams>
    useCreateBranchMutation({
  void Function(BranchModel data)? onSuccess,
  void Function(Object error)? onError,
  String successMessage = 'Branch created successfully',
}) {
  return useAppMutation(
    (params) => BranchRepo.createBranch(
      params.request,
      logoBytes: params.logoBytes,
      logoFileName: params.logoFileName,
    ),
    successMessage: successMessage,
    onSuccess: onSuccess,
    onError: onError,
  );
}
