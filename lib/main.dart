import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/error/global_error_handler.dart';
import 'core/services/device_info_service.dart';
import 'features/notifications/local_notification_service.dart';
import 'features/notifications/firebase_messaging_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Global Error Handler
  GlobalErrorHandler.initialize();

  // Set custom error widget builder
  ErrorWidget.builder = CustomErrorWidget.builder;

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Local Notifications
  final notificationService = LocalNotificationService();
  await notificationService.initialize();
  await notificationService.requestPermission();

  // Initialize Device Info Service
  final deviceInfoService = DeviceInfoService();
  await deviceInfoService.initialize();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization warning: $e');
    // Continue even if Firebase fails (might be in demo mode)
  }

  // Initialize Firebase Messaging Service
  final fcmService = FirebaseMessagingService();
  await fcmService.initialize();

  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
  const socketUrl = String.fromEnvironment('SOCKET_URL', defaultValue: 'http://localhost:3000');
  const demo = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: ProviderScope(
        child: AppConfig(
          apiBaseUrl: apiBaseUrl,
          socketUrl: socketUrl,
          demoMode: demo,
          child: const LMSApp(),
        ),
      ),
    ),
  );
}
