import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageBackend {
  static const String _platformTokenKey = 'platform_admin_token';
  static const String _userTokenKey = 'user_access_token';
  static const String _userRefreshTokenKey = 'user_refresh_token';
  static const String _userPortalKey = 'user_active_portal';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (_) {}
  }

  static String? getPlatformToken() {
    return _prefs?.getString(_platformTokenKey);
  }

  static Future<bool> setPlatformToken(String token) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.setString(_platformTokenKey, token) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearPlatformToken() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.remove(_platformTokenKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  static String? getUserToken() {
    return _prefs?.getString(_userTokenKey);
  }

  static Future<bool> setUserToken(String token) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.setString(_userTokenKey, token) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserToken() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.remove(_userTokenKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  static String? getUserRefreshToken() {
    return _prefs?.getString(_userRefreshTokenKey);
  }

  static Future<bool> setUserRefreshToken(String token) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.setString(_userRefreshTokenKey, token) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserRefreshToken() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.remove(_userRefreshTokenKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  static String? getUserPortal() {
    return _prefs?.getString(_userPortalKey);
  }

  static Future<bool> setUserPortal(String portal) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.setString(_userPortalKey, portal) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserPortal() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return await _prefs?.remove(_userPortalKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> clearAllUserTokens() async {
    await clearUserToken();
    await clearUserRefreshToken();
    await clearUserPortal();
  }
}
