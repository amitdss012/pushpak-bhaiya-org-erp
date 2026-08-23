import 'package:frontend/core/errors/failures.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to authenticate a user with email and password.
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty) {
      throw const ValidationFailure('Email cannot be empty.');
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmedEmail)) {
      throw const ValidationFailure('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters.');
    }

    return repository.login(
      email: trimmedEmail,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
