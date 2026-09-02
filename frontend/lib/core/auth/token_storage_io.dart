import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageBackend {
  static const String _platformTokenKey = 'platform_admin_token';
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
}
