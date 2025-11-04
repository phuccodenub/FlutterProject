import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_models.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

/// Chat Rooms List Screen
class ChatRoomsScreen extends ConsumerStatefulWidget {
  const ChatRoomsScreen({super.key});

  @override
  ConsumerState<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends ConsumerState<ChatRoomsScreen> {
  @override
  void initState() {
    super.initState();

    // Load chat rooms when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatRooms = ref.watch(chatRoomsProvider);
    final isLoading = ref.watch(chatLoadingProvider);
    final error = ref.watch(chatErrorProvider);
    final connectionStatus = ref.watch(connectionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (connectionStatus != 'connected')
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(chatProvider.notifier).loadChatRooms();
              },
              tooltip: 'Làm mới',
            ),
        ],
      ),
      body: Column(
        children: [
          // Connection status
          if (connectionStatus == 'disconnected' || connectionStatus == 'error')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange,
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      connectionStatus == 'error'
                          ? 'Lỗi kết nối - Tin nhắn có thể không được cập nhật'
                          : 'Mất kết nối - Đang thử kết nối lại...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

          // Chat rooms list
          Expanded(child: _buildChatRoomsList(chatRooms, isLoading, error)),
        ],
      ),
    );
  }

  Widget _buildChatRoomsList(
    List<ChatRoom> chatRooms,
    bool isLoading,
    String? error,
  ) {
    if (isLoading && chatRooms.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh sách tin nhắn...'),
          ],
        ),
      );
    }

    if (error != null && chatRooms.isEmpty) {
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
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(chatProvider.notifier).loadChatRooms();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (chatRooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Chưa có cuộc trò chuyện',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tham gia khóa học để bắt đầu trò chuyện với giảng viên và học viên khác',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(chatProvider.notifier).loadChatRooms();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: chatRooms.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final room = chatRooms[index];
          return ChatRoomListTile(
            chatRoom: room,
            onTap: () => _openChatRoom(room),
          );
        },
      ),
    );
  }

  void _openChatRoom(ChatRoom room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(courseId: room.courseId, courseName: room.courseName),
      ),
    );
  }
}

/// Chat Room List Tile Widget
class ChatRoomListTile extends ConsumerWidget {
  const ChatRoomListTile({
    super.key,
    required this.chatRoom,
    required this.onTap,
  });

  final ChatRoom chatRoom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastMessage = chatRoom.lastMessage;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: _buildAvatar(),
      title: Text(
        chatRoom.courseName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lastMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              _getLastMessageText(lastMessage),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              'Chưa có tin nhắn',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            '${chatRoom.participants.length} thành viên',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lastMessage != null)
            Text(
              lastMessage.displayTime,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          const SizedBox(height: 4),
          if (chatRoom.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chatRoom.unreadCount > 99 ? '99+' : '${chatRoom.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const SizedBox(height: 20), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: ClipOval(
        child: chatRoom.courseAvatar != null
            ? Image.network(
                chatRoom.courseAvatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.blue.withValues(alpha: 0.1),
      child: const Icon(Icons.school, color: Colors.blue, size: 28),
    );
  }

  String _getLastMessageText(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return message.content;
      case MessageType.image:
        return '📷 Hình ảnh';
      case MessageType.file:
        return '📎 Tệp tin';
      case MessageType.audio:
        return '🎵 Âm thanh';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.system:
        return message.content;
      case MessageType.announcement:
        return '📢 ${message.content}';
    }
  }
}
