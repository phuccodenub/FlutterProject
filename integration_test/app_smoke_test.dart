import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lms_mobile_flutter/core/widgets/section_header.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SectionHeader renders and responds to tap on device', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Integration Header',
            action: 'Action',
            onActionPressed: null,
            icon: Icons.check,
          ),
        ),
      ),
    );

    // Should render on device
    expect(find.text('Integration Header'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    // Rebuild with action enabled
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Integration Header',
            action: 'Action',
            onActionPressed: () => tapped = true,
            icon: Icons.check,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Action'), findsOneWidget);
    await tester.tap(find.text('Action'));
    expect(tapped, true);
  });
}
