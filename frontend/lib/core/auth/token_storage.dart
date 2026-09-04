import 'token_storage_io.dart' if (dart.library.html) 'token_storage_web.dart';

/// Rock-solid persistent storage for authentication tokens across all platforms.
/// Uses direct HTML5 localStorage on Web and SharedPreferences on Native.
class TokenStorage {
  static String? _inMemoryToken;

  TokenStorage._();

  /// Initialize persistent storage on startup.
  static Future<void> init() async {
    try {
      await TokenStorageBackend.init();
    } catch (_) {}
  }

  /// Retrieve the stored platform token.
  static String? getPlatformToken() {
    try {
      final token = TokenStorageBackend.getPlatformToken();
      if (token != null && token.isNotEmpty) {
        _inMemoryToken = token;
        return token;
      }
    } catch (_) {}
    return _inMemoryToken;
  }

  /// Save the platform token.
  static Future<bool> setPlatformToken(String token) async {
    _inMemoryToken = token;
    try {
      return await TokenStorageBackend.setPlatformToken(token);
    } catch (_) {
      return true;
    }
  }

  /// Clear the platform token.
  static Future<bool> clearPlatformToken() async {
    _inMemoryToken = null;
    try {
      return await TokenStorageBackend.clearPlatformToken();
    } catch (_) {
      return true;
    }
  }

  /// Retrieve the stored user access token.
  static String? getUserToken() {
    try {
      final token = TokenStorageBackend.getUserToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}
    return null;
  }

  /// Save the user access token.
  static Future<bool> setUserToken(String token) async {
    try {
      return await TokenStorageBackend.setUserToken(token);
    } catch (_) {
      return true;
    }
  }

  /// Clear the user access token.
  static Future<bool> clearUserToken() async {
    try {
      return await TokenStorageBackend.clearUserToken();
    } catch (_) {
      return true;
    }
  }

  /// Retrieve the stored user refresh token.
  static String? getUserRefreshToken() {
    try {
      final token = TokenStorageBackend.getUserRefreshToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {}
    return null;
  }

  /// Save the user refresh token.
  static Future<bool> setUserRefreshToken(String token) async {
    try {
      return await TokenStorageBackend.setUserRefreshToken(token);
    } catch (_) {
      return true;
    }
  }

  /// Clear the user refresh token.
  static Future<bool> clearUserRefreshToken() async {
    try {
      return await TokenStorageBackend.clearUserRefreshToken();
    } catch (_) {
      return true;
    }
  }

  /// Retrieve the stored user active portal ('organization', 'branch', 'student').
  static String? getUserPortal() {
    try {
      return TokenStorageBackend.getUserPortal();
    } catch (_) {
      return null;
    }
  }

  /// Save the user active portal.
  static Future<bool> setUserPortal(String portal) async {
    try {
      return await TokenStorageBackend.setUserPortal(portal);
    } catch (_) {
      return true;
    }
  }

  /// Clear the stored user active portal.
  static Future<bool> clearUserPortal() async {
    try {
      return await TokenStorageBackend.clearUserPortal();
    } catch (_) {
      return true;
    }
  }

  /// Clear all user-related tokens (access, refresh, and active portal).
  static Future<void> clearAllUserTokens() async {
    try {
      await TokenStorageBackend.clearAllUserTokens();
    } catch (_) {}
  }
}
