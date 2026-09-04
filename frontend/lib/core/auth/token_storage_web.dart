// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TokenStorageBackend {
  static const String _platformTokenKey = 'platform_admin_token';
  static const String _userTokenKey = 'user_access_token';
  static const String _userRefreshTokenKey = 'user_refresh_token';
  static const String _userPortalKey = 'user_active_portal';

  static Future<void> init() async {}

  static String? getPlatformToken() {
    try {
      return html.window.localStorage[_platformTokenKey];
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setPlatformToken(String token) async {
    try {
      html.window.localStorage[_platformTokenKey] = token;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearPlatformToken() async {
    try {
      html.window.localStorage.remove(_platformTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String? getUserToken() {
    try {
      return html.window.localStorage[_userTokenKey];
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setUserToken(String token) async {
    try {
      html.window.localStorage[_userTokenKey] = token;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserToken() async {
    try {
      html.window.localStorage.remove(_userTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String? getUserRefreshToken() {
    try {
      return html.window.localStorage[_userRefreshTokenKey];
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setUserRefreshToken(String token) async {
    try {
      html.window.localStorage[_userRefreshTokenKey] = token;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserRefreshToken() async {
    try {
      html.window.localStorage.remove(_userRefreshTokenKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String? getUserPortal() {
    try {
      return html.window.localStorage[_userPortalKey];
    } catch (_) {
      return null;
    }
  }

  static Future<bool> setUserPortal(String portal) async {
    try {
      html.window.localStorage[_userPortalKey] = portal;
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearUserPortal() async {
    try {
      html.window.localStorage.remove(_userPortalKey);
      return true;
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
