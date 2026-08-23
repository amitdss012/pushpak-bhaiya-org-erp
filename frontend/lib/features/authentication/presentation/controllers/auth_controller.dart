import 'package:flutter/foundation.dart';

import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

/// Presentation controller managing authentication operations and state.
class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthState _state = const AuthState();
  AuthState get state => _state;

  AuthController({required this.loginUseCase});

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _state = _state.copyWith(status: AuthStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      final user = await loginUseCase(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      _state = _state.copyWith(status: AuthStatus.success, user: user);
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = const AuthState();
    notifyListeners();
  }
}
