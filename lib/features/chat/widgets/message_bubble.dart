import 'package:flutter/material.dart';
import 'dart:io' show Directory;
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/chat_models.dart';

/// Message Bubble Widget for Chat Messages
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.onReply,
    this.onMarkAsRead,
    this.dioClient,
    this.getTempDir,
    this.openFile,
    this.downloadImpl,
  });

  final ChatMessage message;
  final bool showAvatar;
  final Function(ChatMessage)? onReply;
  final VoidCallback? onMarkAsRead;
  // Injectable for testing
  final dio.Dio? dioClient;
  final Future<Directory> Function()? getTempDir;
  final Future<dynamic> Function(String path)? openFile;
  // Injectable download implementation for tests
  final Future<void> Function(
    String url,
    String savePath,
    void Function(int received, int total) onReceiveProgress,
  )? downloadImpl;

  @override
  Widget build(BuildContext context) {
    final isFromCurrentUser = message.isFromCurrentUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isFromCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromCurrentUser && showAvatar) _buildAvatar(),
          if (!isFromCurrentUser && !showAvatar) const SizedBox(width: 40),

          Flexible(
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(context),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                margin: EdgeInsets.only(
                  left: isFromCurrentUser ? 60 : 8,
                  right: isFromCurrentUser ? 8 : 60,
                ),
                child: Column(
                  crossAxisAlignment: isFromCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isFromCurrentUser && showAvatar)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Text(
                          message.senderName,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getSenderColor(message.senderId),
                              ),
                        ),
                      ),

                    if (message.replyToMessage != null) _buildReplyPreview(),

                    _buildMessageContent(context, isFromCurrentUser),

                    _buildMessageInfo(context, isFromCurrentUser),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 16),
      child: CircleAvatar(
        radius: 16,
        backgroundImage: message.senderAvatar != null
            ? NetworkImage(message.senderAvatar!)
            : null,
        child: message.senderAvatar == null
            ? Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(fontSize: 12),
              )
            : null,
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: _getSenderColor(message.replyToMessage!.senderId),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyToMessage!.senderName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            message.replyToMessage!.content,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isFromCurrentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isFromCurrentUser
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        borderRadius: _getBorderRadius(isFromCurrentUser),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.text)
            _buildTextContent(context, isFromCurrentUser)
          else if (message.type == MessageType.image)
            _buildImageContent()
          else if (message.type == MessageType.file)
            _buildFileContent()
          else if (message.type == MessageType.system)
            _buildSystemContent(context)
          else if (message.type == MessageType.announcement)
            _buildAnnouncementContent(context),

          if (message.hasAttachments) _buildAttachments(context),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, bool isFromCurrentUser) {
    return SelectableText(
      message.content,
      style: TextStyle(
        color: isFromCurrentUser
            ? Colors.white
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 16,
      ),
    );
  }

  Widget _buildImageContent() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.content,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 50)),
              );
            },
          ),
        ),
        if (message.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message.content),
          ),
      ],
    );
  }

  Widget _buildFileContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message.content,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemContent(BuildContext context) {
    return Text(
      message.content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildAnnouncementContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.content,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        ...message.attachments.map(
          (attachment) => _buildAttachment(context, attachment),
        ),
      ],
    );
  }

  Widget _buildAttachment(BuildContext context, MessageAttachment attachment) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            attachment.isImage
                ? Icons.image
                : attachment.isVideo
                ? Icons.video_file
                : attachment.isAudio
                ? Icons.audio_file
                : Icons.insert_drive_file,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  attachment.fileSizeDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, size: 20),
            key: ValueKey('download_${attachment.id}'),
            onPressed: () => _handleDownload(context, attachment),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInfo(BuildContext context, bool isFromCurrentUser) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.displayTime,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isFromCurrentUser ? Colors.white70 : Colors.grey[600],
              fontSize: 11,
            ),
          ),
          if (isFromCurrentUser) ...[
            const SizedBox(width: 4),
            _buildMessageStatusIcon(),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        );
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 12, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 12, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 12, color: Colors.blue);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 12, color: Colors.red);
    }
  }

  BorderRadius _getBorderRadius(bool isFromCurrentUser) {
    return BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isFromCurrentUser ? 16 : 4),
      bottomRight: Radius.circular(isFromCurrentUser ? 4 : 16),
    );
  }

  Color _getSenderColor(String senderId) {
    // Generate a consistent color based on sender ID
    final hash = senderId.hashCode;
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash % colors.length];
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(tr('chat.menu.copy')),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(tr('chat.menu.copied'))));
              },
            ),
            if (onReply != null)
              ListTile(
                leading: const Icon(Icons.reply),
                title: Text(tr('chat.menu.reply')),
                onTap: () {
                  Navigator.pop(context);
                  onReply!(message);
                },
              ),
            if (!message.isFromCurrentUser && onMarkAsRead != null)
              ListTile(
                leading: const Icon(Icons.mark_email_read),
                title: Text(tr('chat.menu.markAsRead')),
                onTap: () {
                  Navigator.pop(context);
                  onMarkAsRead!();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDownload(
    BuildContext context,
    MessageAttachment attachment,
  ) async {
    // Capture messenger before any awaits to avoid using context across async gaps
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final url = attachment.fileUrl;

      // If it's a local file path, open directly
      if (!url.startsWith('http')) {
        final localPath = url.startsWith('file://')
            ? url.replaceFirst('file://', '')
            : url;
        if (openFile != null) {
          await openFile!(localPath);
        } else {
          await OpenFilex.open(localPath);
        }
        return;
      }

      // Show progress dialog before async operations
      final progress = ValueNotifier<double>(0);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text(tr('chat.download.dialogTitle')),
            content: ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, _) {
                final percent = (value * 100).clamp(0, 100).toStringAsFixed(0);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(attachment.fileName, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: value == 0 ? null : value),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        tr(
                          'chat.download.progress',
                          namedArgs: {'percent': percent},
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );

    final tempDir = await (getTempDir != null
      ? getTempDir!()
      : getTemporaryDirectory());
      final savePath = '${tempDir.path}/${attachment.fileName}';

      if (downloadImpl != null) {
        await downloadImpl!(
          url,
          savePath,
          (received, total) {
            if (total > 0) {
              progress.value = received / total;
            }
            if (total > 0 && received >= total && navigator.canPop()) {
              navigator.pop();
            }
          },
        );
      } else {
        final client = dioClient ?? dio.Dio();
        await client.download(
          url,
          savePath,
          options: dio.Options(
            responseType: dio.ResponseType.bytes,
            followRedirects: true,
            receiveTimeout: const Duration(seconds: 30),
          ),
          onReceiveProgress: (received, total) {
            if (total > 0) {
              progress.value = received / total;
            }
            if (total > 0 && received >= total && navigator.canPop()) {
              navigator.pop();
            }
          },
        );
      }

      // Ensure dialog is closed after completion in case progress callback raced
      if (navigator.canPop()) {
        navigator.pop();
      }

      if (openFile != null) {
        await openFile!(savePath);
      } else {
        await OpenFilex.open(savePath);
      }
    } catch (e) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            tr('chat.download.failed', namedArgs: {'error': e.toString()}),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
