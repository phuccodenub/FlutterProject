import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms_mobile_flutter/core/models/user_session.dart';
import 'package:lms_mobile_flutter/core/repositories/user_sessions_repository.dart';
import 'package:lms_mobile_flutter/screens/shared/profile/security_settings_screen.dart';

class _FakeRepoLoadFail implements UserSessionsRepository {
  @override
  Future<List<UserSession>> getSessions() async {
    throw Exception('load fail');
  }

  @override
  Future<void> terminateSession(String sessionId) async {}
}

// Removed unused fake terminate repo; the test below uses Dio interceptors with the default repository

Widget wrapWithApp(UserSessionsRepository repo) {
  return ProviderScope(
    overrides: [userSessionsRepositoryProvider.overrideWithValue(repo)],
    child: EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: Builder(
        builder: (ctx) => MaterialApp(
          locale: ctx.locale,
          supportedLocales: ctx.supportedLocales,
          localizationsDelegates: ctx.localizationDelegates,
          home: const SecuritySettingsScreen(),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('shows SnackBar on sessions load failure', (tester) async {
    await tester.pumpWidget(wrapWithApp(_FakeRepoLoadFail()));
    // Allow initial frame + async load
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SnackBar), findsOneWidget);
  });

  // Moved terminate-failure case into security_settings_screen_test.dart to avoid
  // cross-file concurrency flakiness. This file keeps only the load-failure case.
}
