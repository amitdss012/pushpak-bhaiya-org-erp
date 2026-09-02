import 'token_storage_io.dart'
    if (dart.library.html) 'token_storage_web.dart';

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
}
