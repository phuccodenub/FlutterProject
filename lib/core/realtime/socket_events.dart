/// Socket.IO Event Definitions for Real-time Features
/// This file defines all events and payloads for socket communication
library;

/// ============================================
/// CHAT EVENTS
/// ============================================

class ChatEvents {
  // Client -> Server
  static const String join = 'chat:join';
  static const String leave = 'chat:leave';
  static const String sendMessage = 'chat:send-message';
  static const String typing = 'chat:typing';

  // Server -> Client
  static const String messageReceived = 'chat:message-received';
  static const String userJoined = 'chat:user-joined';
  static const String userLeft = 'chat:user-left';
  static const String onlineUsers = 'chat:online-users';
  static const String userTyping = 'chat:user-typing';
  static const String userStoppedTyping = 'chat:user-stopped-typing';
}

/// Chat join payload
class ChatJoinPayload {
  ChatJoinPayload({
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.role,
  });

  final String courseId;
  final int userId;
  final String userName;
  final String role;

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'userId': userId,
    'userName': userName,
    'role': role,
  };

  factory ChatJoinPayload.fromJson(Map<String, dynamic> json) {
    return ChatJoinPayload(
      courseId: json['courseId'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      role: json['role'] as String,
    );
  }
}

/// Chat message payload
class ChatMessagePayload {
  ChatMessagePayload({
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.message,
    this.attachmentPath,
    this.attachmentName,
    this.attachmentSize,
    this.timestamp,
  });

  final String courseId;
  final int userId;
  final String userName;
  final String message;
  final String? attachmentPath;
  final String? attachmentName;
  final int? attachmentSize;
  final DateTime? timestamp;

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'userId': userId,
    'userName': userName,
    'message': message,
    if (attachmentPath != null) 'attachmentPath': attachmentPath,
    if (attachmentName != null) 'attachmentName': attachmentName,
    if (attachmentSize != null) 'attachmentSize': attachmentSize,
    'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
  };

  factory ChatMessagePayload.fromJson(Map<String, dynamic> json) {
    return ChatMessagePayload(
      courseId: json['courseId'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      message: json['message'] as String,
      attachmentPath: json['attachmentPath'] as String?,
      attachmentName: json['attachmentName'] as String?,
      attachmentSize: json['attachmentSize'] as int?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }
}

/// Chat typing payload
class ChatTypingPayload {
  ChatTypingPayload({
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.isTyping,
  });

  final String courseId;
  final int userId;
  final String userName;
  final bool isTyping;

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'userId': userId,
    'userName': userName,
    'isTyping': isTyping,
  };

  factory ChatTypingPayload.fromJson(Map<String, dynamic> json) {
    return ChatTypingPayload(
      courseId: json['courseId'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      isTyping: json['isTyping'] as bool,
    );
  }
}

/// ============================================
/// LIVESTREAM EVENTS
/// ============================================

class LivestreamEvents {
  // Client -> Server
  static const String join = 'livestream:join';
  static const String leave = 'livestream:leave';
  static const String offer = 'livestream:webrtc-offer';
  static const String answer = 'livestream:webrtc-answer';
  static const String iceCandidate = 'livestream:ice-candidate';
  static const String toggleVideo = 'livestream:toggle-video';
  static const String toggleAudio = 'livestream:toggle-audio';

  // Server -> Client
  static const String started = 'livestream:started';
  static const String ended = 'livestream:ended';
  static const String participantJoined = 'livestream:participant-joined';
  static const String participantLeft = 'livestream:participant-left';
  static const String receiveOffer = 'livestream:receive-offer';
  static const String receiveAnswer = 'livestream:receive-answer';
  static const String receiveIceCandidate = 'livestream:receive-ice-candidate';
  static const String participantMediaChanged =
      'livestream:participant-media-changed';
}

/// Livestream join payload
class LivestreamJoinPayload {
  LivestreamJoinPayload({
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.role,
  });

  final String roomId;
  final int userId;
  final String userName;
  final String role;

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'userId': userId,
    'userName': userName,
    'role': role,
  };

  factory LivestreamJoinPayload.fromJson(Map<String, dynamic> json) {
    return LivestreamJoinPayload(
      roomId: json['roomId'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      role: json['role'] as String,
    );
  }
}

/// WebRTC Offer/Answer payload
class WebRTCSignalPayload {
  WebRTCSignalPayload({
    required this.roomId,
    required this.fromUserId,
    required this.toUserId,
    required this.sdp,
    required this.type,
  });

  final String roomId;
  final int fromUserId;
  final int toUserId;
  final String sdp;
  final String type; // 'offer' | 'answer'

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'sdp': sdp,
    'type': type,
  };

  factory WebRTCSignalPayload.fromJson(Map<String, dynamic> json) {
    return WebRTCSignalPayload(
      roomId: json['roomId'] as String,
      fromUserId: json['fromUserId'] as int,
      toUserId: json['toUserId'] as int,
      sdp: json['sdp'] as String,
      type: json['type'] as String,
    );
  }
}

/// ICE Candidate payload
class IceCandidatePayload {
  IceCandidatePayload({
    required this.roomId,
    required this.fromUserId,
    required this.toUserId,
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
  });

  final String roomId;
  final int fromUserId;
  final int toUserId;
  final String candidate;
  final String? sdpMid;
  final int? sdpMLineIndex;

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'candidate': candidate,
    'sdpMid': sdpMid,
    'sdpMLineIndex': sdpMLineIndex,
  };

  factory IceCandidatePayload.fromJson(Map<String, dynamic> json) {
    return IceCandidatePayload(
      roomId: json['roomId'] as String,
      fromUserId: json['fromUserId'] as int,
      toUserId: json['toUserId'] as int,
      candidate: json['candidate'] as String,
      sdpMid: json['sdpMid'] as String?,
      sdpMLineIndex: json['sdpMLineIndex'] as int?,
    );
  }
}

/// ============================================
/// QUIZ EVENTS
/// ============================================

class QuizEvents {
  // Client -> Server
  static const String join = 'quiz:join';
  static const String submitAnswer = 'quiz:submit-answer';
  static const String requestHint = 'quiz:request-hint';

  // Server -> Client
  static const String started = 'quiz:started';
  static const String questionChanged = 'quiz:question-changed';
  static const String timeUpdate = 'quiz:time-update';
  static const String ended = 'quiz:ended';
  static const String resultsAvailable = 'quiz:results-available';
  static const String participantAnswered = 'quiz:participant-answered';
}

/// Quiz join payload
class QuizJoinPayload {
  QuizJoinPayload({
    required this.quizId,
    required this.courseId,
    required this.userId,
    required this.userName,
  });

  final String quizId;
  final String courseId;
  final int userId;
  final String userName;

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'courseId': courseId,
    'userId': userId,
    'userName': userName,
  };

  factory QuizJoinPayload.fromJson(Map<String, dynamic> json) {
    return QuizJoinPayload(
      quizId: json['quizId'] as String,
      courseId: json['courseId'] as String,
      userId: json['userId'] as int,
      userName: json['userName'] as String,
    );
  }
}

/// Quiz answer payload
class QuizAnswerPayload {
  QuizAnswerPayload({
    required this.quizId,
    required this.questionId,
    required this.userId,
    required this.answer,
    required this.timeSpent,
  });

  final String quizId;
  final String questionId;
  final int userId;
  final String answer;
  final int timeSpent; // seconds

  Map<String, dynamic> toJson() => {
    'quizId': quizId,
    'questionId': questionId,
    'userId': userId,
    'answer': answer,
    'timeSpent': timeSpent,
  };

  factory QuizAnswerPayload.fromJson(Map<String, dynamic> json) {
    return QuizAnswerPayload(
      quizId: json['quizId'] as String,
      questionId: json['questionId'] as String,
      userId: json['userId'] as int,
      answer: json['answer'] as String,
      timeSpent: json['timeSpent'] as int,
    );
  }
}

/// ============================================
/// NOTIFICATION EVENTS
/// ============================================

class NotificationEvents {
  // Server -> Client
  static const String newNotification = 'notification:new';
  static const String notificationRead = 'notification:read';
  static const String bulkNotification = 'notification:bulk';
}

/// Notification payload
class NotificationPayload {
  NotificationPayload({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    this.priority = 'normal',
  });

  final String id;
  final int userId;
  final String title;
  final String body;
  final String
  type; // 'chat' | 'quiz' | 'livestream' | 'announcement' | 'grade'
  final Map<String, dynamic>? data;
  final String priority; // 'low' | 'normal' | 'high'

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
    'type': type,
    if (data != null) 'data': data,
    'priority': priority,
  };

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      id: json['id'] as String,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>?,
      priority: json['priority'] as String? ?? 'normal',
    );
  }
}
