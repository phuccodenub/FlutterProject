import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/chat_models.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/message_input.dart';

/// Chat Screen for Course Discussions
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  final String courseId;
  final String courseName;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isComposing = false;
  ChatMessage? _replyTo;

  @override
  void initState() {
    super.initState();

    // Join course room and load messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).joinCourseRoom(widget.courseId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();

    // Leave course room
    ref.read(chatProvider.notifier).leaveCourseRoom(widget.courseId);
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) {
      return;
    }

    // Clear input immediately
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    // Send message
    await ref
        .read(chatProvider.notifier)
        .sendMessage(
          courseId: widget.courseId,
          content: content,
          replyToId: _replyTo?.id,
        );

    // Clear reply state after sending
    if (mounted) {
      setState(() {
        _replyTo = null;
      });
    }

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _onMediaSelected(File file) async {
    try {
      final filename = p.basename(file.path);
      final ext = p.extension(file.path).toLowerCase().replaceAll('.', '');
      final fileSize = await file.length();

      String mime = _mimeFromExt(ext);

      // Build attachment referencing local file path; downloader will open directly
      final attachment = MessageAttachment(
        id: 'att-${DateTime.now().millisecondsSinceEpoch}',
        fileName: filename,
        fileUrl: 'file://${file.path}',
        fileType: mime,
        fileSize: fileSize,
      );

      // Send as a text message with attachment so UI shows attachments section
      await ref
          .read(chatProvider.notifier)
          .sendMessage(
            courseId: widget.courseId,
            content: filename,
            type: MessageType.text,
            replyToId: _replyTo?.id,
            attachments: [attachment],
          );

      if (mounted) {
        setState(() {
          _replyTo = null;
          _isComposing = false;
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể gửi tệp: $e')));
    }
  }

  String _mimeFromExt(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'mp4':
      case 'mov':
      case 'm4v':
        return 'video/mp4';
      case 'mp3':
      case 'm4a':
        return 'audio/mpeg';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  void _onMessageChanged(String text) {
    final isComposing = text.isNotEmpty;
    if (_isComposing != isComposing) {
      setState(() {
        _isComposing = isComposing;
      });

      // Send typing indicator
      ref
          .read(chatProvider.notifier)
          .sendTypingIndicator(widget.courseId, isComposing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(currentCourseMessagesProvider(widget.courseId));
    final isLoading = ref.watch(chatLoadingProvider);
    final error = ref.watch(chatErrorProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);
    final typingUsers = ref.watch(typingUsersProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.courseName, style: const TextStyle(fontSize: 16)),
            Text(
              _getConnectionStatusText(connectionStatus),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show chat info
              _showChatInfo(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status banner
          if (connectionStatus == 'disconnected' || connectionStatus == 'error')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange,
              child: Text(
                connectionStatus == 'error'
                    ? 'Lỗi kết nối - Đang thử kết nối lại...'
                    : 'Mất kết nối - Đang thử kết nối lại...',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

          // Messages list
          Expanded(
            child: _buildMessagesList(messages, isLoading, error, typingUsers),
          ),

          // Message input
          MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
            onChanged: _onMessageChanged,
            isComposing: _isComposing,
            replyTo: _replyTo,
            onCancelReply: () {
              setState(() {
                _replyTo = null;
              });
            },
            onMediaSelected: _onMediaSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    List<ChatMessage> messages,
    bool isLoading,
    String? error,
    List<String> typingUsers,
  ) {
    if (isLoading && messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Lỗi tải tin nhắn',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(chatProvider.notifier)
                    .loadCourseMessages(widget.courseId);
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Chưa có tin nhắn',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Hãy bắt đầu cuộc trò chuyện!'),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (typingUsers.isNotEmpty ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          // Typing indicator at the end
          return TypingIndicator(typingUsers: typingUsers);
        }

        final message = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;
        final nextMessage = index < messages.length - 1
            ? messages[index + 1]
            : null;

        // Group messages by date
        bool showDateSeparator = false;
        if (previousMessage == null) {
          showDateSeparator = true;
        } else {
          final currentDate = DateTime(
            message.timestamp.year,
            message.timestamp.month,
            message.timestamp.day,
          );
          final previousDate = DateTime(
            previousMessage.timestamp.year,
            previousMessage.timestamp.month,
            previousMessage.timestamp.day,
          );
          showDateSeparator = !currentDate.isAtSameMomentAs(previousDate);
        }

        return Column(
          children: [
            if (showDateSeparator) _buildDateSeparator(message.timestamp),

            MessageBubble(
              message: message,
              showAvatar: _shouldShowAvatar(
                message,
                previousMessage,
                nextMessage,
              ),
              onReply: (message) => _replyToMessage(message),
              onMarkAsRead: () => _markAsRead(message),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate.isAtSameMomentAs(today)) {
      dateText = 'Hôm nay';
    } else if (messageDate.isAtSameMomentAs(
      today.subtract(const Duration(days: 1)),
    )) {
      dateText = 'Hôm qua';
    } else {
      dateText = DateFormat('dd/MM/yyyy', 'vi').format(date);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  bool _shouldShowAvatar(
    ChatMessage message,
    ChatMessage? previousMessage,
    ChatMessage? nextMessage,
  ) {
    // Show avatar if:
    // 1. It's the first message
    // 2. Previous message is from different sender
    // 3. Next message is from different sender or null
    // 4. Time gap > 5 minutes from previous message

    if (previousMessage == null) {
      return true;
    }

    if (previousMessage.senderId != message.senderId) {
      return true;
    }

    if (nextMessage == null || nextMessage.senderId != message.senderId) {
      return true;
    }

    final timeDifference = message.timestamp.difference(
      previousMessage.timestamp,
    );
    if (timeDifference.inMinutes > 5) {
      return true;
    }

    return false;
  }

  void _replyToMessage(ChatMessage message) {
    setState(() {
      _replyTo = message;
      _isComposing = true; // bring up send button
    });
    // Focus input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _markAsRead(ChatMessage message) {
    ref
        .read(chatProvider.notifier)
        .markMessageAsRead(message.id, widget.courseId);
  }

  String _getConnectionStatusText(String status) {
    switch (status) {
      case 'connected':
        return 'Đã kết nối';
      case 'disconnected':
        return 'Mất kết nối';
      case 'reconnected':
        return 'Đã kết nối lại';
      case 'error':
        return 'Lỗi kết nối';
      default:
        return 'Đang kết nối...';
    }
  }

  void _showChatInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return _ChatInfoSheet(
            courseId: widget.courseId,
            courseName: widget.courseName,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

/// Chat Info Bottom Sheet
class _ChatInfoSheet extends ConsumerWidget {
  const _ChatInfoSheet({
    required this.courseId,
    required this.courseName,
    required this.scrollController,
  });

  final String courseId;
  final String courseName;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoom = ref
        .watch(chatProvider.notifier)
        .getChatRoomByCourseId(courseId);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Text(
            'Thông tin chat',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Course info
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.school)),
            title: Text(courseName),
            subtitle: const Text('Nhóm thảo luận khóa học'),
            contentPadding: EdgeInsets.zero,
          ),

          const Divider(),

          // Participants
          if (chatRoom != null && chatRoom.participants.isNotEmpty) ...[
            Text(
              'Thành viên (${chatRoom.participants.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: chatRoom.participants.length,
                itemBuilder: (context, index) {
                  final participant = chatRoom.participants[index];
                  final isOnline = ref.watch(
                    onlineStatusProvider(participant.id),
                  );

                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: participant.avatar != null
                              ? NetworkImage(participant.avatar!)
                              : null,
                          child: participant.avatar == null
                              ? Text(participant.name[0].toUpperCase())
                              : null,
                        ),
                        if (isOnline) ...[
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    title: Text(participant.name),
                    subtitle: Text(participant.statusDisplay),
                    trailing: Chip(
                      label: Text(
                        participant.role == 'instructor' ? 'GV' : 'HV',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: participant.role == 'instructor'
                          ? Colors.blue[100]
                          : Colors.grey[200],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  );
                },
              ),
            ),
          ] else ...[
            const Expanded(
              child: Center(child: Text('Không có thông tin thành viên')),
            ),
          ],
        ],
      ),
    );
  }
}
