# LMS Mobile Flutter 📱

A feature-rich Learning Management System mobile application built with Flutter, supporting real-time chat, video livestreaming, interactive quizzes, and push notifications.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🎯 Core Features
- ✅ **User Authentication** - Login/Register with demo accounts
- ✅ **Course Management** - Browse, enroll, and manage courses
- ✅ **Real-time Chat** - WebSocket-based messaging with typing indicators
- ✅ **Video Livestream** - WebRTC 1-to-N video streaming
- ✅ **Interactive Quizzes** - Multiple question types with auto-grading
- ✅ **Push Notifications** - Local and scheduled notifications
- ✅ **File Management** - Upload, download, and preview files
- ✅ **AI Chatbot** - Context-aware learning assistant
- ✅ **Analytics** - Learning progress tracking
- ✅ **Multi-language** - Vietnamese and English support

### 🚀 Advanced Features
- **Typing Indicators** - Real-time typing status with debouncing
- **Last Seen Status** - User online/offline tracking
- **File Attachments** - Share files in chat with size preview
- **Participants Grid** - Auto-adjusting layout for video calls
- **Auto-grading** - Instant feedback for objective questions
- **Statistics** - Class-level performance analytics
- **Offline Storage** - Hive-based local database
- **Network Monitoring** - Real-time connectivity status
- **Shimmer Loading** - Beautiful skeleton loaders
- **Error Handling** - User-friendly error states

## 📸 Screenshots

*(Add screenshots here after testing)*

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Android Studio / Xcode
- Device or Emulator

### Installation

```bash
# Clone repository
git clone <repository-url>
cd lms_mobile_flutter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 👤 Demo Accounts

| Role       | Email                    | Password      | Purpose              |
|------------|--------------------------|---------------|----------------------|
| Student    | student@demo.com         | student123    | Test student features|
| Instructor | instructor@demo.com      | instructor123 | Test teaching tools  |
| Admin      | admin@demo.com           | admin123      | Test admin panel     |

## 📚 Documentation

- **[Demo Guide](DEMO_GUIDE.md)** - Complete feature walkthrough and testing guide
- **[Build Instructions](BUILD_INSTRUCTIONS.md)** - Detailed build and deployment guide
- **[Implementation Summary](IMPLEMENTATION_SUMMARY.md)** - Technical implementation details
- **[Mobile App README](README_MOBILE_APP.md)** - Original project documentation

## 🏗️ Architecture

```
lib/
├── core/               # Core functionality
│   ├── config/        # App configuration
│   ├── data/          # Demo data & mock accounts
│   ├── network/       # API client & connectivity
│   ├── realtime/      # Socket.IO client & events
│   ├── storage/       # Local storage (Hive/SharedPreferences)
│   ├── theme/         # App theming
│   ├── webrtc/        # WebRTC client
│   └── widgets/       # Reusable UI components
├── features/          # Feature modules
│   ├── analytics/     # Learning analytics
│   ├── auth/          # Authentication
│   ├── chat/          # Real-time chat
│   ├── chatbot/       # AI chatbot
│   ├── courses/       # Course management
│   ├── files/         # File handling
│   ├── livestream/    # Video streaming
│   ├── notifications/ # Push notifications
│   ├── quiz/          # Quiz system
│   └── recommendations/# Course recommendations
├── routes/            # Navigation & routing
├── screens/           # UI screens
├── app.dart           # App widget
└── main.dart          # Entry point
```

## 🛠️ Tech Stack

### Frontend
- **Flutter** 3.9.2 - UI framework
- **Dart** 3.9.2 - Programming language
- **Riverpod** - State management
- **GoRouter** - Navigation

### Real-time & Communication
- **Socket.IO** - WebSocket communication
- **WebRTC** - Video/audio streaming
- **flutter_local_notifications** - Push notifications

### Storage
- **Hive** - NoSQL database
- **SharedPreferences** - Key-value storage
- **flutter_secure_storage** - Encrypted storage

### Media & Files
- **file_picker** - File selection
- **cached_network_image** - Image caching
- **video_player** - Video playback
- **pdfx** - PDF viewing

### Networking
- **Dio** - HTTP client
- **connectivity_plus** - Network monitoring

### UI/UX
- **shimmer** - Loading animations
- **easy_localization** - Internationalization
- **overlay_support** - Toast messages

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1
  dio: ^5.7.0
  socket_io_client: ^2.0.3+1
  flutter_webrtc: ^0.12.12+hotfix.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  file_picker: ^8.3.7
  flutter_local_notifications: ^17.2.3
  shimmer: ^3.0.0
  connectivity_plus: ^6.0.5
  flutter_secure_storage: ^9.2.2
```

## 🎨 Features Breakdown

### 1. Chat System
- Real-time messaging via Socket.IO
- Typing indicators with 800ms debounce
- Last seen status ("5m ago", "2h ago")
- File attachments with preview
- Online user count
- Animated typing dots

### 2. Livestream
- WebRTC-based video streaming
- 1-to-N participant support
- Participants grid layout
- Video/Audio toggle
- Permission error handling
- Connection monitoring

### 3. Quiz System
- 4 question types: Multiple Choice, True/False, Short Answer, Essay
- Auto-grading for objective questions
- Points system
- Timer per question
- Attempt storage (Hive)
- Statistics dashboard

### 4. Notifications
- Android 13+ permission handling
- iOS notification configuration
- Priority levels (low/normal/high)
- Scheduled notifications
- Deep link support

## 🔌 Backend Integration

All Socket.IO events are defined in `lib/core/realtime/socket_events.dart`:

```dart
// Chat events
ChatEvents.join, ChatEvents.sendMessage, ChatEvents.messageReceived

// Livestream events
LivestreamEvents.join, LivestreamEvents.webrtcOffer, LivestreamEvents.iceCandidate

// Quiz events
QuizEvents.join, QuizEvents.submitAnswer, QuizEvents.ended

// Notification events
NotificationEvents.newNotification
```

See [Implementation Summary](IMPLEMENTATION_SUMMARY.md) for full backend integration guide.

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests (when implemented)
flutter test integration_test/
```

### Manual Testing
See [Demo Guide](DEMO_GUIDE.md) for comprehensive testing scenarios.

## 📱 Building

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

### iOS
```bash
# Debug
flutter build ios --debug --no-codesign

# Release
flutter build ios --release
```

See [Build Instructions](BUILD_INSTRUCTIONS.md) for detailed steps.

## 🌐 Environment Configuration

```bash
# Development
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api

# Production
flutter run --dart-define=API_BASE_URL=https://api.example.com --dart-define=DEMO_MODE=false
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👥 Team

- **Development Team** - Initial work and ongoing maintenance

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact: [your-email@example.com]

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All contributors and testers
- Open-source community

---

**Version:** 0.1.0-beta  
**Last Updated:** October 2025  
**Status:** ✅ Ready for Testing

Made with ❤️ using Flutter
