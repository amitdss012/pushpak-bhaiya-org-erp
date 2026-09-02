import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'api/api_client.dart';
import 'app/app.dart';
import 'core/auth/platform_auth_service.dart';
import 'core/auth/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  try {
    // 1. Initialize persistent storage (localStorage on web, prefs on native)
    await TokenStorage.init();

    // 2. Attach 401 callback to auto-logout on session expiration
    ApiClient().setOnUnauthorizedCallback(() {
      PlatformAuthService.instance.logout();
    });

    // 3. Pre-load auth token into ApiClient immediately
    final existingToken = TokenStorage.getPlatformToken();
    if (existingToken != null && existingToken.isNotEmpty) {
      ApiClient().setAuthToken(existingToken);
    }

    // 4. Validate session and fetch current admin profile
    await PlatformAuthService.instance.initialize();
  } catch (e) {
    debugPrint('[Main] Startup initialization error: $e');
  }

  runApp(const PushpakApp());
}
