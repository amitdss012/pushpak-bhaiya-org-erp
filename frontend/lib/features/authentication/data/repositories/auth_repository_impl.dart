import '../../domain/entities/login_portal_type.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository communicating with AuthRemoteDataSource.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  UserEntity? _cachedUser;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
    required LoginPortalType portal,
    bool rememberMe = false,
  }) async {
    final user = await remoteDataSource.login(
      email: email,
      password: password,
      portal: portal,
      rememberMe: rememberMe,
    );
    _cachedUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    _cachedUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _cachedUser;
  }
}
