import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lms_mobile_flutter/core/widgets/section_header.dart';

void main() {
  testWidgets('SectionHeader renders title and action', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Title',
            action: 'See all',
            onActionPressed: null, // No button without callback
            icon: Icons.star,
          ),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);

    // When onActionPressed is null, action button should not appear
    expect(find.text('See all'), findsNothing);

    // With action
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Title',
            action: 'See all',
            onActionPressed: () => tapped = true,
            icon: Icons.star,
          ),
        ),
      ),
    );

    expect(find.text('See all'), findsOneWidget);
    await tester.tap(find.text('See all'));
    expect(tapped, true);
  });
}
