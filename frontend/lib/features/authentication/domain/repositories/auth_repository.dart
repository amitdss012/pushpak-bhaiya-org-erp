import '../entities/user_entity.dart';

/// Abstract contract for authentication repository.
abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}
