import 'package:frontend/core/errors/failures.dart';

import '../../domain/entities/user_entity.dart';

/// Remote data source interface for authentication API.
abstract class AuthRemoteDataSource {
  Future<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<void> logout();
}

/// Simulated mock data source for initial architecture before connecting to live API.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
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
