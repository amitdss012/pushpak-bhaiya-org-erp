import 'package:flutter/foundation.dart';

import '../../../../core/utils/toast_utils.dart';
import '../../domain/entities/login_portal_type.dart';
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
    required LoginPortalType portal,
    bool rememberMe = false,
  }) async {
    _state = _state.copyWith(status: AuthStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      final user = await loginUseCase(
        email: email,
        password: password,
        portal: portal,
        rememberMe: rememberMe,
      );
      _state = _state.copyWith(status: AuthStatus.success, user: user);
      AppToast.showSuccess('Login successful');
      notifyListeners();
      return true;
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      _state = _state.copyWith(status: AuthStatus.error, errorMessage: message);
      AppToast.showError(e);
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = const AuthState();
    notifyListeners();
  }
}
