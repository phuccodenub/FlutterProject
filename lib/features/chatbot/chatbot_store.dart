import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatbotMessage {
  const ChatbotMessage({
    required this.id,
    required this.type,
    required this.content,
  });
  final String id; // msg-xxx
  final String type; // user | bot
  final String content;
}

class ChatbotState {
  const ChatbotState({this.messages = const []});
  final List<ChatbotMessage> messages;
}

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  ChatbotNotifier() : super(const ChatbotState());

  void send(String text) {
    final msgs = List<ChatbotMessage>.from(state.messages)
      ..add(
        ChatbotMessage(
          id: 'user-${DateTime.now().millisecondsSinceEpoch}',
          type: 'user',
          content: text,
        ),
      );
    state = ChatbotState(messages: msgs);
    Future.delayed(const Duration(milliseconds: 600), () {
      final reply = ChatbotMessage(
        id: 'bot-${DateTime.now().millisecondsSinceEpoch}',
        type: 'bot',
        content: 'Bạn hỏi: "$text"\nĐây là phản hồi demo của trợ lý.',
      );
      state = ChatbotState(
        messages: List<ChatbotMessage>.from(state.messages)..add(reply),
      );
    });
  }
}

final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>(
  (ref) => ChatbotNotifier(),
);
