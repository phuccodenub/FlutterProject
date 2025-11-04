import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_models.dart';
import '../services/chat_service.dart';
import '../../auth/auth_state.dart';

/// Chat State Management with Riverpod
class ChatState {
  final List<ChatRoom> chatRooms;
  final Map<String, List<ChatMessage>> courseMessages;
  final Map<String, bool> typingUsers;
  final Map<String, bool> onlineUsers;
  final String connectionStatus;
  final bool isLoading;
  final String? error;
  final String? currentCourseId;

  const ChatState({
    this.chatRooms = const [],
    this.courseMessages = const {},
    this.typingUsers = const {},
    this.onlineUsers = const {},
    this.connectionStatus = 'disconnected',
    this.isLoading = false,
    this.error,
    this.currentCourseId,
  });

  ChatState copyWith({
    List<ChatRoom>? chatRooms,
    Map<String, List<ChatMessage>>? courseMessages,
    Map<String, bool>? typingUsers,
    Map<String, bool>? onlineUsers,
    String? connectionStatus,
    bool? isLoading,
    String? error,
    String? currentCourseId,
  }) {
    return ChatState(
      chatRooms: chatRooms ?? this.chatRooms,
      courseMessages: courseMessages ?? this.courseMessages,
      typingUsers: typingUsers ?? this.typingUsers,
      onlineUsers: onlineUsers ?? this.onlineUsers,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentCourseId: currentCourseId ?? this.currentCourseId,
    );
  }
}

/// Chat Provider
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._chatService, this._authNotifier)
    : super(const ChatState()) {
    _initialize();
  }

  final ChatService _chatService;
  final AuthNotifier _authNotifier;

  /// Initialize chat service and set up listeners
  void _initialize() {
    // Listen to auth state changes
    _authNotifier.addListener((authState) {
      if (authState.isAuthenticated && authState.user != null) {
        _initializeChatService(authState.user!.id, authState.token!);
      } else {
        _disconnectChatService();
      }
    });

    // Set up chat service listeners
    _setupChatListeners();
  }

  /// Initialize chat service with user credentials
  Future<void> _initializeChatService(String userId, String token) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _chatService.initialize(userId, token);
      await loadChatRooms();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize chat: $e',
      );
    }
  }

  /// Disconnect chat service
  Future<void> _disconnectChatService() async {
    await _chatService.disconnect();
    state = const ChatState();
  }

  /// Set up chat service event listeners
  void _setupChatListeners() {
    // Connection status
    _chatService.connectionStream.listen((status) {
      state = state.copyWith(connectionStatus: status);

      if (status == 'error') {
        state = state.copyWith(error: 'Connection error');
      }
    });

    // New messages
    _chatService.messageStream.listen((message) {
      _addMessageToState(message);
    });

    // Chat rooms updates
    _chatService.roomsStream.listen((rooms) {
      state = state.copyWith(chatRooms: rooms);
    });

    // Typing indicators
    _chatService.typingStream.listen((typingUsers) {
      state = state.copyWith(typingUsers: typingUsers);
    });

    // Online users
    _chatService.onlineUsersStream.listen((onlineUsers) {
      state = state.copyWith(onlineUsers: onlineUsers);
    });
  }

  /// Load chat rooms
  Future<void> loadChatRooms() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rooms = await _chatService.getChatRooms();
      state = state.copyWith(chatRooms: rooms, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load chat rooms: $e',
      );
    }
  }

  /// Load messages for a course
  Future<void> loadCourseMessages(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final messages = await _chatService.getCourseMessages(courseId);
      final updatedMessages = Map<String, List<ChatMessage>>.from(
        state.courseMessages,
      );
      updatedMessages[courseId] = messages;

      state = state.copyWith(
        courseMessages: updatedMessages,
        isLoading: false,
        currentCourseId: courseId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages: $e',
      );
    }
  }

  /// Join course chat room
  Future<void> joinCourseRoom(String courseId) async {
    try {
      await _chatService.joinCourseRoom(courseId);
      await loadCourseMessages(courseId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to join course room: $e');
    }
  }

  /// Leave course chat room
  Future<void> leaveCourseRoom(String courseId) async {
    try {
      await _chatService.leaveCourseRoom(courseId);
      state = state.copyWith(currentCourseId: null);
    } catch (e) {
      state = state.copyWith(error: 'Failed to leave course room: $e');
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
    try {
      final message = await _chatService.sendMessage(
        courseId: courseId,
        content: content,
        type: type,
        replyToId: replyToId,
        attachments: attachments,
      );

      if (message != null) {
        _addMessageToState(message);
      }

      return message;
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: $e');
      return null;
    }
  }

  /// Send typing indicator
  void sendTypingIndicator(String courseId, bool isTyping) {
    _chatService.sendTypingIndicator(courseId, isTyping);
  }

  /// Mark message as read
  Future<void> markMessageAsRead(String messageId, String courseId) async {
    try {
      await _chatService.markMessageAsRead(messageId, courseId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to mark message as read: $e');
    }
  }

  /// Add message to state
  void _addMessageToState(ChatMessage message) {
    final updatedMessages = Map<String, List<ChatMessage>>.from(
      state.courseMessages,
    );

    if (!updatedMessages.containsKey(message.courseId)) {
      updatedMessages[message.courseId] = [];
    }

    // Check if message already exists (to avoid duplicates)
    final existingIndex = updatedMessages[message.courseId]!.indexWhere(
      (m) => m.id == message.id,
    );

    if (existingIndex != -1) {
      updatedMessages[message.courseId]![existingIndex] = message;
    } else {
      updatedMessages[message.courseId]!.add(message);
      // Sort by timestamp
      updatedMessages[message.courseId]!.sort(
        (a, b) => a.timestamp.compareTo(b.timestamp),
      );
    }

    state = state.copyWith(courseMessages: updatedMessages);
  }

  /// Get messages for a course
  List<ChatMessage> getCourseMessages(String courseId) {
    return state.courseMessages[courseId] ?? [];
  }

  /// Get typing users for a course
  List<String> getTypingUsers(String courseId) {
    return _chatService.getTypingUsers(courseId);
  }

  /// Check if user is online
  bool isUserOnline(String userId) {
    return _chatService.isUserOnline(userId);
  }

  /// Get chat room by course ID
  ChatRoom? getChatRoomByCourseId(String courseId) {
    try {
      return state.chatRooms.firstWhere((room) => room.courseId == courseId);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Dispose resources
  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
  }
}

/// Chat Provider Instance
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ChatService();
  final authNotifier = ref.watch(authProvider.notifier);

  return ChatNotifier(chatService, authNotifier);
});

/// Connection Status Provider
final connectionStatusProvider = Provider<String>((ref) {
  return ref.watch(chatProvider.select((state) => state.connectionStatus));
});

/// Current Course Messages Provider
final currentCourseMessagesProvider =
    Provider.family<List<ChatMessage>, String>((ref, courseId) {
      return ref.watch(
        chatProvider.select((state) => state.courseMessages[courseId] ?? []),
      );
    });

/// Chat Rooms Provider
final chatRoomsProvider = Provider<List<ChatRoom>>((ref) {
  return ref.watch(chatProvider.select((state) => state.chatRooms));
});

/// Typing Users Provider
final typingUsersProvider = Provider.family<List<String>, String>((
  ref,
  courseId,
) {
  final chatNotifier = ref.watch(chatProvider.notifier);
  return chatNotifier.getTypingUsers(courseId);
});

/// Online Status Provider
final onlineStatusProvider = Provider.family<bool, String>((ref, userId) {
  final chatNotifier = ref.watch(chatProvider.notifier);
  return chatNotifier.isUserOnline(userId);
});

/// Chat Loading Provider
final chatLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider.select((state) => state.isLoading));
});

/// Chat Error Provider
final chatErrorProvider = Provider<String?>((ref) {
  return ref.watch(chatProvider.select((state) => state.error));
});
