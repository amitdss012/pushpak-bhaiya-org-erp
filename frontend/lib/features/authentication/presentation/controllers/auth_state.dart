import '../../domain/entities/user_entity.dart';

enum AuthStatus { idle, loading, success, error }

/// Represents the presentation state of the authentication flow.
class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.idle,
    this.user,
    this.errorMessage,
  });

  bool get isIdle => status == AuthStatus.idle;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
