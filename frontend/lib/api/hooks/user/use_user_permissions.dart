import 'package:flutter_query/flutter_query.dart';

import '../../models/models.dart';
import '../../repo/user/user_repo.dart';

/// Query hook to fetch all system permissions from /user/permissions.
QuerySnapshot<List<SystemPermissionModel>, Object> usePermissionsQuery({
  bool enabled = true,
}) {
  return useQuery(
    ['user', 'permissions'],
    (_) => UserRepo.getPermissions(),
    enabled: enabled,
  );
}
