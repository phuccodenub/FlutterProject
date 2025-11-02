import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'dart:async';
import 'dart:io';
import '../../../../features/chat/chat_store.dart';
import '../../../../features/auth/auth_state.dart';

class ChatTabView extends ConsumerStatefulWidget {
  const ChatTabView({super.key, required this.courseId});
  final String courseId;

  @override
  ConsumerState<ChatTabView> createState() => _ChatTabViewState();
}

class _ChatTabViewState extends ConsumerState<ChatTabView> {
  final ctrl = TextEditingController();
  Timer? _typingDebounce;
  String? attachPath;
  String? attachName;
  int? attachSize;
  final ScrollController _scrollController = ScrollController();

  bool _isImageFile(String? filePath) {
    if (filePath == null) return false;
    final ext = filePath.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  void _showImageViewer(BuildContext context, String imagePath) {
    final imageFile = File(imagePath);
    if (!imageFile.existsSync()) return;

    final imageProvider = FileImage(imageFile);
    showImageViewer(
      context,
      imageProvider,
    );
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    ctrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final state = ref.watch(chatProvider);
    final messages = state.messagesByCourse[widget.courseId] ?? const [];
    final online = state.onlineUsersByCourse[widget.courseId] ?? const [];
    final typingUsers = state.typingUsers[widget.courseId] ?? {};
    final currentUserId = auth.user?.id ?? 0;

    // Filter out current user from typing
    final othersTyping = typingUsers
        .where((id) => id != currentUserId)
        .toList();

    return Column(
      children: [
        // Online users header
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              const Icon(Icons.group, size: 18),
              const SizedBox(width: 6),
              Text(
                'Online: ${online.length}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ref
                      .read(chatProvider.notifier)
                      .simulateOnlineUsers(
                        widget.courseId,
                        currentUserRole: auth.user?.role ?? 'student',
                      );
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              final isMe = m.userId == currentUserId;
              final lastSeen = ref
                  .read(chatProvider.notifier)
                  .getLastSeenText(m.userId);

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            m.userName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '• $lastSeen',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(m.message, style: const TextStyle(fontSize: 14)),
                      if (m.attachmentPath != null) ...[
                        const SizedBox(height: 8),
                        if (_isImageFile(m.attachmentPath))
                          // Show image thumbnail with tap to view
                          GestureDetector(
                            onTap: () => _showImageViewer(context, m.attachmentPath!),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 200,
                                maxHeight: 200,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(m.attachmentPath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        else
                          // Show file attachment info
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    m.attachmentName ??
                                        m.attachmentPath!.split('/').last,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (m.attachmentSize != null) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${_formatBytes(m.attachmentSize!)})',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(m.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Typing indicator
        if (othersTyping.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      3,
                      (index) => _TypingDot(delay: index * 200),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  othersTyping.length == 1
                      ? 'Someone is typing...'
                      : '${othersTyping.length} people are typing...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        const Divider(height: 1),
        // Attachment preview
        if (attachPath != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.amber.shade50,
            child: Row(
              children: [
                const Icon(Icons.attachment, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attachName ?? attachPath!.split('/').last,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() {
                    attachPath = null;
                    attachName = null;
                    attachSize = null;
                  }),
                ),
              ],
            ),
          ),
        // Input bar
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  onChanged: (_) {
                    _typingDebounce?.cancel();
                    final user = auth.user;
                    if (user == null) return;
                    ref
                        .read(chatProvider.notifier)
                        .setTyping(widget.courseId, user.id, true);
                    _typingDebounce = Timer(
                      const Duration(milliseconds: 800),
                      () {
                        ref
                            .read(chatProvider.notifier)
                            .setTyping(widget.courseId, user.id, false);
                      },
                    );
                  },
                ),
              ),
              IconButton(
                tooltip: 'Đính kèm',
                icon: const Icon(Icons.attach_file),
                onPressed: () async {
                  final res = await FilePicker.platform.pickFiles();
                  if (res != null && res.files.single.path != null && mounted) {
                    setState(() {
                      attachPath = res.files.single.path;
                      attachName = res.files.single.name;
                      attachSize = res.files.single.size;
                    });
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã đính kèm: ${res.files.single.name}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Gửi',
                icon: const Icon(Icons.send),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  final user = auth.user;
                  if (user == null || ctrl.text.trim().isEmpty) return;
                  ref
                      .read(chatProvider.notifier)
                      .sendMessage(
                        widget.courseId,
                        user.id,
                        user.fullName,
                        ctrl.text.trim(),
                        attachmentPath: attachPath,
                        attachmentName: attachName,
                        attachmentSize: attachSize,
                      );
                  ref.read(chatProvider.notifier).updateLastSeen(user.id);
                  ctrl.clear();
                  setState(() {
                    attachPath = null;
                    attachName = null;
                    attachSize = null;
                  });
                  _scrollToBottom();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
    if (diff.inDays < 1) return '${diff.inHours} giờ trước';
    return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({required this.delay});
  final int delay;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade600.withValues(
              alpha: 0.3 + (_animation.value * 0.7),
            ),
          ),
        );
      },
    );
  }
}
