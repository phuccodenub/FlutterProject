import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms_mobile_flutter/features/chat/models/chat_models.dart';
import 'package:lms_mobile_flutter/features/chat/widgets/message_bubble.dart';

// No Dio/network in tests. We inject a fake download implementation instead.

Widget wrapWithApp(Widget child) {
  return EasyLocalization(
    supportedLocales: const [Locale('vi'), Locale('en')],
    path: 'assets/i18n',
    fallbackLocale: const Locale('vi'),
    startLocale: const Locale('vi'),
    child: Builder(
      builder: (ctx) => MaterialApp(
        locale: ctx.locale,
        supportedLocales: ctx.supportedLocales,
        localizationsDelegates: ctx.localizationDelegates,
        home: Scaffold(body: Center(child: child)),
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

  testWidgets('download progress success, error, and local file flows', (tester) async {
    var openedPath = '';
    var openedLocal = '';

    final successMsg = ChatMessage(
      id: 'm1',
      courseId: 'c1',
      senderId: 'u2',
      senderName: 'Alice',
      content: 'file.pdf',
      type: MessageType.text,
      timestamp: DateTime.now(),
      attachments: const [
        MessageAttachment(
          id: 'a1',
          fileName: 'file.pdf',
          fileUrl: 'http://example.com/file.pdf',
          fileType: 'application/pdf',
          fileSize: 1024,
        ),
      ],
    );

    final errorMsg = ChatMessage(
      id: 'm2',
      courseId: 'c1',
      senderId: 'u2',
      senderName: 'Alice',
      content: 'file2.pdf',
      type: MessageType.text,
      timestamp: DateTime.now(),
      attachments: const [
        MessageAttachment(
          id: 'a2',
          fileName: 'file2.pdf',
          fileUrl: 'http://bad.example.com/file2.pdf',
          fileType: 'application/pdf',
          fileSize: 1024,
        ),
      ],
    );

    await tester.pumpWidget(
      wrapWithApp(
        Column(
          children: [
            MessageBubble(
              message: successMsg,
              getTempDir: () async => Directory.systemTemp,
              openFile: (path) async {
                // ignore: avoid_print
                print('TEST: openFile called with: $path');
                openedPath = path;
                return null;
              },
              downloadImpl: (url, savePath, onProgress) async {
                // Simulate two progress ticks then completion
                onProgress(50, 100);
                await Future.delayed(const Duration(milliseconds: 20));
                onProgress(100, 100);
                // ignore: avoid_print
                print('TEST: downloadImpl finished for $savePath');
              },
            ),
            MessageBubble(
              message: errorMsg,
              getTempDir: () async => Directory.systemTemp,
              openFile: (_) async => null,
              downloadImpl: (url, savePath, onProgress) async {
                // Simulate immediate failure
                throw Exception('network down');
              },
            ),
            MessageBubble(
              message: ChatMessage(
                id: 'm3',
                courseId: 'c1',
                senderId: 'u2',
                senderName: 'Alice',
                content: 'local.txt',
                type: MessageType.text,
                timestamp: DateTime.now(),
                attachments: const [
                  MessageAttachment(
                    id: 'a3',
                    fileName: 'local.txt',
                    fileUrl: 'file:///tmp/local.txt',
                    fileType: 'text/plain',
                    fileSize: 12,
                  ),
                ],
              ),
              getTempDir: () async => Directory.systemTemp,
              openFile: (path) async {
                openedLocal = path;
                return null;
              },
            ),
          ],
        ),
      ),
    );

    // Drive success flow
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final downloadBtn1 = find.byKey(const ValueKey('download_a1'));
    expect(downloadBtn1, findsOneWidget);
    await tester.tap(downloadBtn1);
    await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
  // Dialog should be dismissed by now (if shown)
  expect(find.byType(AlertDialog), findsNothing);
    await tester.pump(const Duration(milliseconds: 20));
  expect(openedPath.isNotEmpty, isTrue);

    // Drive error flow
    final downloadBtn2 = find.byKey(const ValueKey('download_a2'));
    expect(downloadBtn2, findsOneWidget);
    await tester.tap(downloadBtn2);
  await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();
  expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);

    // Drive local file flow (should open directly, no dialog)
    await tester.pump(const Duration(milliseconds: 50));
    final downloadBtn3 = find.byKey(const ValueKey('download_a3'));
    expect(downloadBtn3, findsOneWidget);
    await tester.tap(downloadBtn3);
    await tester.pump();
  expect(find.byType(AlertDialog), findsNothing);
  await tester.pump(const Duration(milliseconds: 20));
  expect(openedLocal.isNotEmpty, isTrue);
  });

  // (Moved local file test into the consolidated test below for stability.)
}
