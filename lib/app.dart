import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/notification_provider.dart';

import 'features/auth/auth_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'features/chatbot/chatbot_widget.dart';
import 'routes/app_router.dart';
import 'features/admin/system/system_settings_provider.dart';

// Dismiss state for the debug mode banner
final debugBannerDismissedProvider = StateProvider<bool>((_) => false);

class LMSApp extends ConsumerWidget {
  const LMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);
  final systemSettings = ref.watch(systemSettingsProvider);
  final debugDismissed = ref.watch(debugBannerDismissedProvider);

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
          // Ensure auth state initialized
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(authProvider.notifier).initialize();
            
            // Initialize notifications when app starts
            ref.read(notificationProvider.notifier).initializeNotifications();
          });
          // Demo banner (similar to FE banner)
          final isDemo = AppConfig.of(context).demoMode;
          return Stack(
            children: [
              if (child != null) child,
              if (systemSettings.debugMode && !debugDismissed)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            // Reuse existing key for localization label
                            tr('systemSettings.debugMode'),
                            key: const ValueKey('debug_mode_chip_text'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Avoid Tooltip here because this subtree is built in
                        // MaterialApp.builder context (above Navigator Overlay),
                        // which would trigger "No Overlay widget found" in Flutter >= 3.22.
                        // The debug chip is a dev-only control, so we drop the tooltip to
                        // prevent crashes on startup.
                        IconButton(
                          key: const ValueKey('debug_mode_chip_close'),
                          icon: const Icon(Icons.close, size: 16),
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                          onPressed: () =>
                              ref.read(debugBannerDismissedProvider.notifier).state = true,
                          // tooltip: 'Dismiss', // Removed: would require an Overlay ancestor
                        ),
                      ],
                    ),
                  ),
                ),
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
              const ChatbotFloating(),
            ],
          );
        },
      ),
    );
  }
}
