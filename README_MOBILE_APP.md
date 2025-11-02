## Prompt phát triển ứng dụng di động Flutter cho LMS (mobile‑hóa toàn bộ frontend)

### Mục tiêu
- Xây dựng ứng dụng di động Flutter (Android/iOS) cho hệ thống LMS, mobile‑hóa đầy đủ chức năng từ frontend hiện tại (React + Vite), đảm bảo tương đương chức năng, trải nghiệm mượt, hỗ trợ đa ngôn ngữ (vi/en), dark mode, realtime (chat, quiz, livestream), thông báo, quản lý tệp, khuyến nghị/analytics và chatbot trợ lý học tập.
- Hỗ trợ chế độ Demo (offline/mô phỏng) và chế độ Kết nối Backend (qua REST + Socket.IO) với cấu hình linh hoạt.

### Phạm vi và tương đương tính năng (feature parity)
- Trang/màn hình công khai: Home, Login, Register.
- Khu vực sau đăng nhập (có Layout + điều hướng): Dashboard, MyCourses, CourseDetail (tab: Overview/Content/Files/Quizzes/Chat), LiveStreamPage, Notifications (tập hợp NotificationPanel + Toast), NotFound (fallback).
- Thành phần realtime và tương tác:
  - Chat (theo course): danh sách tin nhắn, gửi/nhận realtime, online users, trạng thái kết nối.
  - Quiz realtime: instructor start/next/end; student join/submit; hiển thị countdown/timeSpent; kết quả tổng hợp.
  - Livestream/WebRTC: instructor start/end; student join; toggle video/audio; quản lý participants.
- Quản lý tệp (Files): tải lên (giảng viên), danh sách/lọc/tìm kiếm, tải xuống, xóa (quyền), preview cơ bản các định dạng.
- Thông báo: toast + panel; hỗ trợ phân loại (chat, quiz, assignment, stream, info/success/warning/error), đếm chưa đọc, đánh dấu đã đọc, xóa.
- AI & Học tập: RecommendationPanel, LearningAnalytics, ChatbotAssistant (RAG mock) với lịch sử hội thoại theo user/course.
- i18n (vi/en), Theme (light/dark/system), điều hướng, bảo vệ route (ProtectedRoute tương đương guard).

### Kiến trúc Flutter đề xuất
- Mẫu Clean Architecture theo domain (feature‑first), quản lý trạng thái bằng Riverpod (hoặc Bloc nếu đội ngũ quen thuộc). Dùng `go_router` cho điều hướng.
- Cấu trúc thư mục (tham khảo):
```
lib/
  main.dart
  app.dart
  routes/
    app_router.dart
    guards/
      auth_guard.dart
  core/
    config/app_config.dart            # demoMode, apiBaseUrl, socketUrl, webrtc, ...
    env/env.dart                      # loader .env => kFlutterAPI_URL, v.v.
    i18n/                             # easy_localization với en.json, vi.json tái sử dụng
    theme/                            # AppTheme + dark/light
    network/dio_client.dart           # tương đương apiClient.ts (interceptors, error mapping)
    realtime/socket_client.dart       # tương đương socketService.ts
    webrtc/webrtc_client.dart         # tương đương webRTCService.ts (flutter_webrtc)
    notifications/                    # local notifications + in‑app toasts
    storage/                          # SharedPreferences/Hive/Isar
    utils/                            # helper chung (format, date, result, ...)
  common/
    widgets/                          # Button, Card, Input, Toast, Skeleton...
    services/notification_center.dart # tập trung event/stream thông báo
  features/
    auth/ (data|domain|presentation)
    home/
    dashboard/
    courses/ (list + my_courses)
    course_detail/ (tabs: overview|content|files|quizzes|chat)
    chat/
    quiz/
    livestream/
    files/
    notifications/
    recommendations/
    analytics/
    settings/ (language/theme)
```

### Mapping chức năng từ frontend sang Flutter
- Điều hướng & Layout:
  - `Layout.tsx` -> `Scaffold` với `AppBar` + `BottomNavigation`/`NavigationRail` (tùy thiết kế), `Drawer` cho menu mobile; banner Demo hiển thị dạng `Positioned`/`Banner`.
  - Router: `go_router` định nghĩa các route: `/`, `/login`, `/register`, `/dashboard`, `/my-courses`, `/courses/:courseId`, `/course/:id`, `/course/:id/live`, `/notifications-demo` (gộp vào màn Notifications), `*` -> NotFound.
  - Guard: `AuthGuard` kiểm tra token/user trong storage (SharedPreferences/Hive) tương đương `ProtectedRoute`.

- i18n:
  - Dùng `easy_localization` hoặc `flutter_i18n`. Import `frontend/src/locales/en.json` và `vi.json` giữ nguyên key.
  - `LanguageSwitcher` -> nút chuyển EN/VI, lưu lựa chọn vào storage.

- Theme:
  - `ThemeContext` -> tạo `ThemeModeNotifier` (light/dark/system), lưu vào storage, binding Material 3.

- Auth:
  - `authStore` (Zustand) -> `StateNotifier`/`Riverpod` providers: `AuthState { user, token, isAuthenticated, isInitialized, isLoading }`.
  - `mockAuthService` -> lớp `MockAuthService` (Dart) giữ parity API: `login`, `register`, `logout`, `getProfile`, `updateProfile`, `verifyToken`, `DEMO_ACCOUNTS`.
  - Chế độ Demo: bật bằng `AppConfig.demoMode == true`, dùng mock thay vì REST.

- API client & Error handling:
  - `apiClient.ts` -> `Dio` + `Interceptors`:
    - Thêm `Authorization: Bearer <token>` từ storage.
    - Mapping status 401/403/404/422/429/500 sang UI `SnackBar/Toast` và điều hướng `/login` khi 401 (trừ case thiếu token).
    - Timeout, retry (tuỳ chọn) và error normalization.

- Realtime Socket.IO:
  - `socketService.ts` -> `socket_io_client` (Dart). Sự kiện cần hỗ trợ:
    - Chat: `send-message`, `message-received`, `new-message`, `join-course`, `leave-course`, `online-users`, `user-joined`, `user-left`.
    - Quiz: `start-quiz`, `quiz-started`, `quiz-next-question`, `quiz-response`, `end-quiz`, `quiz-ended`.
    - Livestream/WebRTC signaling: `start-livestream` / `livestream-started`, `join-livestream`, `end-livestream` / `livestream-ended`, `webrtc-offer`, `webrtc-answer`, `ice-candidate`, `participant-joined-stream`, `participant-left-stream`.
  - Cho phép mô phỏng sự kiện khi `demoMode` bật (emit local + callback registry tương tự FE).

- WebRTC Livestream:
  - `webRTCService.ts` -> `flutter_webrtc` (PeerConnection, MediaStream, Permissions).
  - Tương đương API: `initialize(socket, courseId, role)`, `startLiveStream()`, `joinLiveStream()`, `endLiveStream()`, `toggleVideo()`, `toggleAudio()`, `on(event)`, `off(event)`.
  - iOS: cập nhật `Info.plist` quyền `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`. Android: cập nhật `AndroidManifest` và `minSdk` theo yêu cầu plugin.

- Chat (theo course):
  - UI: danh sách tin, auto‑scroll, trạng thái kết nối, input gửi; `OnlineUsers` hiển thị dạng bottom sheet hoặc tab phụ.
  - State: `ChatState { messagesByCourse, onlineUsersByCourse, isConnected, isConnecting, activeCourse }` + action tương đương store FE.
  - Demo: preload messages và simulate reply.

- Quiz realtime:
  - Vai trò instructor: Start/Next/End; học viên: Join/Submit; đồng bộ `timeRemaining`, điểm, kết quả.
  - Lưu kết quả tạm thời trong state; thống kê lớp (class average) như FE.

- Files:
  - Dùng `file_picker`, `permission_handler`, `path_provider`, `open_filex`. Lưu metadata bằng Hive/Isar; mock dữ liệu (`initializeDemoData`) như FE `fileService.ts`.
  - Upload (demo): giả lập progress, lưu vào DB local, tạo blob/path.
  - Danh mục, tìm kiếm, tải xuống, xóa (quyền instructor + người upload).

- Notifications:
  - In‑app toast: `another_flushbar` hoặc `overlay_support`.
  - Local notifications: `flutter_local_notifications` (tuỳ chọn). Notification Center màn riêng, đếm chưa đọc, đọc/xóa hàng loạt.
  - `notificationService` parity: lưu Map, preferences theo user, quiet hours, categories (chat/quiz/assignment/stream/announcement).

- Recommendation & Analytics:
  - `recommendationService` parity: mô phỏng collaborative/content/trending; record activity (view/quiz/chat/file_download/livestream) -> cập nhật analytics.
  - `LearningAnalytics` render các KPIs, biểu đồ tiến trình (dạng thẻ/progress bar).

- Chatbot Assistant (AI mock):
  - Giao diện floating button -> panel hội thoại (có gợi ý), lưu lịch sử theo user/course; xử lý intents cơ bản (greeting/course info/technical/support/fallback) như FE.

### Mô hình dữ liệu & mapping (tham khảo)
- `User`, `Course`, `Quiz`, `QuizQuestion`, `QuizAttempt`, `ChatMessage`, `OnlineUser`, `CourseFile`, `Assignment`, `Notification`, `Recommendation`, `LearningActivity`… đối chiếu trực tiếp từ các interface TS, giữ trường tối thiểu để parity.

### Trạng thái & lưu trữ
- State: Riverpod Notifier/StateNotifier; chia theo feature.
- Storage:
  - Auth/token + prefer: SharedPreferences.
  - Dữ liệu demo/offline: Hive/Isar (files, assignments, notifications, preferences…).

### Cấu hình & môi trường
- `.env` (Flutter):
  - `API_BASE_URL`, `SOCKET_URL`, `DEMO_MODE=true|false`, `TIMEOUT_MS`, …
- Cho phép override qua `--dart-define` khi build.

### Điều hướng & UX
- Điều hướng chính: BottomNavigation (Dashboard, Courses, Notifications, Settings) hoặc tab phù hợp; từ Dashboard đi sâu vào CourseDetail (tabs), LiveStream, Quiz.
- Loading skeletons, empty/error states theo FE.
- Hỗ trợ pull‑to‑refresh, infinite scroll (nếu cần) cho danh sách.

### Gói khuyến nghị (Flutter)
- State & DI: `flutter_riverpod`, `get_it` (tuỳ chọn).
- Routing: `go_router`.
- HTTP: `dio` (+ `pretty_dio_logger`).
- Socket.IO: `socket_io_client`.
- WebRTC: `flutter_webrtc`.
- Storage: `shared_preferences`, `hive` (+ `hive_flutter`) hoặc `isar`.
- File: `file_picker`, `path_provider`, `permission_handler`, `open_filex`.
- Notifications: `flutter_local_notifications`, `overlay_support`/`another_flushbar`.
- i18n: `easy_localization`.
- UI: `flutter_svg`, `intl`, `cached_network_image`.

### Tiêu chí chấp nhận (Acceptance Criteria)
- Parity chức năng với frontend web ở các flow chính:
  - Đăng nhập/đăng ký/đăng xuất, lưu token, tự động khởi tạo phiên (initializeAuth).
  - Dashboard hiển thị khóa học, analytics, recommendation, demo banner.
  - CourseDetail có đầy đủ tabs, Quick Actions, join livestream/quiz, file manager.
  - Chat realtime theo course, hiển thị online users, trạng thái kết nối.
  - Livestream WebRTC cơ bản (1‑N), instructor start/end, student join, toggle A/V.
  - Quiz realtime start/next/end, student submit, kết quả lớp.
  - Files: upload (giảng viên), lọc/tìm kiếm, download, xóa (đúng quyền), preview cơ bản.
  - Notifications: toast + panel, đếm badge, đọc/xóa; có thể mô phỏng.
  - i18n vi/en, Theme dark/light/system.
- Chế độ Demo hoạt động hoàn toàn offline/mô phỏng (không cần backend), bao gồm chat/quiz/notifications/files/livestream (giới hạn ở client‑side/mock signaling).
- Hiệu năng mượt trên thiết bị tầm trung; xử lý lỗi mạng, retry; UI responsive.

### Kế hoạch triển khai (gợi ý theo giai đoạn)
1) Khởi tạo dự án Flutter + cấu hình gói, thiết lập i18n, Theme, Routing, AppConfig (demoMode).
2) Auth + API/Demo mock + Guards.
3) Dashboard + Recommendations + Analytics.
4) Courses + CourseDetail (Overview/Content).
5) Files (upload/download/preview, demo data).
6) Chat realtime (socket + demo simulate) + Online Users.
7) Quiz realtime (instructor/student) + kết quả.
8) Livestream (flutter_webrtc + signaling socket, permissions).
9) Notifications (toast + panel + preferences + unread count) + Demo screen.
10) Chatbot Assistant (floating, history, intents mock).
11) Polish: error states, skeletons, accessibility, performance.

### Lưu ý nền tảng
- iOS: quyền camera/micro, thông báo đẩy (nếu bật), cấu hình WebRTC; cập nhật Info.plist.
- Android: quyền file/camera/micro; foreground service (nếu cần cho livestream); điều chỉnh minSdk/compileSdk phù hợp plugin.

### Tài liệu & kiểm thử thủ công
- Cung cấp hướng dẫn build/run, cấu hình .env demo/production, ma trận kiểm thử thủ công các luồng chính.
- Không tạo test file tự động (theo yêu cầu), nhưng đảm bảo checklist QA.

### Gợi ý chuyển đổi nội dung FE sang Flutter
- Tận dụng nguyên xi nội dung i18n `en.json`, `vi.json`.
- Giữ nguyên tên sự kiện Socket.IO và payload để thuận tiện kết nối backend sau này.
- Mô phỏng dữ liệu tương tự `mockData.ts`, `mockAuthService.ts`, `fileService.ts`, `quizService.ts`, `notificationService.ts` với lớp Dart tương ứng.

### Định nghĩa hoàn thành
- Tất cả màn hình/flow chính hoạt động được ở cả Demo Mode (offline) và Connected Mode (nếu cung cấp API/SOCKET hợp lệ), đạt tiêu chí parity và UX mượt trên thiết bị thật.

src
│   App.tsx
│   i18n.ts
│   index.css
│   main.tsx
│   
├───components
│   │   ProtectedRoute.tsx
│   │   
│   ├───Chat
│   │       ChatInterface.tsx
│   │       ChatMessage.tsx
│   │       MessageInput.tsx
│   │       OnlineUsers.tsx
│   │       
│   ├───demo
│   │       NotificationDemo.tsx
│   │       
│   ├───Files
│   │       FileManager.tsx
│   │       
│   ├───Layout
│   │       Layout.tsx
│   │       
│   ├───LiveStream
│   │       LiveStreamInterface.tsx
│   │       
│   ├───Quiz
│   │       QuizInterface.tsx
│   │       
│   └───ui
│           Button.tsx
│           Card.tsx
│           ChatbotAssistant.tsx
│           EmojiPicker.tsx
│           Input.tsx
│           LanguageSwitcher.tsx
│           LearningAnalytics.tsx
│           LoadingSkeleton.tsx
│           NotificationPanel.tsx
│           RecommendationPanel.tsx
│           ToastNotifications.tsx
│           
├───context
├───contexts
│       ThemeContext.tsx
│       
├───hooks
├───lib
│       utils.ts
│       
├───locales
│       en.json
│       vi.json
│       
├───pages
│       CourseDetail.tsx
│       CoursePage.tsx
│       DashboardPage.tsx
│       HomePage.tsx
│       LiveStreamPage.tsx
│       LoginPage.tsx
│       MyCourses.tsx
│       NotFoundPage.tsx
│       RegisterPage.tsx
│       
├───services
│       apiClient.ts
│       authService.ts
│       chatbotService.ts
│       fileService.ts
│       mockAuthService.ts
│       mockData.ts
│       notificationService.ts
│       quizService.ts
│       recommendationService.ts
│       socketService.ts
│       webRTCService.ts
│       
├───stores
│       authStore.ts
│       chatStore.ts
│       
└───utils