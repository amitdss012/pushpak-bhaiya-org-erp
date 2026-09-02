import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/provider/query_provider.dart';
import '../core/utils/toast_utils.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root application widget with Flutter Query provider, system theme detection, and GoRouter.
class PushpakApp extends StatelessWidget {
  const PushpakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppQueryProvider(
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
