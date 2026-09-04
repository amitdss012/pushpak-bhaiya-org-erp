import 'package:flutter/foundation.dart';

import '../../api/api_client.dart';
import '../../api/models/models.dart';
import '../../api/repo/platfrom/platform_auth_repo.dart';
import 'token_storage.dart';

/// Global reactive authentication service for Platform Admin.
/// Extends [ChangeNotifier] to drive reactive GoRouter redirect guards.
class PlatformAuthService extends ChangeNotifier {
  static final PlatformAuthService instance = PlatformAuthService._internal();

  PlatformAdminModel? _currentAdmin;
  bool _isInitializing = true;

  PlatformAuthService._internal();

  /// The currently authenticated platform admin profile, or null.
  PlatformAdminModel? get currentAdmin => _currentAdmin;

  /// Whether the initial authentication check is in progress.
  bool get isInitializing => _isInitializing;

  /// Whether a valid platform admin is currently authenticated.
  bool get isAuthenticated => _currentAdmin != null;

  /// Initialize auth state from persistent storage on application startup.
  Future<void> initialize() async {
    _isInitializing = true;

    try {
      final token = TokenStorage.getPlatformToken();
      if (token != null && token.isNotEmpty) {
        ApiClient().setAuthToken(token);
        _currentAdmin = await PlatformAuthRepo.getProfile();
      } else {
        _currentAdmin = null;
      }
    } catch (e) {
      debugPrint('[PlatformAuthService] Initialize failed: $e');
      await TokenStorage.clearPlatformToken();
      ApiClient().clearAuthToken();
      _currentAdmin = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Handle successful login event.
  Future<void> login(PlatformLoginResponse response) async {
    if (response.token.isNotEmpty) {
      await TokenStorage.setPlatformToken(response.token);
      ApiClient().setAuthToken(response.token);
    }
    _currentAdmin = response.admin;
    _isInitializing = false;
    notifyListeners();
  }

  bool _isLoggingOut = false;

  /// Handle logout event safely and idempotently.
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      final token = TokenStorage.getPlatformToken();
      if (token != null && token.isNotEmpty) {
        await PlatformAuthRepo.logout();
      }
    } catch (e) {
      debugPrint('[PlatformAuthService] Logout request exception ignored: $e');
    } finally {
      await TokenStorage.clearPlatformToken();
      ApiClient().clearAuthToken();
      _currentAdmin = null;
      _isInitializing = false;
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
