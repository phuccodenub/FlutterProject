import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/chat_models.dart';

/// Message Input Widget for Chat
class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onChanged,
    this.isComposing = false,
    this.hintText = 'Nhập tin nhắn...',
    this.onMediaSelected,
    this.replyTo,
    this.onCancelReply,
    this.pickImageOverride,
    this.pickVideoOverride,
    this.pickFileOverride,
    this.takePhotoOverride,
    this.startRecordingOverride,
    this.stopRecordingOverride,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;
  final bool isComposing;
  final String hintText;
  final ValueChanged<File>? onMediaSelected;
  final ChatMessage? replyTo;
  final VoidCallback? onCancelReply;
  final Future<File?> Function()? pickImageOverride;
  final Future<File?> Function()? pickVideoOverride;
  final Future<File?> Function()? pickFileOverride;
  final Future<File?> Function()? takePhotoOverride;
  final Future<void> Function()? startRecordingOverride;
  final Future<File?> Function({bool send})? stopRecordingOverride;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  Timer? _recordingTimer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    // Rebuild when text changes so the send button can toggle visibility
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _audioRecorder.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _handleSubmitted() {
    if (widget.controller.text.trim().isNotEmpty) {
      widget.onSend();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consider composing true if either parent indicates it or there's text in the controller
    final bool composing =
        widget.controller.text.trim().isNotEmpty || widget.isComposing;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.replyTo != null)
                _ReplyBanner(
                  replyTo: widget.replyTo!,
                  onCancel: widget.onCancelReply,
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attach file button
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _showAttachmentOptions,
                    tooltip: 'Đính kèm tệp',
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        maxHeight: 120,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        onChanged: (text) {
                          widget.onChanged(text);
                        },
                        onSubmitted: (_) => _handleSubmitted(),
                        maxLines: null,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Send / Record button with recording indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: composing
                        ? FloatingActionButton.small(
                            onPressed: _handleSubmitted,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isRecording) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.red,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatDuration(_recordingDuration),
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              GestureDetector(
                                onLongPress: _startRecording,
                                onLongPressUp: () => _stopRecording(send: true),
                                child: FloatingActionButton.small(
                                  onPressed: () {
                                    if (_isRecording) {
                                      _stopRecording(send: true);
                                    } else {
                                      _startRecording();
                                    }
                                  },
                                  backgroundColor: _isRecording
                                      ? Colors.red
                                      : Colors.grey[300],
                                  child: Icon(
                                    _isRecording ? Icons.stop : Icons.mic,
                                    color: _isRecording
                                        ? Colors.white
                                        : Colors.grey[700],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text('Đính kèm tệp', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            // Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AttachmentOption(
                  icon: Icons.photo,
                  label: 'Hình ảnh',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.videocam,
                  label: 'Video',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Tệp tin',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Recording helpers
  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _pickImage() async {
    try {
      if (widget.pickImageOverride != null) {
        final f = await widget.pickImageOverride!();
        if (f != null && widget.onMediaSelected != null) {
          widget.onMediaSelected!(f);
        }
        return;
      }
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 1920,
        maxWidth: 1920,
      );

      if (image != null && widget.onMediaSelected != null) {
        widget.onMediaSelected!(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chọn hình ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      if (widget.pickVideoOverride != null) {
        final f = await widget.pickVideoOverride!();
        if (f != null && widget.onMediaSelected != null) {
          widget.onMediaSelected!(f);
        }
        return;
      }
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );

      if (video != null && widget.onMediaSelected != null) {
        widget.onMediaSelected!(File(video.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chọn video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      if (widget.pickFileOverride != null) {
        final f = await widget.pickFileOverride!();
        if (f != null && widget.onMediaSelected != null) {
          widget.onMediaSelected!(f);
        }
        return;
      }
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: null,
      );

      if (result != null &&
          result.files.single.path != null &&
          widget.onMediaSelected != null) {
        widget.onMediaSelected!(File(result.files.single.path!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chọn tệp tin: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      if (widget.takePhotoOverride != null) {
        final f = await widget.takePhotoOverride!();
        if (f != null && widget.onMediaSelected != null) {
          widget.onMediaSelected!(f);
        }
        return;
      }
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 1920,
        maxWidth: 1920,
      );

      if (photo != null && widget.onMediaSelected != null) {
        widget.onMediaSelected!(File(photo.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chụp ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (widget.startRecordingOverride != null) {
        await widget.startRecordingOverride!();
        if (!mounted) return;
        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
        });
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            _recordingDuration++;
          });
        });
        return;
      }
      final hasPerm = await _audioRecorder.hasPermission();
      if (!hasPerm) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ứng dụng cần quyền Micro để ghi âm')),
        );
        return;
      }

      final dir = await getTemporaryDirectory();
      final filePath = p.join(
        dir.path,
        'rec_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _recordingDuration++;
        });
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể bắt đầu ghi âm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording({bool send = true}) async {
    try {
      if (widget.stopRecordingOverride != null) {
        final f = await widget.stopRecordingOverride!(send: send);
        _recordingTimer?.cancel();
        if (mounted) {
          setState(() {
            _isRecording = false;
          });
        }
        if (send && f != null && widget.onMediaSelected != null) {
          widget.onMediaSelected!(f);
        }
        return;
      }
      final path = await _audioRecorder.stop();
      _recordingTimer?.cancel();
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }

      if (send && path != null && widget.onMediaSelected != null) {
        final f = File(path);
        if (await f.exists()) {
          widget.onMediaSelected!(f);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể dừng ghi âm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Attachment Option Widget
class _AttachmentOption extends StatelessWidget {
  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Reply banner displayed above the input when replying to a message
class _ReplyBanner extends StatelessWidget {
  const _ReplyBanner({required this.replyTo, this.onCancel});

  final ChatMessage replyTo;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('reply_banner'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(left: BorderSide(color: Colors.blue[400]!, width: 3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  replyTo.senderName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  replyTo.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onCancel != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onCancel,
              tooltip: 'Hủy trả lời',
            ),
        ],
      ),
    );
  }
}
