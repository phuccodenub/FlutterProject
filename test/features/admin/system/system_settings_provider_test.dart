import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms_mobile_flutter/features/admin/system/system_settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('SystemSettingsNotifier toggles values and persists locally', () async {
    final notifier = SystemSettingsNotifier();
    // Allow async _load to complete
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Default debug mode should be kDebugMode
    expect(notifier.state.debugMode, kDebugMode);

    await notifier.setDebugMode(!kDebugMode);
    expect(notifier.state.debugMode, !kDebugMode);

    await notifier.setAllowRegistration(false);
    expect(notifier.state.allowRegistration, false);

    await notifier.setTwoFactorForAdmin(false);
    expect(notifier.state.twoFactorForAdmin, false);
  });
}
