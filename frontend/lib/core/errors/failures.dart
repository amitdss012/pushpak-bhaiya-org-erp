/// Base class for failure representations across domain and data layers.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'A server error occurred. Please try again.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed. Please check your credentials.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection.',
  ]);
}
