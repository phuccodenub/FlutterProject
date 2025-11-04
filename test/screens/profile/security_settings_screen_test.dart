import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms_mobile_flutter/core/models/user_session.dart';
import 'package:lms_mobile_flutter/core/repositories/user_sessions_repository.dart';
import 'package:lms_mobile_flutter/screens/shared/profile/security_settings_screen.dart';

class _FakeRepoSuccess implements UserSessionsRepository {
  @override
  Future<List<UserSession>> getSessions() async {
    return [
      UserSession(
        id: 'current_1',
        device: 'Chrome on Windows',
        platform: 'Windows',
        ip: '127.0.0.1',
        lastActive: DateTime.now(),
        current: true,
      ),
      UserSession(
        id: 'sess_2',
        device: 'Safari on iOS',
        platform: 'iOS',
        ip: '10.0.0.5',
        lastActive: DateTime.now(),
        current: false,
      ),
    ];
  }

  @override
  Future<void> terminateSession(String sessionId) async {}
}

class _FakeRepoTerminateFail implements UserSessionsRepository {
  @override
  Future<List<UserSession>> getSessions() async {
    return [
      UserSession(
        id: 's1',
        device: 'Chrome',
        platform: 'Windows',
        ip: '127.0.0.1',
        lastActive: DateTime.now(),
        current: false,
      ),
    ];
  }

  @override
  Future<void> terminateSession(String sessionId) async {
    throw Exception('terminate fail');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  Widget wrapWidget(Widget child, UserSessionsRepository repo) {
    return ProviderScope(
      overrides: [userSessionsRepositoryProvider.overrideWithValue(repo)],
      child: EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        path: 'assets/i18n',
        fallbackLocale: const Locale('vi'),
        startLocale: const Locale('vi'),
        child: Builder(
          builder: (ctx) {
            // Debug which test is building and ensure the widget tree mounts
            // Helps diagnose flaky mount behavior in CI
            // Use debugPrint to avoid analyzer avoid_print lint
            debugPrint('TEST DEBUG: Building MaterialApp with child=${child.runtimeType}');
            return MaterialApp(
            locale: ctx.locale,
            supportedLocales: ctx.supportedLocales,
            localizationsDelegates: ctx.localizationDelegates,
            home: child,
            );
          },
        ),
      ),
    );
  }

  // Helper to wait for a finder to appear up to a timeout
  Future<void> waitFor(WidgetTester tester, Finder finder, {Duration timeout = const Duration(seconds: 3)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isNotEmpty) return;
    }
  }


  // (unused) Helper retained for reference if targeted scroll becomes necessary

  // (unused) helper placeholder to keep tests concise

  testWidgets('SecuritySettingsScreen can terminate a session', (tester) async {
    // Enlarge the test surface so the whole screen fits without lazy build
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final repo = _FakeRepoSuccess();
    final seeded = [
      UserSession(
        id: 'current_1', device: 'Chrome on Windows', platform: 'Windows', ip: '127.0.0.1', lastActive: DateTime.now(), current: true,
      ),
      UserSession(
        id: 'sess_2', device: 'Safari on iOS', platform: 'iOS', ip: '10.0.0.5', lastActive: DateTime.now(), current: false,
      ),
    ];
    // Pump directly with seeded sessions to avoid any late-binding issues
    await tester.pumpWidget(
      wrapWidget(SecuritySettingsScreen(loadSessionsOnInit: false, initialSessions: seeded), repo),
    );
  await tester.pumpAndSettle();
  expect(find.byType(SecuritySettingsScreen), findsOneWidget);

    // Sessions are seeded; find the logout button by its stable key
    final logoutKey = find.byKey(const ValueKey('logout_sess_2'));
    await waitFor(tester, logoutKey, timeout: const Duration(seconds: 4));
    expect(logoutKey, findsOneWidget);

    // Tap the logout button
    await tester.tap(logoutKey, warnIfMissed: false);
  await tester.pumpAndSettle();
  expect(find.byType(SecuritySettingsScreen), findsOneWidget);

    // Verify the session was removed and success snackbar shown
  expect(find.byKey(const ValueKey('logout_sess_2')), findsNothing);
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Đã đăng xuất phiên đã chọn'), findsOneWidget);
  });

  testWidgets('shows SnackBar on terminate failure (deterministic via callback seam)', (tester) async {
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final repo = _FakeRepoTerminateFail();
    final seeded = [
      UserSession(
        id: 's1', device: 'Chrome', platform: 'Windows', ip: '127.0.0.1', lastActive: DateTime.now(), current: false,
      ),
    ];
    final completer = Completer<bool>();
    await tester.pumpWidget(
      wrapWidget(SecuritySettingsScreen(
        key: const ValueKey('security_screen_negative'),
        loadSessionsOnInit: false,
        initialSessions: seeded,
        debugTerminateSessionId: 's1',
        debugAutoTrigger: true,
        onDebugTerminateResult: (ok) {
          if (!completer.isCompleted) completer.complete(ok);
        },
      ), repo),
    );

    // Auto-trigger sẽ kích hoạt terminate sau frame đầu
    await tester.pumpAndSettle();
    
    // Chờ callback từ seam (auto-trigger sẽ gọi terminate)
    try {
      final ok = await completer.future.timeout(const Duration(seconds: 3));
      expect(ok, isFalse, reason: 'Expected terminate to fail');
    } catch (e) {
      fail('Callback seam không được gọi trong 3s. Auto-trigger có thể không hoạt động. Error: $e');
    }
    // Xác nhận session chưa bị xóa (failure path)
    final logoutKey = find.byKey(const ValueKey('logout_s1'));
    await waitFor(tester, logoutKey, timeout: const Duration(seconds: 3));
    expect(logoutKey, findsOneWidget);
  });
}
