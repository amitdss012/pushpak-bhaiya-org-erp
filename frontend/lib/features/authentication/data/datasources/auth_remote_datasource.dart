import '../../../../api/models/models.dart';
import '../../../../api/repo/user/user_repo.dart';
import '../../../../core/auth/user_auth_service.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_portal_type.dart';
import '../../domain/entities/user_entity.dart';

/// Remote data source interface for authentication API.
abstract class AuthRemoteDataSource {
  Future<UserEntity> login({
    required String email,
    required String password,
    required LoginPortalType portal,
    bool rememberMe = false,
  });

  Future<void> logout();
}

/// Production implementation communicating with real User API and UserAuthService.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    required LoginPortalType portal,
    bool rememberMe = false,
  }) async {
    final response = await UserRepo.login(UserLoginRequest(
      email: email,
      password: password,
    ));

    // Enforce Portal-Specific Multi-Tenant Boundaries
    switch (portal) {
      case LoginPortalType.organization:
        if (response.user.student != null) {
          throw const AuthFailure(
            'This is a student account. Please use the Student login portal.',
          );
        }
        if (response.user.teacher != null) {
          throw const AuthFailure(
            'This is a teacher account. Please use the Teacher login portal.',
          );
        }
        if (response.user.parent != null) {
          throw const AuthFailure(
            'This is a parent account. Please use the Parent login portal.',
          );
        }
        if (response.user.scope != 'ORGANIZATION') {
          throw const AuthFailure(
            'This account does not have Organization access. Please use your assigned portal.',
          );
        }
        break;

      case LoginPortalType.branch:
        if (response.user.student != null) {
          throw const AuthFailure(
            'This is a student account. Please use the Student login portal.',
          );
        }
        if (response.user.teacher != null) {
          throw const AuthFailure(
            'This is a teacher account. Please use the Teacher login portal.',
          );
        }
        if (response.user.parent != null) {
          throw const AuthFailure(
            'This is a parent account. Please use the Parent login portal.',
          );
        }
        final hasBranch =
            response.user.scope == 'BRANCH' || response.user.branchId != null;
        if (!hasBranch) {
          throw const AuthFailure(
            'This account is not associated with any branch. Please use the Organization login.',
          );
        }
        break;

      case LoginPortalType.teacher:
        if (response.user.teacher == null) {
          throw const AuthFailure(
            'No faculty profile found for this account. Please use Organization, Branch, Student, or Parent login.',
          );
        }
        break;

      case LoginPortalType.student:
        if (response.user.student == null) {
          throw const AuthFailure(
            'No student profile found for this account. Please use Organization, Branch, Teacher, or Parent login.',
          );
        }
        break;

      case LoginPortalType.parent:
        if (response.user.parent == null) {
          throw const AuthFailure(
            'No parent profile found for this account. Please use Organization, Branch, Teacher, or Student login.',
          );
        }
        break;
    }

    // Register active session & tokens in UserAuthService with active portal
    await UserAuthService.instance.login(response, portal: portal);

    return UserEntity(
      id: response.user.id,
      email: response.user.email,
      name: response.user.fullName,
      organizationId: response.user.organizationId,
      branchId: response.user.branchId,
      role: response.user.primaryRole,
    );
  }

  @override
  Future<void> logout() async {
    await UserAuthService.instance.logout();
  }
}

/// Simulated mock data source for initial architecture before connecting to live API.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    required LoginPortalType portal,
    bool rememberMe = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (password == 'wrongpassword') {
      throw const AuthFailure('Invalid email or password.');
    }

    return UserEntity(
      id: 'mock-user-123',
      email: email,
      name: email.split('@').first,
      role: 'ORGANIZATION_ADMIN',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

