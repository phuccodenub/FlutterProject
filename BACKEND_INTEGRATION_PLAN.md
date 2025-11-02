# Backend Integration Plan - LMS Mobile Flutter

## 🎯 Tổng Quan

Dựa trên phân tích backend Node.js/TypeScript và Flutter project hiện tại, đây là kế hoạch chi tiết để kết hợp chúng thành một hệ thống LMS hoàn chỉnh.

## 📊 Backend Analysis Summary

### Core Models đã có
```typescript
User, Course, Enrollment, Category, Section, Lesson, LessonMaterial, 
LessonProgress, Quiz, QuizQuestion, QuizOption, QuizAttempt, QuizAnswer,
Assignment, AssignmentSubmission, Grade, GradeComponent, FinalGrade,
LiveSession, LiveSessionAttendance, Notification, NotificationRecipient,
ChatMessage, UserActivityLog, CourseStatistics, PasswordResetToken
```

### Modules đã có
```
auth, user, course, course-content, quiz, assignment, grade, 
chat, notifications, livestream, analytics, files, webrtc
```

### API Endpoints có sẵn
```
Auth: /login, /register, /refresh-token, /logout, /change-password
User: /profile, /update-profile, /preferences, /sessions
Course: CRUD operations, enrollment, students management  
Chat: Socket.IO + REST fallback
Quiz: Full CRUD, attempts, grading, statistics
Notifications: CRUD, mark read, archive
Livestream: WebRTC signaling, sessions
Files: Upload, download, management
```

## 🏗️ Flutter Structure Mapping

### 1. Authentication Module
**Backend:** `src/modules/auth/`
**Flutter:** `lib/features/auth/`

```dart
// Cần tạo:
lib/features/auth/
├── models/
│   ├── user_model.dart          // Map từ User model backend
│   ├── login_request.dart       // Map từ LoginCredentials
│   ├── register_request.dart    // Map từ RegisterData
│   └── auth_response.dart       // Response từ backend
├── services/
│   ├── auth_service.dart        // HTTP calls tới auth endpoints
│   └── token_service.dart       // JWT token management
├── providers/
│   ├── auth_provider.dart       // Riverpod state management
│   └── user_provider.dart       // User data management
└── screens/
    ├── login_screen.dart        // ✅ Đã có - cần update
    ├── register_screen.dart     // ✅ Đã có - cần update
    ├── forgot_password_screen.dart // ✅ Đã có
    ├── email_verification_screen.dart // Cần tạo
    └── two_factor_screen.dart   // Cần tạo (2FA)
```

### 2. Course Management
**Backend:** `src/modules/course/` + `src/modules/course-content/`
**Flutter:** `lib/features/courses/`

```dart
// Cần mở rộng:
lib/features/courses/
├── models/
│   ├── course_model.dart        // ✅ Đã có - cần update
│   ├── section_model.dart       // Cần tạo
│   ├── lesson_model.dart        // Cần tạo  
│   ├── lesson_material_model.dart // Cần tạo
│   ├── lesson_progress_model.dart // Cần tạo
│   ├── enrollment_model.dart    // Cần tạo
│   └── category_model.dart      // Cần tạo
├── services/
│   ├── courses_service.dart     // ✅ Đã có - cần update
│   ├── enrollment_service.dart  // Cần tạo
│   └── progress_service.dart    // Cần tạo
├── providers/
│   ├── courses_provider.dart    // Cần tạo
│   ├── my_courses_provider.dart // Cần tạo
│   └── course_detail_provider.dart // Cần tạo
└── screens/
    ├── courses_list_screen.dart // Cần tạo
    ├── course_detail_screen.dart // ✅ Đã có base
    ├── lesson_detail_screen.dart // Cần tạo
    ├── video_player_screen.dart // Cần tạo
    └── course_search_screen.dart // Cần tạo
```

### 3. Chat System
**Backend:** `src/modules/chat/` + Socket.IO Gateway
**Flutter:** `lib/features/chat/`

```dart
// Cần update để kết nối backend:
lib/features/chat/
├── models/
│   ├── chat_message_model.dart  // Map từ ChatMessage model
│   ├── chat_user_model.dart     // Online users
│   └── chat_room_model.dart     // Course chat room
├── services/
│   ├── chat_service.dart        // REST API fallback
│   └── chat_socket_service.dart // Socket.IO connection  
├── providers/
│   └── chat_store.dart          // ✅ Đã có - cần update
└── widgets/
    ├── chat_tab.dart            // ✅ Đã có
    ├── message_bubble.dart      // Cần tạo
    ├── typing_indicator.dart    // Cần tạo
    └── file_attachment_widget.dart // Cần tạo
```

### 4. Quiz System  
**Backend:** `src/modules/quiz/`
**Flutter:** `lib/features/quiz/`

```dart
// Cần update để sync với backend:
lib/features/quiz/
├── models/
│   ├── quiz_model.dart          // Map từ Quiz model
│   ├── quiz_question_model.dart // Map từ QuizQuestion
│   ├── quiz_option_model.dart   // Map từ QuizOption
│   ├── quiz_attempt_model.dart  // Map từ QuizAttempt
│   └── quiz_answer_model.dart   // Map từ QuizAnswer
├── services/
│   └── quiz_service.dart        // ✅ Đã có - cần update API calls
├── providers/
│   ├── quiz_provider.dart       // Cần tạo
│   └── quiz_attempt_provider.dart // Cần tạo
└── screens/
    ├── quiz_list_screen.dart    // Cần tạo
    ├── quiz_detail_screen.dart  // Cần tạo
    ├── quiz_taking_screen.dart  // Cần tạo
    └── quiz_result_screen.dart  // Cần tạo
```

### 5. Assignment System
**Backend:** `src/modules/assignment/`
**Flutter:** `lib/features/assignment/` (Cần tạo hoàn toàn)

```dart
lib/features/assignment/
├── models/
│   ├── assignment_model.dart
│   └── assignment_submission_model.dart
├── services/
│   └── assignment_service.dart
├── providers/
│   ├── assignment_provider.dart
│   └── submission_provider.dart
└── screens/
    ├── assignment_list_screen.dart
    ├── assignment_detail_screen.dart
    ├── assignment_submission_screen.dart
    └── assignment_grading_screen.dart
```

### 6. Grade Management
**Backend:** `src/modules/grade/`
**Flutter:** `lib/features/grades/` (Cần tạo hoàn toàn)

```dart
lib/features/grades/
├── models/
│   ├── grade_model.dart
│   ├── grade_component_model.dart
│   └── final_grade_model.dart
├── services/
│   └── grade_service.dart
├── providers/
│   └── grade_provider.dart
└── screens/
    ├── gradebook_screen.dart
    ├── grade_detail_screen.dart
    └── grade_statistics_screen.dart
```

### 7. Notifications
**Backend:** `src/modules/notifications/`
**Flutter:** `lib/features/notifications/`

```dart
// Cần update để kết nối backend:
lib/features/notifications/
├── models/
│   ├── notification_model.dart  // ✅ Đã có - cần update
│   └── notification_recipient_model.dart
├── services/
│   ├── notification_service.dart // REST API
│   └── local_notification_service.dart // ✅ Đã có
├── providers/
│   └── notification_store.dart  // ✅ Đá có - cần update
└── screens/
    ├── notifications_screen.dart // ✅ Đã có
    └── notification_settings_screen.dart // Cần tạo
```

### 8. Livestream  
**Backend:** `src/modules/livestream/` + WebRTC Gateway
**Flutter:** `lib/features/livestream/`

```dart
// Cần update để kết nối backend:
lib/features/livestream/
├── models/
│   ├── live_session_model.dart  // Map từ LiveSession
│   └── live_session_attendance_model.dart
├── services/
│   ├── livestream_service.dart  // REST API
│   └── webrtc_service.dart      // WebRTC signaling
├── providers/
│   └── livestream_store.dart    // ✅ Đã có - cần update
└── screens/
    └── livestream_screen.dart   // ✅ Đã có - cần update
```

### 9. File Management
**Backend:** `src/modules/files/`
**Flutter:** `lib/features/files/`

```dart
// Cần update để kết nối backend:
lib/features/files/
├── models/
│   └── file_model.dart          // ✅ Đã có - cần update
├── services/
│   └── file_service.dart        // ✅ Đã có - cần update
├── providers/
│   └── file_provider.dart       // Cần tạo
└── widgets/
    ├── file_upload_widget.dart  // Cần tạo
    ├── file_viewer_widget.dart  // Cần tạo
    └── file_list_widget.dart    // Cần tạo
```

### 10. Analytics
**Backend:** `src/modules/analytics/`
**Flutter:** `lib/features/analytics/`

```dart
// Cần update:
lib/features/analytics/
├── models/
│   ├── course_statistics_model.dart
│   ├── user_activity_model.dart
│   └── learning_analytics_model.dart
├── services/
│   ├── analytics_service.dart
│   └── learning_analytics_service.dart // ✅ Đã có
├── providers/
│   └── analytics_provider.dart
└── screens/
    ├── analytics_dashboard_screen.dart
    ├── course_analytics_screen.dart
    └── student_progress_screen.dart
```

## 🔧 Core Infrastructure Updates

### 1. Network Layer
```dart
// lib/core/network/
├── api_client.dart              // Dio configuration
├── api_endpoints.dart           // All backend endpoints
├── api_interceptors.dart        // Auth, error handling
├── socket_client.dart           // ✅ Đã có - cần update
└── network_error_handler.dart   // Error mapping
```

### 2. State Management
```dart
// lib/core/providers/
├── app_providers.dart           // Global providers
├── auth_providers.dart          // Auth state
└── socket_providers.dart        // Socket connection state
```

### 3. Storage Layer
```dart
// lib/core/storage/
├── hive_service.dart            // Hive configuration
├── secure_storage.dart          // Tokens, sensitive data
└── cache_service.dart           // API response caching
```

### 4. Configuration
```dart
// lib/core/config/
├── app_config.dart              // ✅ Đã có - cần update
├── api_config.dart              // API URLs, timeouts
└── socket_config.dart           // Socket.IO configuration
```

## 📱 Screen Structure Mapping

### Student Role Screens
```
📱 Student Dashboard
├── 📊 Learning Progress Overview
├── 📚 My Courses (Enrolled)
├── 📝 Recent Assignments  
├── 🔔 Recent Notifications
├── 📺 Upcoming Live Sessions
└── 📈 Learning Analytics

📚 Courses
├── 🔍 Course Search & Filter
├── 📋 Course Categories
├── 📖 Course Detail
│   ├── 📑 Overview & Syllabus
│   ├── 📺 Lessons & Materials
│   ├── 💬 Course Chat
│   ├── 📝 Assignments
│   ├── 🎯 Quizzes
│   └── 📊 My Progress
└── ⭐ My Enrollments

📝 Assignments
├── 📋 Assignment List
├── 📖 Assignment Detail
├── 📤 Submit Assignment
└── 📊 Assignment Grades

🎯 Quizzes  
├── 📋 Available Quizzes
├── 🎯 Take Quiz
├── 📊 Quiz Results
└── 📈 Quiz History

📊 Grades
├── 📊 Grade Overview
├── 📈 Grade Trends
└── 📋 Detailed Gradebook

💬 Messages
├── 📱 Course Chats
├── 👥 Direct Messages
└── 🔔 Chat Notifications

📺 Live Sessions
├── 📅 Upcoming Sessions
├── 🎥 Join Live Session
└── 📹 Session Recordings
```

### Instructor Role Screens  
```
📱 Teacher Dashboard
├── 📊 Teaching Analytics
├── 📚 My Courses (Teaching)
├── 👥 Student Management
├── 📝 Assignment Reviews
└── 🔔 Student Activities

📚 Course Management
├── ➕ Create Course
├── 📝 Edit Course Content
├── 📑 Manage Sections/Lessons
├── 📤 Upload Materials
└── 👥 Enrolled Students

📝 Assignment Management
├── ➕ Create Assignment
├── 📋 Assignment List
├── 📊 Review Submissions
└── ✅ Grade Submissions

🎯 Quiz Management
├── ➕ Create Quiz
├── 📋 Quiz List
├── 📊 Quiz Analytics
└── ✅ Review Attempts

📊 Gradebook
├── 👥 Student Grades
├── 📈 Grade Analytics
├── 📊 Class Performance
└── 📋 Grade Components

📺 Live Teaching
├── 🎥 Start Live Session
├── 📅 Schedule Sessions  
├── 👥 Manage Participants
└── 📹 Session Recordings

💬 Communication
├── 💬 Course Discussions
├── 👥 Student Messages
└── 🔔 Communication Settings
```

### Admin Role Screens
```
📱 Admin Dashboard
├── 📊 System Analytics
├── 👥 User Management
├── 📚 Course Oversight
├── 🔧 System Settings
└── 📈 Platform Statistics

👥 User Management  
├── 📋 All Users
├── ➕ Create User
├── ✏️ Edit User Profiles
├── 🔒 User Permissions
└── 📊 User Analytics

📚 Course Management
├── 📋 All Courses
├── ✅ Course Approval
├── 📊 Course Analytics
└── 🏷️ Category Management

🔧 System Settings
├── 🔧 General Settings
├── 🔔 Notification Settings  
├── 📧 Email Configuration
└── 🔐 Security Settings

📊 Analytics & Reports
├── 📈 Platform Usage
├── 👥 User Engagement
├── 📚 Course Performance
└── 📊 System Health
```

## 🔌 API Integration Plan

### Phase 1: Authentication & User Management (Week 1)
```dart
✅ Setup Dio HTTP client
✅ Configure interceptors (auth, error)
✅ Implement AuthService with backend APIs
✅ Update AuthProvider to use real APIs  
✅ Handle JWT token refresh
✅ Implement secure token storage
✅ Update login/register screens
✅ Add email verification flow
```

### Phase 2: Core Features (Week 2-3)
```dart
✅ Course API integration
✅ Enrollment system
✅ User profile management
✅ File upload/download
✅ Basic navigation updates
✅ Course content viewing
✅ Progress tracking
```

### Phase 3: Interactive Features (Week 4-5)  
```dart
✅ Chat system Socket.IO integration
✅ Real-time notifications
✅ Quiz system with backend
✅ Assignment submission
✅ Basic grading
```

### Phase 4: Advanced Features (Week 6-7)
```dart
✅ Livestream WebRTC integration
✅ Advanced analytics
✅ Admin panel
✅ Push notifications
✅ Offline support
```

### Phase 5: Polish & Testing (Week 8)
```dart
✅ Error handling improvements
✅ Loading states
✅ Performance optimization  
✅ Testing & bug fixes
✅ Documentation
```

## 📡 Socket.IO Events Mapping

### Backend Events → Flutter Handlers
```typescript
// Backend emits → Flutter listens
'chat:message-received' → chatProvider.addMessage()
'chat:user-joined' → chatProvider.updateOnlineUsers()
'chat:typing-indicator' → chatProvider.showTyping()
'notification:new' → notificationProvider.addNotification()
'livestream:started' → livestreamProvider.sessionStarted()
'webrtc:offer' → webrtcService.handleOffer()
'webrtc:answer' → webrtcService.handleAnswer()
'webrtc:ice-candidate' → webrtcService.handleIceCandidate()

// Flutter emits → Backend handles
'chat:join' → Join course chat room
'chat:send-message' → Send message to room
'chat:typing' → Notify typing status
'livestream:join' → Join live session
'webrtc:offer' → Send WebRTC offer
'webrtc:answer' → Send WebRTC answer
'webrtc:ice-candidate' → Send ICE candidate
```

## 🏢 Database Model Mapping

### User Model Sync
```dart
// Backend User Model → Flutter User Model
id (UUID) → id (String)
email → email
first_name + last_name → fullName  
role → role (enum: student/instructor/admin)
avatar → avatarUrl
preferences (JSON) → preferences (Map)
status → status
// + additional fields for student/instructor
```

### Course Model Sync
```dart  
// Backend Course → Flutter Course
id (UUID) → id (String)
title → title
description → description  
instructor_id → instructorId
thumbnail → thumbnailUrl
price → price
rating → rating
total_students → enrollmentCount
status → status (draft/published/archived)
// + category, level, metadata
```

## 🔒 Security Implementation

### 1. Authentication Flow
```dart
1. Login → Get JWT access + refresh tokens
2. Store tokens in FlutterSecureStorage
3. Add Authorization header to all requests
4. Auto-refresh expired tokens
5. Handle 401 responses → redirect to login
6. Logout → clear tokens + notify backend
```

### 2. API Security
```dart
✅ HTTPS only in production
✅ JWT token validation
✅ Request/response encryption
✅ Rate limiting on sensitive endpoints
✅ Input validation & sanitization
✅ CORS configuration
```

### 3. Data Protection
```dart
✅ Secure storage for tokens
✅ Encrypted local database (Hive)
✅ No sensitive data in logs
✅ Biometric authentication option
✅ Session timeout handling
```

## 🧪 Testing Strategy

### 1. Unit Tests
```dart
✅ Models serialization/deserialization
✅ Service layer API calls
✅ Provider state management
✅ Utility functions
✅ Validation logic
```

### 2. Widget Tests  
```dart
✅ Authentication screens
✅ Course list/detail widgets
✅ Chat components
✅ Quiz taking flow
✅ Navigation flows
```

### 3. Integration Tests
```dart
✅ Full login/logout flow
✅ Course enrollment process
✅ Chat message sending
✅ Quiz completion
✅ File upload/download
```

### 4. API Testing
```dart
✅ Mock server responses
✅ Error handling scenarios
✅ Network connectivity issues
✅ Token expiration handling
✅ Real-time event testing
```

## 📦 Build & Deployment

### Development Environment
```bash
# Environment variables
API_BASE_URL=http://localhost:3000/api
SOCKET_URL=http://localhost:3003
DEBUG_MODE=true
LOG_LEVEL=debug
```

### Staging Environment  
```bash
API_BASE_URL=https://staging-api.lms.com/api
SOCKET_URL=https://staging-socket.lms.com
DEBUG_MODE=false
LOG_LEVEL=info
```

### Production Environment
```bash
API_BASE_URL=https://api.lms.com/api  
SOCKET_URL=https://socket.lms.com
DEBUG_MODE=false
LOG_LEVEL=error
```

### Build Commands
```bash
# Development
flutter run --dart-define=ENV=dev

# Staging
flutter build apk --dart-define=ENV=staging

# Production  
flutter build apk --release --dart-define=ENV=production
flutter build ios --release --dart-define=ENV=production
```

## 📈 Performance Optimization

### 1. API Optimization
```dart
✅ Request/response caching
✅ Pagination for large lists
✅ Image lazy loading  
✅ Background data sync
✅ Optimistic UI updates
```

### 2. Real-time Optimization
```dart
✅ Socket connection pooling
✅ Event debouncing (typing indicators)
✅ Selective event subscriptions
✅ Connection state management
✅ Reconnection strategies
```

### 3. Storage Optimization
```dart
✅ Efficient Hive queries
✅ Data compression
✅ Cache expiration policies
✅ Background cleanup
✅ Memory management
```

## 🚀 Launch Checklist

### Pre-Launch (Week 8)
- [ ] All core features tested
- [ ] Performance benchmarks met
- [ ] Security audit passed
- [ ] Documentation complete
- [ ] Beta testing feedback incorporated

### Launch Day
- [ ] Production environment ready
- [ ] Database migrations completed
- [ ] SSL certificates valid
- [ ] CDN configured
- [ ] Monitoring systems active

### Post-Launch (Week 9)
- [ ] User feedback collection
- [ ] Performance monitoring
- [ ] Bug fixes and patches
- [ ] Feature usage analytics
- [ ] Support documentation

---

**Timeline:** 8-9 weeks
**Team Size:** 2-3 developers  
**Risk Level:** Medium (Complex real-time features)
**Success Metrics:** 
- All core LMS features functional
- Real-time features working reliably
- User authentication & security solid
- Performance targets met
- Ready for user testing
