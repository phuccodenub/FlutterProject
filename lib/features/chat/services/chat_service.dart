import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/network/dio_client.dart';
import '../../../core/config/api_config.dart';
import '../models/chat_models.dart';

/// Real-time Chat Service with Socket.IO integration
class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  io.Socket? _socket;
  final DioClient _dioClient = DioClient();

  // Stream controllers for real-time events
  final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<List<ChatRoom>> _roomsController =
      StreamController<List<ChatRoom>>.broadcast();
  final StreamController<Map<String, bool>> _typingController =
      StreamController<Map<String, bool>>.broadcast();
  final StreamController<Map<String, bool>> _onlineUsersController =
      StreamController<Map<String, bool>>.broadcast();
  final StreamController<String> _connectionController =
      StreamController<String>.broadcast();

  // Getters for streams
  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<List<ChatRoom>> get roomsStream => _roomsController.stream;
  Stream<Map<String, bool>> get typingStream => _typingController.stream;
  Stream<Map<String, bool>> get onlineUsersStream =>
      _onlineUsersController.stream;
  Stream<String> get connectionStream => _connectionController.stream;

  // Current state
  bool _isConnected = false;
  String? _currentUserId;
  final Map<String, List<ChatMessage>> _messageCache = {};
  List<ChatRoom> _chatRooms = [];
  final Map<String, bool> _typingUsers = {};
  final Map<String, bool> _onlineUsers = {};

  // Getters
  bool get isConnected => _isConnected;
  String? get currentUserId => _currentUserId;
  List<ChatRoom> get chatRooms => _chatRooms;

  /// Initialize Socket.IO connection
  Future<void> initialize(String userId, String token) async {
    try {
      _currentUserId = userId;

      // Disconnect existing connection if any
      await disconnect();

      // Create socket connection
      _socket = io.io(
        ApiConfig.baseUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setAuth({'token': token, 'userId': userId})
            .build(),
      );

      _setupSocketListeners();
      _socket!.connect();

      debugPrint('[ChatService] Initializing with user: $userId');
    } catch (e) {
      debugPrint('[ChatService] Initialize error: $e');
      _connectionController.add('error');
    }
  }

  /// Setup Socket.IO event listeners
  void _setupSocketListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      _isConnected = true;
      _connectionController.add('connected');
      debugPrint('[ChatService] Connected to server');
      _joinUserRoom();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      _connectionController.add('disconnected');
      debugPrint('[ChatService] Disconnected from server');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      _connectionController.add('error');
      debugPrint('[ChatService] Connection error: $error');
    });

    _socket!.onReconnect((_) {
      _isConnected = true;
      _connectionController.add('reconnected');
      debugPrint('[ChatService] Reconnected to server');
      _joinUserRoom();
    });

    // Chat events
    _socket!.on('new_message', (data) {
      try {
        final message = ChatMessage.fromJson(data);
        _handleNewMessage(message);
      } catch (e) {
        debugPrint('[ChatService] Error parsing new message: $e');
      }
    });

    _socket!.on('message_status_updated', (data) {
      try {
        final messageId = data['messageId'] as String;
        final status = MessageStatus.fromString(data['status'] as String);
        _updateMessageStatus(messageId, status);
      } catch (e) {
        debugPrint('[ChatService] Error updating message status: $e');
      }
    });

    _socket!.on('user_typing', (data) {
      try {
        final userId = data['userId'] as String;
        final courseId = data['courseId'] as String;
        final isTyping = data['isTyping'] as bool;
        _handleTypingEvent(userId, courseId, isTyping);
      } catch (e) {
        debugPrint('[ChatService] Error handling typing event: $e');
      }
    });

    _socket!.on('user_online_status', (data) {
      try {
        final userId = data['userId'] as String;
        final isOnline = data['isOnline'] as bool;
        _handleOnlineStatusEvent(userId, isOnline);
      } catch (e) {
        debugPrint('[ChatService] Error handling online status: $e');
      }
    });

    _socket!.on('room_updated', (data) {
      try {
        final room = ChatRoom.fromJson(data);
        _handleRoomUpdate(room);
      } catch (e) {
        debugPrint('[ChatService] Error handling room update: $e');
      }
    });
  }

  /// Join user's personal room for notifications
  void _joinUserRoom() {
    if (_socket != null && _currentUserId != null) {
      _socket!.emit('join_user_room', {'userId': _currentUserId});
    }
  }

  /// Join a course chat room
  Future<void> joinCourseRoom(String courseId) async {
    if (_socket == null || !_isConnected) {
      debugPrint('[ChatService] Cannot join room: Not connected');
      return;
    }

    try {
      _socket!.emit('join_course_room', {
        'courseId': courseId,
        'userId': _currentUserId,
      });
      debugPrint('[ChatService] Joined course room: $courseId');
    } catch (e) {
      debugPrint('[ChatService] Error joining course room: $e');
    }
  }

  /// Leave a course chat room
  Future<void> leaveCourseRoom(String courseId) async {
    if (_socket == null || !_isConnected) return;

    try {
      _socket!.emit('leave_course_room', {
        'courseId': courseId,
        'userId': _currentUserId,
      });
      debugPrint('[ChatService] Left course room: $courseId');
    } catch (e) {
      debugPrint('[ChatService] Error leaving course room: $e');
    }
  }

  /// Send a message
  Future<ChatMessage?> sendMessage({
    required String courseId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    List<MessageAttachment> attachments = const [],
  }) async {
    if (_socket == null || !_isConnected || _currentUserId == null) {
      debugPrint(
        '[ChatService] Cannot send message: Not connected or no user ID',
      );
      return null;
    }

    try {
      // Create temporary message with sending status
      final tempMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: courseId,
        senderId: _currentUserId!,
        senderName: 'You', // Will be updated by server
        content: content,
        type: type,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
        replyToId: replyToId,
        attachments: attachments,
      );

      // Add to cache and notify listeners
      _addMessageToCache(courseId, tempMessage);
      _messageController.add(tempMessage);

      // Send to server
      final messageData = {
        'courseId': courseId,
        'content': content,
        'type': type.value,
        'replyToId': replyToId,
        'attachments': attachments.map((a) => a.toJson()).toList(),
        'tempId': tempMessage.id,
      };

      _socket!.emit('send_message', messageData);
      return tempMessage;
    } catch (e) {
      debugPrint('[ChatService] Error sending message: $e');
      return null;
    }
  }

  /// Send typing indicator
  void sendTypingIndicator(String courseId, bool isTyping) {
    if (_socket == null || !_isConnected || _currentUserId == null) return;

    _socket!.emit('typing', {
      'courseId': courseId,
      'userId': _currentUserId,
      'isTyping': isTyping,
    });
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId, String courseId) async {
    if (_socket == null || !_isConnected) return;

    try {
      _socket!.emit('mark_message_read', {
        'messageId': messageId,
        'courseId': courseId,
        'userId': _currentUserId,
      });
    } catch (e) {
      debugPrint('[ChatService] Error marking message as read: $e');
    }
  }

  /// Get chat rooms from API
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final response = await _dioClient.dio.get('/chat/rooms');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final roomsData = response.data['data'] as List;
        _chatRooms = roomsData.map((room) => ChatRoom.fromJson(room)).toList();

        _roomsController.add(_chatRooms);
        return _chatRooms;
      }

      throw Exception(response.data['message'] ?? 'Failed to get chat rooms');
    } catch (e) {
      debugPrint('[ChatService] Error getting chat rooms: $e');
      return [];
    }
  }

  /// Get messages for a course
  Future<List<ChatMessage>> getCourseMessages(
    String courseId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/chat/courses/$courseId/messages',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final messagesData = response.data['data'] as List;
        final messages = messagesData
            .map((msg) => ChatMessage.fromJson(msg))
            .toList();

        // Cache messages
        _messageCache[courseId] = messages;
        return messages;
      }

      throw Exception(response.data['message'] ?? 'Failed to get messages');
    } catch (e) {
      debugPrint('[ChatService] Error getting course messages: $e');
      return _messageCache[courseId] ?? [];
    }
  }

  /// Get cached messages for a course
  List<ChatMessage> getCachedMessages(String courseId) {
    return _messageCache[courseId] ?? [];
  }

  /// Handle new message event
  void _handleNewMessage(ChatMessage message) {
    _addMessageToCache(message.courseId, message);
    _messageController.add(message);

    // Update room's last message
    _updateRoomLastMessage(message);
  }

  /// Handle message status update
  void _updateMessageStatus(String messageId, MessageStatus status) {
    for (final courseId in _messageCache.keys) {
      final messages = _messageCache[courseId]!;
      final messageIndex = messages.indexWhere((m) => m.id == messageId);

      if (messageIndex != -1) {
        final updatedMessage = messages[messageIndex].copyWith(status: status);
        messages[messageIndex] = updatedMessage;
        _messageController.add(updatedMessage);
        break;
      }
    }
  }

  /// Handle typing event
  void _handleTypingEvent(String userId, String courseId, bool isTyping) {
    if (userId == _currentUserId) return; // Ignore own typing

    final key = '${courseId}_$userId';
    _typingUsers[key] = isTyping;

    if (!isTyping) {
      _typingUsers.remove(key);
    }

    _typingController.add(_typingUsers);
  }

  /// Handle online status event
  void _handleOnlineStatusEvent(String userId, bool isOnline) {
    _onlineUsers[userId] = isOnline;

    if (!isOnline) {
      _onlineUsers.remove(userId);
    }

    _onlineUsersController.add(_onlineUsers);
  }

  /// Handle room update
  void _handleRoomUpdate(ChatRoom room) {
    final existingIndex = _chatRooms.indexWhere((r) => r.id == room.id);

    if (existingIndex != -1) {
      _chatRooms[existingIndex] = room;
    } else {
      _chatRooms.add(room);
    }

    _roomsController.add(_chatRooms);
  }

  /// Add message to cache
  void _addMessageToCache(String courseId, ChatMessage message) {
    if (!_messageCache.containsKey(courseId)) {
      _messageCache[courseId] = [];
    }

    // Check if message already exists (to avoid duplicates)
    final existingIndex = _messageCache[courseId]!.indexWhere(
      (m) => m.id == message.id,
    );

    if (existingIndex != -1) {
      _messageCache[courseId]![existingIndex] = message;
    } else {
      _messageCache[courseId]!.add(message);
      // Sort by timestamp
      _messageCache[courseId]!.sort(
        (a, b) => a.timestamp.compareTo(b.timestamp),
      );
    }
  }

  /// Update room's last message
  void _updateRoomLastMessage(ChatMessage message) {
    final roomIndex = _chatRooms.indexWhere(
      (r) => r.courseId == message.courseId,
    );

    if (roomIndex != -1) {
      final room = _chatRooms[roomIndex];
      final updatedRoom = ChatRoom(
        id: room.id,
        courseId: room.courseId,
        courseName: room.courseName,
        courseAvatar: room.courseAvatar,
        participants: room.participants,
        lastMessage: message,
        unreadCount: message.senderId != _currentUserId
            ? room.unreadCount + 1
            : room.unreadCount,
        isActive: room.isActive,
        createdAt: room.createdAt,
        lastActivity: message.timestamp,
        metadata: room.metadata,
      );

      _chatRooms[roomIndex] = updatedRoom;
      _roomsController.add(_chatRooms);
    }
  }

  /// Get typing users for a course
  List<String> getTypingUsers(String courseId) {
    return _typingUsers.entries
        .where((entry) => entry.key.startsWith('${courseId}_') && entry.value)
        .map((entry) => entry.key.split('_')[1])
        .toList();
  }

  /// Check if user is online
  bool isUserOnline(String userId) {
    return _onlineUsers[userId] ?? false;
  }

  /// Disconnect socket
  Future<void> disconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    _isConnected = false;
    _currentUserId = null;
    _messageCache.clear();
    _chatRooms.clear();
    _typingUsers.clear();
    _onlineUsers.clear();

    debugPrint('[ChatService] Disconnected and cleaned up');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _roomsController.close();
    _typingController.close();
    _onlineUsersController.close();
    _connectionController.close();
  }
}
