import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lms_mobile_flutter/screens/admin/courses/course_management_screen.dart';
import 'package:lms_mobile_flutter/features/admin/courses/admin_course_list_provider.dart' as courses;
import '../../../helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('courses: pagination buttons and filter clear reset', (tester) async {
    courses.AdminCourseList makeList(int page) => courses.AdminCourseList(
          const [],
          courses.Pagination(
            page: page,
            limit: 10,
            total: 25,
            totalPages: 3,
            hasNext: page < 3,
            hasPrev: page > 1,
          ),
        );

    await tester.pumpWidget(
      wrapWithScaffoldBody(
        const CourseManagementScreen(),
        overrides: [
          courses.adminCourseListProvider.overrideWithProvider((filter) {
            return FutureProvider((ref) async => makeList(filter.page));
          }),
        ],
      ),
    );

    await tester.pump();
    // Wait briefly for provider to resolve and list to render
    final prevFinder = find.byKey(const ValueKey('courses_pagination_prev'));
    for (var i = 0; i < 40 && prevFinder.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }

  // Initial pagination: prev disabled, next enabled
  final nextFinder = find.byKey(const ValueKey('courses_pagination_next'));
  expect(prevFinder, findsOneWidget);
  expect(nextFinder, findsOneWidget);
  final prevBtn1 = tester.widget<TextButton>(prevFinder);
  final nextBtn1 = tester.widget<TextButton>(nextFinder);
    expect(prevBtn1.onPressed, isNull);
    expect(nextBtn1.onPressed, isNotNull);

    // Go to page 2
  await tester.tap(find.byKey(const ValueKey('courses_pagination_next')));
  await tester.pump(const Duration(milliseconds: 100));
  expect(prevFinder, findsOneWidget);
  expect(nextFinder, findsOneWidget);
  final prevBtn2 = tester.widget<TextButton>(prevFinder);
  final nextBtn2 = tester.widget<TextButton>(nextFinder);
    expect(prevBtn2.onPressed, isNotNull);
    expect(nextBtn2.onPressed, isNotNull);

    // Go to page 3 (last)
  await tester.tap(find.byKey(const ValueKey('courses_pagination_next')));
  await tester.pump(const Duration(milliseconds: 100));
  expect(prevFinder, findsOneWidget);
  expect(nextFinder, findsOneWidget);
  final prevBtn3 = tester.widget<TextButton>(prevFinder);
  final nextBtn3 = tester.widget<TextButton>(nextFinder);
    expect(prevBtn3.onPressed, isNotNull);
    expect(nextBtn3.onPressed, isNull);

    // Open filter and apply to show summary
    await tester.tap(find.byIcon(Icons.filter_list));
  await tester.pump(const Duration(milliseconds: 150));
    await tester.tap(find.text('Áp dụng'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Summary should appear
    expect(find.byKey(const ValueKey('filters_summary_text')), findsOneWidget);

    // Clear filters
    await tester.tap(find.byKey(const ValueKey('filters_clear')));
  await tester.pump(const Duration(milliseconds: 200));

    // Summary should disappear
    expect(find.byKey(const ValueKey('filters_summary_text')), findsNothing);
  });
}
