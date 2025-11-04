import 'package:equatable/equatable.dart';

/// Chat Message Model
class ChatMessage extends Equatable {
  final String id;
  final String courseId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final String? replyToId;
  final ChatMessage? replyToMessage;
  final List<MessageAttachment> attachments;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.courseId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.type = MessageType.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.replyToId,
    this.replyToMessage,
    this.attachments = const [],
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      senderAvatar: json['sender_avatar'] as String?,
      content: json['content'] as String,
      type: MessageType.fromString(json['type'] as String? ?? 'text'),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.fromString(json['status'] as String? ?? 'sent'),
      replyToId: json['reply_to_id'] as String?,
      replyToMessage: json['reply_to_message'] != null
          ? ChatMessage.fromJson(
              json['reply_to_message'] as Map<String, dynamic>,
            )
          : null,
      attachments:
          (json['attachments'] as List?)
              ?.map(
                (a) => MessageAttachment.fromJson(a as Map<String, dynamic>),
              )
              .toList() ??
          [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'content': content,
      'type': type.value,
      'timestamp': timestamp.toIso8601String(),
      'status': status.value,
      'reply_to_id': replyToId,
      'reply_to_message': replyToMessage?.toJson(),
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'metadata': metadata,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? courseId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    String? replyToId,
    ChatMessage? replyToMessage,
    List<MessageAttachment>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      replyToId: replyToId ?? this.replyToId,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }

  // Computed properties
  bool get isFromCurrentUser =>
      senderId == 'current_user_id'; // Will be updated with actual user ID
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isReply => replyToId != null;

  String get displayTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m trước';
    } else {
      return 'Vừa xong';
    }
  }

  @override
  List<Object?> get props => [
    id,
    courseId,
    senderId,
    senderName,
    senderAvatar,
    content,
    type,
    timestamp,
    status,
    replyToId,
    replyToMessage,
    attachments,
    metadata,
  ];
}

/// Message Type Enum
enum MessageType {
  text('text'),
  image('image'),
  file('file'),
  audio('audio'),
  video('video'),
  system('system'),
  announcement('announcement');

  const MessageType(this.value);
  final String value;

  static MessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      case 'system':
        return MessageType.system;
      case 'announcement':
        return MessageType.announcement;
      default:
        return MessageType.text;
    }
  }

  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Tin nhắn';
      case MessageType.image:
        return 'Hình ảnh';
      case MessageType.file:
        return 'Tệp tin';
      case MessageType.audio:
        return 'Âm thanh';
      case MessageType.video:
        return 'Video';
      case MessageType.system:
        return 'Hệ thống';
      case MessageType.announcement:
        return 'Thông báo';
    }
  }
}

/// Message Status Enum
enum MessageStatus {
  sending('sending'),
  sent('sent'),
  delivered('delivered'),
  read('read'),
  failed('failed');

  const MessageStatus(this.value);
  final String value;

  static MessageStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  String get displayName {
    switch (this) {
      case MessageStatus.sending:
        return 'Đang gửi';
      case MessageStatus.sent:
        return 'Đã gửi';
      case MessageStatus.delivered:
        return 'Đã nhận';
      case MessageStatus.read:
        return 'Đã đọc';
      case MessageStatus.failed:
        return 'Gửi lỗi';
    }
  }
}

/// Message Attachment Model
class MessageAttachment extends Equatable {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    this.thumbnailUrl,
    this.metadata,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      fileType: json['file_type'] as String,
      fileSize: json['file_size'] as int,
      thumbnailUrl: json['thumbnail_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'thumbnail_url': thumbnailUrl,
      'metadata': metadata,
    };
  }

  // Computed properties
  bool get isImage => fileType.startsWith('image/');
  bool get isVideo => fileType.startsWith('video/');
  bool get isAudio => fileType.startsWith('audio/');
  bool get isDocument =>
      fileType.startsWith('application/') || fileType.startsWith('text/');

  String get fileSizeDisplay {
    if (fileSize < 1024) {
      return '${fileSize}B';
    }
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    }
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  @override
  List<Object?> get props => [
    id,
    fileName,
    fileUrl,
    fileType,
    fileSize,
    thumbnailUrl,
    metadata,
  ];
}

/// Chat Room Model
class ChatRoom extends Equatable {
  final String id;
  final String courseId;
  final String courseName;
  final String? courseAvatar;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastActivity;
  final Map<String, dynamic>? metadata;

  const ChatRoom({
    required this.id,
    required this.courseId,
    required this.courseName,
    this.courseAvatar,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount = 0,
    this.isActive = true,
    required this.createdAt,
    this.lastActivity,
    this.metadata,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      courseName: json['course_name'] as String,
      courseAvatar: json['course_avatar'] as String?,
      participants:
          (json['participants'] as List?)
              ?.map((p) => ChatParticipant.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActivity: json['last_activity'] != null
          ? DateTime.parse(json['last_activity'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_name': courseName,
      'course_avatar': courseAvatar,
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_activity': lastActivity?.toIso8601String(),
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
    id,
    courseId,
    courseName,
    courseAvatar,
    participants,
    lastMessage,
    unreadCount,
    isActive,
    createdAt,
    lastActivity,
    metadata,
  ];
}

/// Chat Participant Model
class ChatParticipant extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final String role; // student, instructor, admin
  final bool isOnline;
  final DateTime? lastSeen;
  final Map<String, dynamic>? metadata;

  const ChatParticipant({
    required this.id,
    required this.name,
    this.avatar,
    required this.role,
    this.isOnline = false,
    this.lastSeen,
    this.metadata,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String,
      isOnline: json['is_online'] as bool? ?? false,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'role': role,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
      'metadata': metadata,
    };
  }

  String get statusDisplay {
    if (isOnline) return 'Đang online';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);

      if (difference.inDays > 0) {
        return 'Hoạt động ${difference.inDays} ngày trước';
      } else if (difference.inHours > 0) {
        return 'Hoạt động ${difference.inHours} giờ trước';
      } else if (difference.inMinutes > 0) {
        return 'Hoạt động ${difference.inMinutes} phút trước';
      } else {
        return 'Vừa hoạt động';
      }
    }
    return 'Chưa xác định';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    avatar,
    role,
    isOnline,
    lastSeen,
    metadata,
  ];
}
