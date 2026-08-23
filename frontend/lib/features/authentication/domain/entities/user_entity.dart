/// User domain entity representing an authenticated SaaS user.
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? organizationId;
  final String? branchId;
  final String role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.organizationId,
    this.branchId,
    required this.role,
  });
}
