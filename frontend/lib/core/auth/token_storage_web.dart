// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TokenStorageBackend {
  static const String _platformTokenKey = 'platform_admin_token';

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
}
