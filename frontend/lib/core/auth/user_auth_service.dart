import 'package:flutter/foundation.dart';

import '../../api/api_client.dart';
import '../../api/models/models.dart';
import '../../api/repo/user/user_repo.dart';
import '../../features/authentication/domain/entities/login_portal_type.dart';
import 'token_storage.dart';

/// Global reactive authentication service for Organization, Branch, and Student Users.
/// Extends [ChangeNotifier] to drive reactive GoRouter redirect guards.
class UserAuthService extends ChangeNotifier {
  static final UserAuthService instance = UserAuthService._internal();

  UserModel? _currentUser;
  LoginPortalType? _activePortal;
  bool _isInitializing = true;

  UserAuthService._internal();

  /// The currently authenticated user profile, or null.
  UserModel? get currentUser => _currentUser;

  /// The active login portal associated with this user session.
  LoginPortalType? get activePortal => _activePortal;

  /// Whether the initial authentication check is in progress.
  bool get isInitializing => _isInitializing;

  /// Whether a valid user is currently authenticated.
  bool get isAuthenticated => _currentUser != null;

  /// Whether the authenticated user is a Student.
  bool get isStudentUser =>
      _currentUser != null && _currentUser!.student != null;

  /// Whether the authenticated user is a Teacher / Faculty.
  bool get isTeacherUser =>
      _currentUser != null && _currentUser!.teacher != null;

  /// Whether the authenticated user is a Parent / Guardian.
  bool get isParentUser =>
      _currentUser != null && _currentUser!.parent != null;

  /// Whether the authenticated user has Scope.ORGANIZATION.
  bool get isOrgUser =>
      _currentUser != null &&
      _currentUser!.scope == 'ORGANIZATION' &&
      _currentUser!.student == null &&
      _currentUser!.teacher == null &&
      _currentUser!.parent == null;

  /// Whether the authenticated user has Branch access.
  bool get isBranchUser =>
      _currentUser != null &&
      (_currentUser!.scope == 'BRANCH' || _currentUser!.branchId != null) &&
      _currentUser!.student == null &&
      _currentUser!.teacher == null &&
      _currentUser!.parent == null;

  /// Helper to auto-detect the intended portal based on user model metadata.
  static LoginPortalType detectPortal(UserModel user) {
    if (user.student != null) {
      return LoginPortalType.student;
    }
    if (user.teacher != null) {
      return LoginPortalType.teacher;
    }
    if (user.parent != null) {
      return LoginPortalType.parent;
    }
    if (user.scope == 'BRANCH' || user.branchId != null) {
      return LoginPortalType.branch;
    }
    return LoginPortalType.organization;
  }

  /// Initialize auth state from persistent storage on application startup.
  Future<void> initialize() async {
    _isInitializing = true;

    try {
      final token = TokenStorage.getUserToken();
      if (token != null && token.isNotEmpty) {
        // ApiClient interceptor will automatically attach user token
        _currentUser = await UserRepo.getProfile();
        final savedPortal = TokenStorage.getUserPortal();
        if (savedPortal != null && savedPortal.isNotEmpty) {
          _activePortal = LoginPortalType.values.cast<LoginPortalType?>().firstWhere(
            (p) => p?.name == savedPortal,
            orElse: () => null,
          );
        }
        if (_activePortal == null && _currentUser != null) {
          _activePortal = detectPortal(_currentUser!);
        }
      } else {
        _currentUser = null;
        _activePortal = null;
      }
    } catch (e) {
      debugPrint('[UserAuthService] Initialize failed: $e');
      await TokenStorage.clearAllUserTokens();
      _currentUser = null;
      _activePortal = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Handle successful login event.
  Future<void> login(UserLoginResponse response, {LoginPortalType? portal}) async {
    if (response.accessToken.isNotEmpty) {
      await TokenStorage.setUserToken(response.accessToken);
    }
    if (response.refreshToken.isNotEmpty) {
      await TokenStorage.setUserRefreshToken(response.refreshToken);
    }
    _currentUser = response.user;
    final effectivePortal = portal ?? detectPortal(response.user);
    _activePortal = effectivePortal;
    await TokenStorage.setUserPortal(effectivePortal.name);
    _isInitializing = false;
    notifyListeners();
  }

  /// Handle logout event.
  Future<void> logout() async {
    try {
      await UserRepo.logout();
    } catch (_) {}
    await TokenStorage.clearAllUserTokens();
    ApiClient().clearAuthToken();
    _currentUser = null;
    _activePortal = null;
    _isInitializing = false;
    notifyListeners();
  }
}
