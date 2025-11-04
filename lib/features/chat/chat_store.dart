import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentSize,
  });
  final String id;
  final String courseId;
  final int userId;
  final String userName;
  final String message;
  final DateTime timestamp;
  final String? attachmentPath;
  final String? attachmentName;
  final int? attachmentSize; // bytes

  ChatMessage copyWith({
    String? id,
    String? courseId,
    int? userId,
    String? userName,
    String? message,
    DateTime? timestamp,
    String? attachmentPath,
    String? attachmentName,
    int? attachmentSize,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      attachmentName: attachmentName ?? this.attachmentName,
      attachmentSize: attachmentSize ?? this.attachmentSize,
    );
  }
}

class OnlineUser {
  const OnlineUser({
    required this.id,
    required this.name,
    required this.role,
    this.status = 'online',
    this.lastSeen,
    this.avatarUrl,
  });
  final int id;
  final String name;
  final String role; // student | instructor
  final String status; // online | away | offline
  final DateTime? lastSeen;
  final String? avatarUrl;

  OnlineUser copyWith({
    int? id,
    String? name,
    String? role,
    String? status,
    DateTime? lastSeen,
    String? avatarUrl,
  }) {
    return OnlineUser(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ChatState {
  const ChatState({
    this.messagesByCourse = const {},
    this.onlineUsersByCourse = const {},
    this.typingUsers = const {},
    this.lastSeenMap = const {},
  });
  final Map<String, List<ChatMessage>> messagesByCourse;
  final Map<String, List<OnlineUser>> onlineUsersByCourse;
  final Map<String, Set<int>> typingUsers; // courseId -> Set of userIds
  final Map<int, DateTime> lastSeenMap; // userId -> lastSeen

  ChatState copyWith({
    Map<String, List<ChatMessage>>? messagesByCourse,
    Map<String, List<OnlineUser>>? onlineUsersByCourse,
    Map<String, Set<int>>? typingUsers,
    Map<int, DateTime>? lastSeenMap,
  }) {
    return ChatState(
      messagesByCourse: messagesByCourse ?? this.messagesByCourse,
      onlineUsersByCourse: onlineUsersByCourse ?? this.onlineUsersByCourse,
      typingUsers: typingUsers ?? this.typingUsers,
      lastSeenMap: lastSeenMap ?? this.lastSeenMap,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  Timer? _typingDebounce;

  void sendMessage(
    String courseId,
    int userId,
    String userName,
    String message, {
    String? attachmentPath,
    String? attachmentName,
    int? attachmentSize,
  }) {
    final msg = ChatMessage(
      id: 'm-${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      userId: userId,
      userName: userName,
      message: message,
      timestamp: DateTime.now(),
      attachmentPath: attachmentPath,
      attachmentName: attachmentName,
      attachmentSize: attachmentSize,
    );
    final list = List<ChatMessage>.from(
      state.messagesByCourse[courseId] ?? const [],
    );
    list.add(msg);
    state = state.copyWith(
      messagesByCourse: {...state.messagesByCourse, courseId: list},
    );

    // Clear typing indicator for this user
    setTyping(courseId, userId, false);

    // Demo simulate reply
    Future.delayed(const Duration(seconds: 2), () {
      final reply = ChatMessage(
        id: 'r-${DateTime.now().millisecondsSinceEpoch}',
        courseId: courseId,
        userId: 0,
        userName: 'Assistant',
        message: 'Thanks for your message!',
        timestamp: DateTime.now(),
      );
      final l2 = List<ChatMessage>.from(
        state.messagesByCourse[courseId] ?? const [],
      );
      l2.add(reply);
      state = state.copyWith(
        messagesByCourse: {...state.messagesByCourse, courseId: l2},
      );
    });
  }

  // Typing indicator with debounce
  void setTyping(String courseId, int userId, bool isTyping) {
    final currentTypers = Set<int>.from(state.typingUsers[courseId] ?? {});
    if (isTyping) {
      currentTypers.add(userId);
    } else {
      currentTypers.remove(userId);
    }
    state = state.copyWith(
      typingUsers: {...state.typingUsers, courseId: currentTypers},
    );

    // Auto-clear after timeout
    if (isTyping) {
      _typingDebounce?.cancel();
      _typingDebounce = Timer(const Duration(seconds: 3), () {
        setTyping(courseId, userId, false);
      });
    }
  }

  bool isTyping(String courseId, int userId) {
    return state.typingUsers[courseId]?.contains(userId) ?? false;
  }

  Set<int> getTypingUsers(String courseId) {
    return state.typingUsers[courseId] ?? {};
  }

  // Last seen per user
  void updateLastSeen(int userId) {
    state = state.copyWith(
      lastSeenMap: {...state.lastSeenMap, userId: DateTime.now()},
    );
  }

  DateTime? lastSeenOf(int userId) => state.lastSeenMap[userId];

  String getLastSeenText(int userId) {
    final lastSeen = state.lastSeenMap[userId];
    if (lastSeen == null) return 'Never';

    final diff = DateTime.now().difference(lastSeen);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void simulateOnlineUsers(
    String courseId, {
    String currentUserRole = 'student',
  }) {
    final base = <OnlineUser>[
      OnlineUser(
        id: 1,
        name: 'Dr. John Smith',
        role: 'instructor',
        status: 'online',
        lastSeen: DateTime.now(),
      ),
      OnlineUser(
        id: 2,
        name: 'Jane Doe',
        role: 'student',
        status: 'online',
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      OnlineUser(
        id: 3,
        name: 'Alice Johnson',
        role: 'student',
        status: 'away',
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      OnlineUser(
        id: 4,
        name: 'Bob Wilson',
        role: 'student',
        status: 'offline',
        lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    final list = currentUserRole == 'student'
        ? base
        : base.where((u) => u.role == 'student').toList();
    state = state.copyWith(
      onlineUsersByCourse: {...state.onlineUsersByCourse, courseId: list},
    );

    // Update lastSeenMap
    final newLastSeen = {...state.lastSeenMap};
    for (var user in list) {
      if (user.lastSeen != null) {
        newLastSeen[user.id] = user.lastSeen!;
      }
    }
    state = state.copyWith(lastSeenMap: newLastSeen);
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    super.dispose();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(),
);
