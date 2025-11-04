import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'routes/app_router.dart';

class LMSApp extends ConsumerWidget {
  const LMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);

    return OverlaySupport.global(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: theme.lightTheme,
        darkTheme: theme.darkTheme,
        themeMode: theme.mode,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        builder: (context, child) {
          // Ensure auth state initialized (demo)
          ref.read(authProvider.notifier).initializeDemo();
          // Demo banner (similar to FE banner)
          final isDemo = AppConfig.of(context).demoMode;
          return Stack(
            children: [
              if (child != null) child,
              if (isDemo)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        'Demo Mode',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),

              // Floating AI chatbot - Now inside MaterialApp context
            ],
          );
        },
      ),
    );
  }
}
