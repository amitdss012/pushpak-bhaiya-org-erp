import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'api/api_client.dart';
import 'app/app.dart';
import 'core/auth/platform_auth_service.dart';
import 'core/auth/token_storage.dart';
import 'core/auth/user_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  try {
    // 1. Initialize persistent storage (localStorage on web, prefs on native)
    await TokenStorage.init();

    // 2. Attach 401 callback to auto-logout on session expiration
    ApiClient().setOnUnauthorizedCallback(() {
      if (PlatformAuthService.instance.isAuthenticated) {
        PlatformAuthService.instance.logout();
      }
      if (UserAuthService.instance.isAuthenticated) {
        UserAuthService.instance.logout();
      }
    });

    // 3. Pre-load auth tokens into ApiClient
    final existingPlatformToken = TokenStorage.getPlatformToken();
    if (existingPlatformToken != null && existingPlatformToken.isNotEmpty) {
      ApiClient().setAuthToken(existingPlatformToken);
    }
    final existingUserToken = TokenStorage.getUserToken();
    if (existingUserToken != null && existingUserToken.isNotEmpty) {
      ApiClient().setAuthToken(existingUserToken);
    }

    // 4. Validate sessions and fetch current user/admin profiles
    await Future.wait([
      PlatformAuthService.instance.initialize(),
      UserAuthService.instance.initialize(),
    ]);
  } catch (e) {
    debugPrint('[Main] Startup initialization error: $e');
  }

  runApp(const PushpakApp());
}
