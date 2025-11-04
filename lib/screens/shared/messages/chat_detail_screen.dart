import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_app_bar.dart';
import '../../../features/chat/chat_store.dart';
import '../../../features/auth/auth_state.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textCtl = TextEditingController();
  final ScrollController _scrollCtl = ScrollController();

  @override
  void dispose() {
    _textCtl.dispose();
    _scrollCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseId = widget.courseId;
    final auth = ref.watch(authProvider);
    final currentUserId = auth.user?.id ?? 101;
    final currentUserName = auth.user?.fullName ?? 'Bạn';

    final chat = ref.watch(chatProvider);
    final messages = List<ChatMessage>.from(
      chat.messagesByCourse[courseId] ?? const [],
    )..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Scaffold(
      appBar: CommonAppBar(
        titleWidget: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.group,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Khóa học $courseId',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Đang hoạt động',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Gọi thoại',
            icon: const Icon(Icons.call_outlined),
            onPressed: () => _showToast(context, 'Gọi thoại (coming soon)'),
          ),
          IconButton(
            tooltip: 'Gọi video',
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () => _showToast(context, 'Gọi video (coming soon)'),
          ),
        ],
        showNotificationsAction: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtl,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMine = msg.userId == currentUserId;
                return _ChatBubble(message: msg, isMine: isMine);
              },
            ),
          ),
          const Divider(height: 1),
          _InputArea(
            controller: _textCtl,
            onAttach: () => _showToast(context, 'Đính kèm (coming soon)'),
            onSend: () {
              final text = _textCtl.text.trim();
              if (text.isEmpty) return;
              ref
                  .read(chatProvider.notifier)
                  .sendMessage(courseId, currentUserId, currentUserName, text);
              _textCtl.clear();
              // Auto scroll a bit after sending
              Future.delayed(const Duration(milliseconds: 100), () {
                if (_scrollCtl.hasClients) {
                  _scrollCtl.animateTo(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.isMine});
  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final textColor = isMine ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isMine ? 12 : 2),
                      bottomRight: Radius.circular(isMine ? 2 : 12),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes}p';
    if (diff.inHours < 24) return '${diff.inHours}g';
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}';
  }
}

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.onAttach,
    required this.onSend,
  });
  final TextEditingController controller;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Đính kèm',
              icon: const Icon(Icons.attach_file_outlined),
              onPressed: onAttach,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Gửi',
              icon: const Icon(Icons.send_rounded),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
