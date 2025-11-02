# API Endpoints & Model Mapping

## 📡 Backend API Endpoints Analysis

### 1. Authentication Module (`/api/v1/auth/`)
```typescript
POST   /login                    // LoginCredentials → AuthResponse
POST   /register                 // RegisterData → AuthResponse  
POST   /refresh-token            // { refreshToken } → { tokens }
POST   /logout                   // {} → success
POST   /change-password          // ChangePasswordData → success
GET    /verify-token             // → { userId, userRole, valid }
GET    /verify-email/:token      // → success
POST   /enable-2fa               // → { qrCode, backupCodes }
POST   /verify-2fa-setup         // { code } → { verified }
POST   /login-2fa                // { email, password, code } → AuthResponse
POST   /disable-2fa              // { code } → success
```

### 2. User Module (`/api/v1/users/`)
```typescript
GET    /profile                  // → UserProfile
PUT    /profile                  // UserUpdateData → UserProfile
POST   /upload-avatar            // FormData → { avatarUrl }
PUT    /preferences              // UserPreferences → UserPreferences
GET    /active-sessions          // → UserSession[]
POST   /logout-all-devices       // → success
POST   /enable-two-factor        // → { qrCode, secret }
POST   /disable-two-factor       // { code } → success
POST   /link-social-account      // { provider, socialId } → success
GET    /analytics                // → UserAnalytics
PUT    /notification-settings    // NotificationSettings → success
PUT    /privacy-settings         // PrivacySettings → success
```

### 3. Course Module (`/api/v1/courses/`)
```typescript
GET    /                        // ?page&limit&status&search → PaginatedCourses
POST   /                        // CourseCreateData → Course
GET    /:id                     // → CourseDetail
PUT    /:id                     // CourseUpdateData → Course
DELETE /:id                     // → success
GET    /instructor/:instructorId // → Course[]
GET    /enrolled                // → EnrolledCourses
POST   /:courseId/enroll        // → Enrollment
DELETE /:courseId/unenroll      // → success
GET    /:courseId/students      // → CourseStudents[]
```

### 4. Course Content Module (`/api/v1/course-content/`)
```typescript
// Sections
GET    /courses/:courseId/sections     // → Section[]
POST   /courses/:courseId/sections     // SectionCreateData → Section
PUT    /sections/:sectionId            // SectionUpdateData → Section
DELETE /sections/:sectionId            // → success

// Lessons  
GET    /sections/:sectionId/lessons    // → Lesson[]
POST   /sections/:sectionId/lessons    // LessonCreateData → Lesson
GET    /lessons/:lessonId              // → LessonDetail
PUT    /lessons/:lessonId              // LessonUpdateData → Lesson
DELETE /lessons/:lessonId              // → success

// Materials
GET    /lessons/:lessonId/materials    // → LessonMaterial[]
POST   /lessons/:lessonId/materials    // MaterialCreateData → LessonMaterial
DELETE /materials/:materialId          // → success

// Progress
GET    /lessons/:lessonId/progress     // → LessonProgress
POST   /lessons/:lessonId/progress     // ProgressUpdateData → LessonProgress
```

### 5. Quiz Module (`/api/v1/quizzes/`)
```typescript
// Quiz Management
POST   /                              // QuizCreateData → Quiz
GET    /:quizId                       // ?include_answers → Quiz
PUT    /:quizId                       // QuizUpdateData → Quiz
DELETE /:quizId                       // → success
GET    /:quizId/questions             // ?include_answers → QuizQuestion[]
GET    /:quizId/statistics            // → QuizStatistics
GET    /:quizId/attempts              // ?page&limit → QuizAttempt[]

// Question Management
POST   /:quizId/questions             // QuestionCreateData → QuizQuestion
PUT    /questions/:questionId         // QuestionUpdateData → QuizQuestion
DELETE /questions/:questionId         // → success
POST   /questions/:questionId/options // OptionCreateData → QuizOption

// Student Attempts
POST   /:quizId/attempts              // → QuizAttempt
POST   /attempts/:attemptId/submit    // QuizAnswers → QuizResult
GET    /:quizId/my-attempts           // → QuizAttempt[]
GET    /attempts/:attemptId/details   // → QuizAttemptDetail
```

### 6. Assignment Module (`/api/v1/assignments/`)
```typescript
// Assignment Management
GET    /                              // ?courseId&page&limit → Assignment[]
POST   /                              // AssignmentCreateData → Assignment
GET    /:assignmentId                 // → AssignmentDetail
PUT    /:assignmentId                 // AssignmentUpdateData → Assignment
DELETE /:assignmentId                 // → success

// Submissions
GET    /:assignmentId/submissions     // → AssignmentSubmission[]
POST   /:assignmentId/submit          // SubmissionData → AssignmentSubmission
GET    /submissions/:submissionId     // → SubmissionDetail
PUT    /submissions/:submissionId/grade // GradeData → success
```

### 7. Grade Module (`/api/v1/grades/`)
```typescript
POST   /                              // GradeCreateData → Grade
PUT    /:gradeId                      // GradeUpdateData → Grade
GET    /users/:userId/courses/:courseId // → UserGrades[]
POST   /final-grades                  // FinalGradeData → FinalGrade
GET    /courses/:courseId/gradebook   // → CourseGradebook
```

### 8. Chat Module (`/api/v1/chat/`)
```typescript
// REST Fallback
GET    /courses/:courseId/messages    // ?page&limit&before&after → ChatMessage[]
POST   /courses/:courseId/messages    // MessageCreateData → ChatMessage
PUT    /messages/:messageId           // MessageUpdateData → ChatMessage
DELETE /messages/:messageId           // → success
GET    /courses/:courseId/messages/search // ?searchTerm → SearchResult[]
GET    /courses/:courseId/statistics  // → ChatStatistics
GET    /courses/:courseId/messages/type/:type // → ChatMessage[]

// Socket.IO Events (Real-time)
// Client → Server
chat:join { courseId, userId }
chat:leave { courseId, userId }
chat:send-message { courseId, message, messageType?, fileUrl?, fileName?, fileSize?, replyTo? }
chat:typing { courseId, userId, isTyping }

// Server → Client  
chat:message-received { message: ChatMessage }
chat:user-joined { userId, username, onlineCount }
chat:user-left { userId, onlineCount }
chat:online-users { users: ChatUser[], count }
chat:typing-indicator { userId, username, isTyping }
```

### 9. Notifications Module (`/api/v1/notifications/`)
```typescript
POST   /                              // NotificationCreateData → Notification
GET    /my-notifications             // ?category&priority&limit&offset → Notification[]
GET    /unread-count                 // → { count }
POST   /mark-all-read                // → { affected }
POST   /archive-old                  // ?days → { archived, affected }
```

### 10. Livestream Module (`/api/v1/livestream/`)
```typescript
// Session Management
POST   /sessions                     // LiveSessionCreateData → LiveSession
GET    /sessions/:sessionId          // → LiveSessionDetail
PUT    /sessions/:sessionId/status   // { status } → LiveSession
POST   /sessions/:sessionId/join     // → LiveSessionAttendance

// Socket.IO Events (WebRTC Signaling)
// Client → Server
livestream:join { sessionId, userId, userType }
livestream:leave { sessionId, userId }
webrtc:offer { sessionId, targetUserId?, offer }
webrtc:answer { sessionId, targetUserId, answer }
webrtc:ice-candidate { sessionId, targetUserId?, candidate }

// Server → Client
livestream:session-started { session: LiveSession }
livestream:session-ended { sessionId }
livestream:participant-joined { participant: SessionParticipant }
livestream:participant-left { userId }
webrtc:offer { fromUserId, offer }
webrtc:answer { fromUserId, answer }
webrtc:ice-candidate { fromUserId, candidate }
```

### 11. Files Module (`/api/v1/files/`)
```typescript
POST   /upload                       // FormData → FileUploadResult
GET    /:fileId                      // → File download
DELETE /:fileId                      // → success
GET    /                             // ?type&courseId → FileInfo[]
```

### 12. Analytics Module (`/api/v1/analytics/`)
```typescript
GET    /courses/:courseId            // → CourseAnalytics
GET    /users/:userId                // → UserAnalytics
GET    /platform                     // → PlatformAnalytics
GET    /engagement                   // → EngagementMetrics
```

## 📊 Data Models Mapping

### 1. User Models
```dart
// Backend User Model → Flutter UserModel
class UserModel {
  final String id;                    // UUID → String
  final String email;                 // email
  final String firstName;             // first_name
  final String lastName;              // last_name
  final String fullName;              // computed: first_name + last_name
  final String? phone;                // phone
  final String? bio;                  // bio
  final String? avatarUrl;            // avatar
  final UserRole role;                // role (enum)
  final UserStatus status;            // status (enum)
  final DateTime? lastLogin;          // last_login
  final Map<String, dynamic>? preferences; // preferences (JSON)
  final Map<String, dynamic>? metadata;    // metadata (JSON)
  
  // Student specific
  final String? studentId;            // student_id
  final String? class_;               // class
  final String? major;                // major
  final int? year;                    // year
  final double? gpa;                  // gpa
  
  // Instructor specific  
  final String? instructorId;         // instructor_id
  final String? department;           // department
  final String? specialization;       // specialization
  final int? experienceYears;         // experience_years
  final EducationLevel? educationLevel; // education_level
  final String? researchInterests;    // research_interests
  
  // Common extended fields
  final DateTime? dateOfBirth;        // date_of_birth
  final Gender? gender;               // gender
  final String? address;              // address
  final String? emergencyContact;     // emergency_contact
  final String? emergencyPhone;       // emergency_phone
  
  final DateTime createdAt;           // created_at
  final DateTime updatedAt;           // updated_at
}

enum UserRole { student, instructor, admin, superAdmin }
enum UserStatus { active, inactive, suspended, pending }
enum EducationLevel { bachelor, master, phd, professor }
enum Gender { male, female, other }
```

### 2. Course Models
```dart
// Backend Course Model → Flutter CourseModel
class CourseModel {
  final String id;                    // UUID → String
  final String title;                 // title
  final String description;           // description
  final String? shortDescription;     // short_description
  final String instructorId;          // instructor_id
  final String? categoryId;           // category_id
  final CourseLevel level;            // level (enum)
  final String language;              // language
  final double price;                 // price (DECIMAL → double)
  final String currency;              // currency
  final bool isFree;                  // is_free
  final bool isFeatured;              // is_featured
  final String? thumbnailUrl;         // thumbnail
  final String? videoIntroUrl;        // video_intro
  final int totalStudents;            // total_students (cache)
  final int totalLessons;             // total_lessons (cache)
  final int? durationHours;           // duration_hours
  final double rating;                // rating (DECIMAL → double)
  final int totalRatings;             // total_ratings
  final CourseStatus status;          // status (enum)
  final DateTime? publishedAt;        // published_at
  final List<String> prerequisites;   // prerequisites (JSON → List)
  final List<String> learningObjectives; // learning_objectives (JSON → List)
  final List<String> tags;            // tags (JSON → List)
  final Map<String, dynamic>? metadata; // metadata (JSON)
  final DateTime createdAt;           // created_at
  final DateTime updatedAt;           // updated_at
}

enum CourseLevel { beginner, intermediate, advanced, expert }
enum CourseStatus { draft, published, archived }

class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int courseCount;
}

class SectionModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderIndex;
  final List<LessonModel> lessons;
}

class LessonModel {
  final String id;
  final String sectionId;
  final String title;
  final String? description;
  final LessonType type;
  final String? contentUrl;
  final int? durationMinutes;
  final int orderIndex;
  final bool isCompleted;
  final List<LessonMaterialModel> materials;
}

enum LessonType { video, document, quiz, assignment, livestream }

class LessonMaterialModel {
  final String id;
  final String lessonId;
  final String title;
  final MaterialType type;
  final String url;
  final int? fileSize;
  final String? description;
}

enum MaterialType { pdf, video, audio, image, document, link }

class LessonProgressModel {
  final String id;
  final String lessonId;
  final String userId;
  final bool isCompleted;
  final int? watchedDuration;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;
}
```

### 3. Quiz Models
```dart
class QuizModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int timeLimit;
  final int maxAttempts;
  final bool isActive;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<QuizQuestionModel> questions;
}

class QuizQuestionModel {
  final String id;
  final String quizId;
  final QuestionType type;
  final String question;
  final double points;
  final int orderIndex;
  final List<QuizOptionModel> options;
  final String? correctAnswer;
}

enum QuestionType { multipleChoice, trueFalse, shortAnswer, essay }

class QuizOptionModel {
  final String id;
  final String questionId;
  final String text;
  final bool isCorrect;
  final int orderIndex;
}

class QuizAttemptModel {
  final String id;
  final String quizId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final AttemptStatus status;
  final double? score;
  final double maxScore;
  final List<QuizAnswerModel> answers;
}

enum AttemptStatus { inProgress, completed, submitted, graded }

class QuizAnswerModel {
  final String id;
  final String attemptId;
  final String questionId;
  final String? answer;
  final List<String>? selectedOptions;
  final bool? isCorrect;
  final double? points;
}
```

### 4. Assignment Models
```dart
class AssignmentModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final DateTime dueDate;
  final double maxPoints;
  final bool allowLateSubmission;
  final AssignmentType type;
  final List<String>? allowedFileTypes;
  final int? maxFileSize;
}

enum AssignmentType { file, text, url, quiz }

class AssignmentSubmissionModel {
  final String id;
  final String assignmentId;
  final String userId;
  final String? content;
  final List<String>? fileUrls;
  final DateTime submittedAt;
  final SubmissionStatus status;
  final double? grade;
  final double? maxGrade;
  final String? feedback;
  final DateTime? gradedAt;
}

enum SubmissionStatus { submitted, graded, returned, late }
```

### 5. Grade Models
```dart
class GradeModel {
  final String id;
  final String userId;
  final String courseId;
  final String? assignmentId;
  final String? quizId;
  final String componentId;
  final double points;
  final double maxPoints;
  final String? feedback;
  final DateTime gradedAt;
}

class GradeComponentModel {
  final String id;
  final String courseId;
  final String name;
  final ComponentType type;
  final double weight;
  final int orderIndex;
}

enum ComponentType { assignment, quiz, exam, participation, project }

class FinalGradeModel {
  final String id;
  final String userId;
  final String courseId;
  final String letterGrade;
  final double percentage;
  final double gpa;
  final DateTime calculatedAt;
}
```

### 6. Chat Models  
```dart
class ChatMessageModel {
  final String id;
  final String courseId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String message;
  final MessageType type;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? replyToId;
  final DateTime timestamp;
  final bool isEdited;
  final DateTime? editedAt;
}

enum MessageType { text, file, image, video, audio, system }

class ChatUserModel {
  final String userId;
  final String username;
  final String? avatarUrl;
  final UserStatus status;
  final DateTime? lastSeen;
}

enum UserStatus { online, away, offline }

class ChatRoomModel {
  final String courseId;
  final String courseName;
  final List<ChatUserModel> onlineUsers;
  final int totalMembers;
  final ChatMessageModel? lastMessage;
}
```

### 7. Notification Models
```dart
class NotificationModel {
  final String id;
  final String? senderId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationCategory category;
  final NotificationPriority priority;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
}

enum NotificationType { info, warning, error, success }
enum NotificationCategory { system, course, assignment, quiz, chat, grade }
enum NotificationPriority { low, normal, high, urgent }

class NotificationRecipientModel {
  final String id;
  final String notificationId;
  final String userId;
  final bool isRead;
  final DateTime? readAt;
  final bool isArchived;
}
```

### 8. Livestream Models
```dart
class LiveSessionModel {
  final String id;
  final String courseId;
  final String instructorId;
  final String title;
  final String? description;
  final DateTime scheduledTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final SessionStatus status;
  final String? recordingUrl;
  final int maxParticipants;
  final List<LiveSessionAttendanceModel> attendees;
}

enum SessionStatus { scheduled, live, ended, cancelled }

class LiveSessionAttendanceModel {
  final String id;
  final String sessionId;
  final String userId;
  final DateTime joinTime;
  final DateTime? leaveTime;
  final int? duration;
}

class WebRTCParticipantModel {
  final String userId;
  final String username;
  final String? avatarUrl;
  final bool isInstructor;
  final bool hasVideo;
  final bool hasAudio;
  final bool isScreenSharing;
  final RTCVideoRenderer? videoRenderer;
}
```

### 9. File Models
```dart
class FileModel {
  final String id;
  final String originalName;
  final String fileName;
  final String mimeType;
  final int size;
  final String url;
  final String? thumbnailUrl;
  final String uploadedBy;
  final String? courseId;
  final String? lessonId;
  final FileCategory category;
  final DateTime uploadedAt;
}

enum FileCategory { 
  courseMaterial, 
  assignment, 
  avatar, 
  thumbnail, 
  video, 
  document, 
  image, 
  audio 
}
```

### 10. Analytics Models
```dart
class UserAnalyticsModel {
  final String userId;
  final int totalCourses;
  final int completedCourses;
  final int inProgressCourses;
  final double averageGrade;
  final int totalQuizzes;
  final int passedQuizzes;
  final int totalAssignments;
  final int submittedAssignments;
  final int totalLoginDays;
  final int streakDays;
  final Map<String, int> activityByDay;
  final Map<String, double> progressBySubject;
}

class CourseAnalyticsModel {
  final String courseId;
  final int totalStudents;
  final int activeStudents;
  final double completionRate;
  final double averageGrade;
  final double averageRating;
  final int totalRatings;
  final Map<String, int> enrollmentsByMonth;
  final Map<String, double> lessonCompletionRates;
  final List<QuizStatisticsModel> quizStatistics;
}

class QuizStatisticsModel {
  final String quizId;
  final String quizTitle;
  final int totalAttempts;
  final double averageScore;
  final double passRate;
  final int uniqueParticipants;
  final Map<String, int> scoreDistribution;
}
```

## 🔧 API Configuration

### Environment Variables
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', 
    defaultValue: 'http://localhost:3000/api');
  static const String socketUrl = String.fromEnvironment('SOCKET_URL', 
    defaultValue: 'http://localhost:3003');
  static const int timeoutSeconds = 30;
  static const int maxRetries = 3;
  static const bool enableLogging = bool.fromEnvironment('DEBUG_MODE', 
    defaultValue: false);
}
```

### Dio Client Configuration
```dart
// lib/core/network/api_client.dart
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: ApiConfig.timeoutSeconds),
      receiveTimeout: Duration(seconds: ApiConfig.timeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(AuthInterceptor());
    
    // Error Interceptor
    _dio.interceptors.add(ErrorInterceptor());
    
    // Logging Interceptor (debug only)
    if (ApiConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
    
    // Retry Interceptor
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      options: RetryOptions(
        retries: ApiConfig.maxRetries,
        retryInterval: Duration(seconds: 1),
      ),
    ));
  }
}
```

### Socket.IO Configuration
```dart
// lib/core/realtime/socket_config.dart
class SocketConfig {
  static IO.Socket createSocket() {
    return IO.io(ApiConfig.socketUrl, 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setTimeout(5000)
        .enableForceNew()
        .build()
    );
  }
}
```

---

**Tổng kết:** File này cung cấp blueprint chi tiết để map toàn bộ backend APIs và models sang Flutter. Mỗi endpoint và model đều được định nghĩa rõ ràng để dev team có thể implement từng phần một cách systematic.