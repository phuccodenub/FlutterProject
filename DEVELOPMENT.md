# Development Guide - LMS Mobile Flutter

## 🎯 Current Status (November 2025)

### ✅ Completed Features
- **Authentication System** - JWT with refresh tokens, demo accounts
- **Real-time Chat** - Socket.IO with typing indicators, file attachments  
- **WebRTC Livestream** - 1-to-N video streaming with participant grid
- **Quiz System** - 4 question types, auto-grading, local storage
- **Notification System** - Local notifications with deep linking
- **Course Management** - Full CRUD operations for all roles
- **File Management** - Upload/download with preview capabilities
- **Multi-role UI** - Student, Instructor, Admin dashboards
- **State Management** - Riverpod with proper error handling
- **Network Layer** - Dio client with retry and caching

### 🔄 In Progress  
- Enhanced file management UI
- Calendar integration
- Advanced analytics dashboard

### 📋 TODO List Status
- **Total TODO Comments**: 0 (All resolved in Phase 4)
- **Critical Issues**: 1 flaky test (security sessions)
- **Test Coverage**: 65% (Target: 80%)

## 🏗️ Architecture Details

### State Management Pattern
```dart
// Provider pattern with Riverpod
final courseProvider = FutureProvider.family<Course, String>((ref, id) async {
  final repository = ref.read(courseRepositoryProvider);
  return await repository.getCourse(id);
});

// Consumer widget usage
class CourseScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseProvider(courseId));
    return courseAsync.when(
      data: (course) => CourseContent(course: course),
      loading: () => ShimmerLoading(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

### Network Layer
```dart
// API client with interceptors
class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  ));

  ApiClient() {
    _dio.interceptors.addAll([
      AuthInterceptor(),     // JWT token management
      LoggingInterceptor(),  // Request/response logging
      RetryInterceptor(),    // Auto-retry failed requests
      ErrorInterceptor(),    // Standardized error handling
    ]);
  }
}
```

### Real-time Communication
```dart
// Socket.IO integration
class SocketService {
  IO.Socket? _socket;
  
  void connect() {
    _socket = IO.io('http://localhost:3003', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    
    _socket!.on('chat:message-received', _handleMessage);
    _socket!.on('livestream:participant-joined', _handleParticipant);
  }
  
  void sendMessage(String courseId, String message) {
    _socket!.emit('chat:send-message', {
      'courseId': courseId,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
```

## 🧪 Testing Strategy

### Test Structure
```
test/
├── unit/              # Business logic tests
│   ├── providers/     # State management tests
│   ├── services/      # API service tests
│   └── models/        # Data model tests
├── widget/            # UI component tests
│   ├── screens/       # Screen widget tests
│   └── widgets/       # Custom widget tests
└── integration/       # End-to-end tests
    └── auth_flow_test.dart
```

### Running Tests
```bash
# Unit tests only
flutter test test/unit/

# Widget tests
flutter test test/widget/

# All tests with coverage
flutter test --coverage

# Specific test file
flutter test test/unit/providers/auth_provider_test.dart

# Watch mode for development
flutter test --watch
```

### Test Examples
```dart
// Provider testing
void main() {
  group('AuthProvider', () {
    late ProviderContainer container;
    
    setUp(() {
      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(MockAuthService()),
        ],
      );
    });
    
    test('should login successfully with valid credentials', () async {
      final auth = container.read(authProvider.notifier);
      await auth.login('student@demo.com', 'student123');
      
      final state = container.read(authProvider);
      expect(state.isAuthenticated, true);
      expect(state.user?.email, 'student@demo.com');
    });
  });
}

// Widget testing
void main() {
  group('LoginScreen', () {
    testWidgets('should show error message on invalid login', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(MockAuthService()),
          ],
          child: MaterialApp(home: LoginScreen()),
        ),
      );
      
      await tester.enterText(find.byKey(Key('email')), 'invalid@email.com');
      await tester.enterText(find.byKey(Key('password')), 'wrong');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();
      
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

## 🔧 Development Workflow

### Setting Up Development Environment
```bash
# 1. Clone repository
git clone <repository-url>
cd lms_mobile_flutter

# 2. Install dependencies
flutter pub get

# 3. Set up backend (Docker)
cd ../backend
docker compose -f docker/docker-compose.dev.yml up -d

# 4. Run app in development mode
cd ../lms_mobile_flutter
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000 --dart-define=DEBUG_MODE=true

# 5. Enable hot reload
# Press 'r' for hot reload, 'R' for hot restart
```

### Code Quality Tools
```bash
# Static analysis
flutter analyze

# Code formatting
dart format lib/ test/

# Import organization
dart fix --apply

# Check dependencies
flutter pub deps
```

### Git Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/new-feature
```

## 📱 Platform-Specific Setup

### Android Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 33
    minSdkVersion 21
    targetSdkVersion 33
    
    defaultConfig {
        applicationId "com.example.lms_mobile_flutter"
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }
}
```

### iOS Configuration  
```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for livestreaming</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for livestreaming</string>
```

## 🚀 Deployment

### Environment Configuration
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
  
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL', 
    defaultValue: 'http://localhost:3003',
  );
  
  static const bool debugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);
}
```

### Build Commands
```bash
# Development build
flutter build apk --debug --dart-define=API_BASE_URL=http://dev-api.example.com

# Production build
flutter build apk --release --dart-define=API_BASE_URL=https://api.example.com --dart-define=DEBUG_MODE=false

# iOS production
flutter build ios --release --dart-define=API_BASE_URL=https://api.example.com
```

### CI/CD Pipeline
```yaml
# .github/workflows/flutter.yml
name: Flutter CI/CD
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
```

## 🐛 Debugging

### Common Issues & Solutions

#### 1. Socket.IO Connection Issues
```dart
// Check connection status
if (_socket?.connected != true) {
  print('Socket not connected, attempting reconnection...');
  _socket?.connect();
}

// Add connection listeners
_socket?.on('connect', () => print('Socket connected'));
_socket?.on('disconnect', () => print('Socket disconnected'));
_socket?.on('connect_error', (error) => print('Connection error: $error'));
```

#### 2. WebRTC Media Issues
```dart
// Check camera/microphone permissions
final cameraPermission = await Permission.camera.request();
final microphonePermission = await Permission.microphone.request();

if (cameraPermission.isDenied || microphonePermission.isDenied) {
  throw Exception('Camera/microphone permissions required');
}

// Initialize media stream with error handling
try {
  final stream = await navigator.mediaDevices.getUserMedia({
    'video': true,
    'audio': true,
  });
} catch (e) {
  print('Failed to get user media: $e');
}
```

#### 3. State Management Issues
```dart
// Use ref.listen for side effects
ref.listen<AsyncValue<User?>>(authProvider, (previous, next) {
  next.whenOrNull(
    data: (user) {
      if (user == null) {
        context.go('/login');
      }
    },
    error: (error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Auth error: $error')),
      );
    },
  );
});
```

### Logging Configuration
```dart
// lib/core/services/logger_service.dart
class LoggerService {
  static final Logger _logger = Logger();
  
  static void debug(String message) {
    if (AppConfig.debugMode) {
      _logger.d(message);
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
    // Send to crash reporting service in production
  }
}
```

## 📊 Performance Optimization

### Image Optimization
```dart
// Use CachedNetworkImage for better performance
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => ShimmerLoading(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheHeight: 300, // Limit memory usage
  memCacheWidth: 300,
)
```

### List Performance
```dart
// Use ListView.builder for large lists
ListView.builder(
  itemCount: courses.length,
  itemBuilder: (context, index) {
    return CourseCard(course: courses[index]);
  },
)

// Implement pagination for better performance
final coursesProvider = FutureProvider.family<List<Course>, int>((ref, page) async {
  final repository = ref.read(courseRepositoryProvider);
  return await repository.getCourses(page: page, limit: 20);
});
```

### Memory Management
```dart
// Proper disposal of resources
class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
```

## 🔐 Security Best Practices

### Token Management
```dart
// Secure token storage
class TokenManager {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: 'access_token', value: accessToken),
      _storage.write(key: 'refresh_token', value: refreshToken),
    ]);
  }
  
  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
```

### Input Validation
```dart
// Form validation
class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Email is required';
              if (!EmailValidator.validate(value!)) return 'Invalid email';
              return null;
            },
          ),
        ],
      ),
    );
  }
}
```

## 📚 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev/)
- [Socket.IO Client](https://pub.dev/packages/socket_io_client)
- [WebRTC Flutter](https://pub.dev/packages/flutter_webrtc)

### Tools
- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

---

**Last Updated:** November 2025  
**Status:** Active Development  
**Next Release:** v1.1.0 with enhanced analytics