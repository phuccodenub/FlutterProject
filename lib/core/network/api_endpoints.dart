/// API Endpoints for the LMS application
/// Contains all backend endpoint paths organized by feature modules
class ApiEndpoints {
  // ===== AUTHENTICATION ENDPOINTS =====
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authLogout = '/auth/logout';
  static const String authVerifyToken = '/auth/verify-token';
  static const String authChangePassword = '/auth/change-password';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authEnable2FA = '/auth/enable-2fa';
  static const String authVerify2FASetup = '/auth/verify-2fa-setup';
  static const String authDisable2FA = '/auth/disable-2fa';
  static const String authLoginWith2FA = '/auth/login-2fa';

  // ===== USER MANAGEMENT ENDPOINTS =====
  static const String userProfile = '/users/profile';
  static const String userUpdateProfile = '/users/profile';
  static const String userUploadAvatar = '/users/upload-avatar';
  static const String userPreferences = '/users/preferences';
  static const String userActiveSessions = '/users/active-sessions';
  static const String userLogoutAllDevices = '/users/logout-all-devices';
  static const String userEnableTwoFactor = '/users/enable-two-factor';
  static const String userDisableTwoFactor = '/users/disable-two-factor';
  static const String userLinkSocialAccount = '/users/link-social-account';
  static const String userAnalytics = '/users/analytics';
  static const String userNotificationSettings = '/users/notification-settings';
  static const String userPrivacySettings = '/users/privacy-settings';

  // ===== COURSE ENDPOINTS =====
  static const String courses = '/courses';
  static const String coursesEnrolled = '/courses/enrolled';
  static String courseById(String id) => '/courses/$id';
  static String courseUpdate(String id) => '/courses/$id';
  static String courseDelete(String id) => '/courses/$id';
  static String courseEnroll(String courseId) => '/courses/$courseId/enroll';
  static String courseUnenroll(String courseId) =>
      '/courses/$courseId/unenroll';
  static String courseStudents(String courseId) =>
      '/courses/$courseId/students';
  static String coursesByInstructor(String instructorId) =>
      '/courses/instructor/$instructorId';

  // ===== COURSE CONTENT ENDPOINTS =====
  static String courseSections(String courseId) =>
      '/course-content/courses/$courseId/sections';
  static const String courseContentSections = '/course-content/sections';
  static String sectionUpdate(String sectionId) =>
      '/course-content/sections/$sectionId';
  static String sectionDelete(String sectionId) =>
      '/course-content/sections/$sectionId';
  static String sectionLessons(String sectionId) =>
      '/course-content/sections/$sectionId/lessons';
  static String lessonById(String lessonId) =>
      '/course-content/lessons/$lessonId';
  static String lessonUpdate(String lessonId) =>
      '/course-content/lessons/$lessonId';
  static String lessonDelete(String lessonId) =>
      '/course-content/lessons/$lessonId';
  static String lessonMaterials(String lessonId) =>
      '/course-content/lessons/$lessonId/materials';
  static String materialDelete(String materialId) =>
      '/course-content/materials/$materialId';
  static String lessonProgress(String lessonId) =>
      '/course-content/lessons/$lessonId/progress';

  // ===== QUIZ ENDPOINTS =====
  static const String quizzes = '/quizzes';
  static String quizById(String quizId) => '/quizzes/$quizId';
  static String quizUpdate(String quizId) => '/quizzes/$quizId';
  static String quizDelete(String quizId) => '/quizzes/$quizId';
  static String quizQuestions(String quizId) => '/quizzes/$quizId/questions';
  static String quizStatistics(String quizId) => '/quizzes/$quizId/statistics';
  static String quizAttempts(String quizId) => '/quizzes/$quizId/attempts';
  static String quizMyAttempts(String quizId) => '/quizzes/$quizId/my-attempts';
  static String questionUpdate(String questionId) =>
      '/quizzes/questions/$questionId';
  static String questionDelete(String questionId) =>
      '/quizzes/questions/$questionId';
  static String questionAddOption(String questionId) =>
      '/quizzes/questions/$questionId/options';
  static String quizStartAttempt(String quizId) => '/quizzes/$quizId/attempts';
  static String attemptSubmit(String attemptId) =>
      '/quizzes/attempts/$attemptId/submit';
  static String attemptDetails(String attemptId) =>
      '/quizzes/attempts/$attemptId/details';

  // ===== ASSIGNMENT ENDPOINTS =====
  static const String assignments = '/assignments';
  static String assignmentById(String assignmentId) =>
      '/assignments/$assignmentId';
  static String assignmentUpdate(String assignmentId) =>
      '/assignments/$assignmentId';
  static String assignmentDelete(String assignmentId) =>
      '/assignments/$assignmentId';
  static String assignmentSubmissions(String assignmentId) =>
      '/assignments/$assignmentId/submissions';
  static String assignmentSubmit(String assignmentId) =>
      '/assignments/$assignmentId/submit';
  static String submissionById(String submissionId) =>
      '/assignments/submissions/$submissionId';
  static String submissionGrade(String submissionId) =>
      '/assignments/submissions/$submissionId/grade';

  // ===== GRADE ENDPOINTS =====
  static const String grades = '/grades';
  static String gradeUpdate(String gradeId) => '/grades/$gradeId';
  static String userGrades(String userId, String courseId) =>
      '/grades/users/$userId/courses/$courseId';
  static const String finalGrades = '/grades/final-grades';
  static String courseGradebook(String courseId) =>
      '/grades/courses/$courseId/gradebook';

  // ===== CHAT ENDPOINTS =====
  static String courseMessages(String courseId) =>
      '/chat/courses/$courseId/messages';
  static String messageUpdate(String messageId) => '/chat/messages/$messageId';
  static String messageDelete(String messageId) => '/chat/messages/$messageId';
  static String courseMessageSearch(String courseId) =>
      '/chat/courses/$courseId/messages/search';
  static String chatStatistics(String courseId) =>
      '/chat/courses/$courseId/statistics';
  static String messagesByType(String courseId, String messageType) =>
      '/chat/courses/$courseId/messages/type/$messageType';

  // ===== NOTIFICATION ENDPOINTS =====
  static const String notifications = '/notifications';
  static const String notificationsMyNotifications =
      '/notifications/my-notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';
  static const String notificationsArchiveOld = '/notifications/archive-old';

  // ===== LIVESTREAM ENDPOINTS =====
  static const String livestreamSessions = '/livestream/sessions';
  static String livestreamSessionById(String sessionId) =>
      '/livestream/sessions/$sessionId';
  static String livestreamSessionStatus(String sessionId) =>
      '/livestream/sessions/$sessionId/status';
  static String livestreamSessionJoin(String sessionId) =>
      '/livestream/sessions/$sessionId/join';

  // ===== FILE ENDPOINTS =====
  static const String filesUpload = '/files/upload';
  static String fileById(String fileId) => '/files/$fileId';
  static String fileDelete(String fileId) => '/files/$fileId';
  static const String files = '/files';

  // ===== ANALYTICS ENDPOINTS =====
  static String courseAnalytics(String courseId) =>
      '/analytics/courses/$courseId';
  static String analyticsUser(String userId) => '/analytics/users/$userId';
  static const String platformAnalytics = '/analytics/platform';
  static const String engagementAnalytics = '/analytics/engagement';

  // ===== ADMIN ENDPOINTS (Future use) =====
  static const String adminUsers = '/admin/users';
  static const String adminCourses = '/admin/courses';
  static const String adminStatistics = '/admin/statistics';
  static const String adminSettings = '/admin/settings';

  // ===== UTILITY METHODS =====

  /// Build query string from parameters
  static String buildQueryString(Map<String, dynamic> params) {
    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map(
          (entry) =>
              '${entry.key}=${Uri.encodeComponent(entry.value.toString())}',
        )
        .join('&');
    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }

  /// Get paginated endpoint with query parameters
  static String getPaginatedEndpoint(
    String baseEndpoint, {
    int? page,
    int? limit,
    Map<String, dynamic>? additionalParams,
  }) {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (additionalParams != null) params.addAll(additionalParams);

    return '$baseEndpoint${buildQueryString(params)}';
  }

  /// Get search endpoint with query parameters
  static String getSearchEndpoint(
    String baseEndpoint, {
    required String searchTerm,
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, dynamic>{'search': searchTerm};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (filters != null) params.addAll(filters);

    return '$baseEndpoint${buildQueryString(params)}';
  }
}

/// Socket.IO Events for real-time features
class SocketEvents {
  // ===== CONNECTION EVENTS =====
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';

  // ===== CHAT EVENTS =====
  // Client to Server
  static const String chatJoin = 'chat:join';
  static const String chatLeave = 'chat:leave';
  static const String chatSendMessage = 'chat:send-message';
  static const String chatTyping = 'chat:typing';

  // Server to Client
  static const String chatMessageReceived = 'chat:message-received';
  static const String chatUserJoined = 'chat:user-joined';
  static const String chatUserLeft = 'chat:user-left';
  static const String chatOnlineUsers = 'chat:online-users';
  static const String chatTypingIndicator = 'chat:typing-indicator';

  // ===== LIVESTREAM EVENTS =====
  // Client to Server
  static const String livestreamJoin = 'livestream:join';
  static const String livestreamLeave = 'livestream:leave';

  // Server to Client
  static const String livestreamSessionStarted = 'livestream:session-started';
  static const String livestreamSessionEnded = 'livestream:session-ended';
  static const String livestreamParticipantJoined =
      'livestream:participant-joined';
  static const String livestreamParticipantLeft = 'livestream:participant-left';

  // ===== WEBRTC SIGNALING EVENTS =====
  // Client to Server
  static const String webrtcOffer = 'webrtc:offer';
  static const String webrtcAnswer = 'webrtc:answer';
  static const String webrtcIceCandidate = 'webrtc:ice-candidate';

  // Server to Client
  static const String webrtcOfferReceived = 'webrtc:offer';
  static const String webrtcAnswerReceived = 'webrtc:answer';
  static const String webrtcIceCandidateReceived = 'webrtc:ice-candidate';

  // ===== NOTIFICATION EVENTS =====
  // Server to Client
  static const String notificationNew = 'notification:new';
  static const String notificationUpdate = 'notification:update';
  static const String notificationMarkRead = 'notification:mark-read';

  // ===== QUIZ EVENTS =====
  // Client to Server
  static const String quizJoin = 'quiz:join';
  static const String quizSubmitAnswer = 'quiz:submit-answer';

  // Server to Client
  static const String quizStarted = 'quiz:started';
  static const String quizEnded = 'quiz:ended';
  static const String quizResultsReady = 'quiz:results-ready';
}
