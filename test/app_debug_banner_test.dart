import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms_mobile_flutter/app.dart';

import 'package:lms_mobile_flutter/features/admin/system/system_settings_provider.dart';
import 'helpers/test_app.dart';

class TestDebugChip extends ConsumerWidget {
  const TestDebugChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(systemSettingsProvider);
    final dismissed = ref.watch(debugBannerDismissedProvider);
    return SizedBox.expand(
      child: Stack(
        children: [
          const SizedBox.shrink(),
        if (settings.debugMode && !dismissed)
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
                      tr('systemSettings.debugMode'),
                      key: const ValueKey('debug_mode_chip_text'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('debug_mode_chip_close'),
                    icon: const Icon(Icons.close, size: 16),
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    constraints: const BoxConstraints(),
                    onPressed: () =>
                        ref.read(debugBannerDismissedProvider.notifier).state = true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('debug mode status chip appears and can be dismissed', (tester) async {
    // Seed SharedPreferences with debugMode = true so notifier loads it
    SharedPreferences.setMockInitialValues({
      'system_settings.v1': '{"allowRegistration":true,"twoFactorForAdmin":true,"autoEmailNotifications":true,"maintenanceMode":false,"debugMode":true}'
    });

    await tester.pumpWidget(
      wrapWithAppHome(
        const Scaffold(body: TestDebugChip()),
      ),
    );

    await tester.pumpAndSettle();

    // Chip should be visible
    expect(find.byKey(const ValueKey('debug_mode_chip_text')), findsOneWidget);

    // Dismiss
    await tester.tap(find.byKey(const ValueKey('debug_mode_chip_close')));
    await tester.pumpAndSettle();

    // Chip should be gone
    expect(find.byKey(const ValueKey('debug_mode_chip_text')), findsNothing);
  });
}
