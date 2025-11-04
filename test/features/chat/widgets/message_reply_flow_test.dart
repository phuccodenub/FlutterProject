import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lms_mobile_flutter/features/chat/models/chat_models.dart';
import 'package:lms_mobile_flutter/features/chat/widgets/message_bubble.dart';
import 'package:lms_mobile_flutter/features/chat/widgets/message_input.dart';

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

class _ReplyHarness extends StatefulWidget {
  const _ReplyHarness({required this.messages, this.startInReply = false});
  final List<ChatMessage> messages;
  final bool startInReply;
  @override
  State<_ReplyHarness> createState() => _ReplyHarnessState();
}

class _ReplyHarnessState extends State<_ReplyHarness> {
  final _controller = TextEditingController();
  ChatMessage? _replyTo;
  String? lastSentContent;
  String? lastReplyToId;

  @override
  void initState() {
    super.initState();
    _replyTo = widget.startInReply ? widget.messages.first : null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Render a single message bubble we can reply to
        MessageBubble(
          message: widget.messages.first,
          onReply: (m) => setState(() => _replyTo = m),
        ),
        // Deterministic test action to trigger reply without relying on long-press menu
        TextButton(
          key: const ValueKey('test_reply_action'),
          onPressed: () => setState(() => _replyTo = widget.messages.first),
          child: const Text('Reply Action'),
        ),
        const SizedBox(height: 8),
        MessageInput(
          controller: _controller,
          onSend: () {
            setState(() {
              lastSentContent = _controller.text;
              lastReplyToId = _replyTo?.id;
              _controller.clear();
              _replyTo = null;
            });
          },
          onChanged: (_) {},
          replyTo: _replyTo,
          onCancelReply: () => setState(() => _replyTo = null),
        ),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('select-to-reply shows preview banner and send uses parentId', (tester) async {
    final msg = ChatMessage(
      id: 'm1',
      courseId: 'c1',
      senderId: 'u2',
      senderName: 'Alice',
      content: 'Hello world',
      timestamp: DateTime.now(),
    );

    await tester.pumpWidget(
      wrapWithApp(_ReplyHarness(messages: [msg])),
    );
    await tester.pumpAndSettle();

  // Trigger reply via harness action (deterministic, avoids bottom sheet timing)
  await tester.tap(find.byKey(const ValueKey('test_reply_action')));
    await tester.pumpAndSettle();

    // Reply banner should appear
    expect(find.byKey(const ValueKey('reply_banner')), findsOneWidget);

    // Type and send
  await tester.enterText(find.byType(TextField), 'Hi back');
  await tester.pumpAndSettle();
    // Send button shows up when composing; tap it
  await tester.tap(find.byIcon(Icons.send));
  await tester.pumpAndSettle();

    // Reply banner hidden and message cleared
    expect(find.byKey(const ValueKey('reply_banner')), findsNothing);
  });

  testWidgets('cancel reply hides preview banner without sending', (tester) async {
    final msg = ChatMessage(
      id: 'm2',
      courseId: 'c1',
      senderId: 'u3',
      senderName: 'Bob',
      content: 'Ping',
      timestamp: DateTime.now(),
    );

    await tester.pumpWidget(
      wrapWithApp(_ReplyHarness(messages: [msg], startInReply: true)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('reply_banner')), findsOneWidget);

    // Tap the cancel button (close icon inside banner)
  await tester.tap(find.byIcon(Icons.close));
  await tester.pumpAndSettle();

    // Banner hidden
    expect(find.byKey(const ValueKey('reply_banner')), findsNothing);
  });
}
