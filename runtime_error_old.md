PS C:\Project\lms_mobile_flutter> flutter run
Launching lib\main.dart on sdk gphone64 x86 64 in debug mode...
Running Gradle task 'assembleDebug'...                             20.8s
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...        2,359ms
Error: ADB exited with exit code 1
Performing Streamed Install

adb.exe: failed to install
C:\Project\lms_mobile_flutter\build\app\outputs\flutter-apk\app-debug.apk: Failure      
[INSTALL_FAILED_INSUFFICIENT_STORAGE: Failed to override installation location]
Uninstalling old version...
Installing build\app\outputs\flutter-apk\app-debug.apk...           4.7s
D/FlutterJNI( 8380): Beginning load of flutter...
D/FlutterJNI( 8380): flutter (null) was loaded normally!
I/flutter ( 8380): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
I/_mobile_flutter( 8380): hiddenapi: Accessing hidden method Landroid/view/accessibility/AccessibilityNodeInfo;->getSourceNodeId()J (runtime_flags=0, domain=platform, api=unsupported,test-api) from Lio/flutter/view/AccessibilityViewEmbedder$ReflectionAccessors; (domain=app) using reflection: allowed
I/_mobile_flutter( 8380): hiddenapi: Accessing hidden method Landroid/view/accessibility/AccessibilityRecord;->getSourceNodeId()J (runtime_flags=0, domain=platform, api=unsupported) from Lio/flutter/view/AccessibilityViewEmbedder$ReflectionAccessors; (domain=app) using reflection: allowed
I/_mobile_flutter( 8380): hiddenapi: Accessing hidden field Landroid/view/accessibility/AccessibilityNodeInfo;->mChildNodeIds:Landroid/util/LongArray; (runtime_flags=0, domain=platform, api=unsupported) from Lio/flutter/view/AccessibilityViewEmbedder$ReflectionAccessors; (domain=app) using reflection: allowed
I/_mobile_flutter( 8380): hiddenapi: Accessing hidden method Landroid/util/LongArray;->get(I)J (runtime_flags=0, domain=platform, api=unsupported) from Lio/flutter/view/AccessibilityViewEmbedder$ReflectionAccessors; (domain=app) using reflection: allowed
Syncing files to device sdk gphone64 x86 64...                     169ms

Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on sdk gphone64 x86 64 is available at:
http://127.0.0.1:53359/fOS_6Osmj8k=/
D/CompatChangeReporter( 8380): Compat change id reported: 377864165; UID 10248; state: ENABLED
W/HWUI    ( 8380): Unknown dataspace 0
The Flutter DevTools debugger and profiler on sdk gphone64 x86 64 is available at:
http://127.0.0.1:9102?uri=http://127.0.0.1:53359/fOS_6Osmj8k=/
D/AudioSystem( 8380): onNewService: media.audio_policy service obtained 0x7874edaac9a0
D/AudioSystem( 8380): getService: checking for service media.audio_policy: 0x7874edaac9a0
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Localization initialized
I/Choreographer( 8380): Skipped 44 frames!  The application may be doing too much work on its main thread.
I/WindowExtensionsImpl( 8380): Initializing Window Extensions, vendor API level=9, activity embedding enabled=true
I/_mobile_flutter( 8380): Compiler allocated 5042KB to compile void android.view.ViewRootImpl.performTraversals()
W/FlutterWebRTCPlugin( 8380): audioFocusChangeListener [Speakerphone(name=Speakerphone)] Speakerphone(name=Speakerphone)
I/flutter ( 8380): ✅ Android Device: google sdk_gphone64_x86_64
I/Choreographer( 8380): Skipped 57 frames!  The application may be doing too much work on its main thread.
D/WindowLayoutComponentImpl( 8380): Register WindowLayoutInfoListener on Context=com.example.lms_mobile_flutter.MainActivity@a8b53cf, of which baseContext=android.app.ContextImpl@d5398ea
D/ProfileInstaller( 8380): Installing profile for com.example.lms_mobile_flutter
I/flutter ( 8380): ✅ Firebase initialized successfully
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Start
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Init state
I/flutter ( 8380): [🌎 Easy Localization] [INFO] Start locale loaded vi
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Build
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Init Localization Delegate
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Init provider
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Load Localization Delegate
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Load asset from assets/i18n
I/Choreographer( 8380): Skipped 82 frames!  The application may be doing too much work on its main thread.
I/flutter ( 8380): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/admin/settings
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Build
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Init Localization Delegate
I/flutter ( 8380): [🌎 Easy Localization] [DEBUG] Init provider
I/flutter ( 8380): ❌ API Error: This exception was thrown because the response has a status code of 401 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8380): The status code of 401 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
I/flutter ( 8380): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8380): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8380): 📍 URL: http://10.0.2.2:3000/api/v1/admin/settings
I/flutter ( 8380): 📋 Status: 401
I/flutter ( 8380): 📝 Response: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/Choreographer( 8380): Skipped 58 frames!  The application may be doing too much work on its main thread.
I/HWUI    ( 8380): Davey! duration=1066ms; Flags=1, FrameTimelineVsyncId=116817, IntendedVsync=12974486361348, Vsync=12975453027976, InputEventId=0, HandleInputStart=12975469567700, AnimationStart=12975469595700, PerformTraversalsStart=12975469636800, DrawStart=12975498015900, FrameDeadline=12974503028014, FrameStartTime=12975468751100, FrameInterval=16666666, WorkloadTarget=16666666, SyncQueued=12975505157200, SyncStart=12975506878400, IssueDrawCommandsStart=12975507102600, SwapBuffers=12975539551600, FrameCompleted=12975554297600, DequeueBufferDuration=10493600, QueueBufferDuration=538400, GpuCompleted=12975554297600, SwapBuffersCompleted=12975553214000, DisplayPresentTime=0, CommandSubmissionCompleted=12975539551600,
I/FLTFireBGExecutor( 8380): Creating background FlutterEngine instance, with args: [--enable-dart-profiling]
D/FLTFireContextHolder( 8380): received application context.
I/flutter ( 8380): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
V/Configuration( 8380): Updating configuration, locales updated from [en_US] to [en]
I/FLTFireMsgService( 8380): FlutterFirebaseMessagingBackgroundService started!
W/FlutterWebRTCPlugin( 8380): audioFocusChangeListener [Speakerphone(name=Speakerphone)] Speakerphone(name=Speakerphone)
I/_mobile_flutter( 8380): AssetManager2(0x7874cda57af8) locale list changing from [] to [en]
D/InsetsController( 8380): hide(ime(), fromIme=false)
I/ImeTracker( 8380): com.example.lms_mobile_flutter:40b9c80b: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
V/Configuration( 8380): Updating configuration, locales updated from [en] to [en_US]
I/_mobile_flutter( 8380): AssetManager2(0x7874cda42018) locale list changing from [] to [en-US]
I/flutter ( 8380): 🔒 Token refresh failed - cleared auth data
I/flutter ( 8380): [NotificationService] Permissions granted
D/InsetsController( 8380): hide(ime(), fromIme=false)
I/ImeTracker( 8380): com.example.lms_mobile_flutter:21dd1e29: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter ( 8380): [NotificationService] FCM Token: eKVZt9IySTKbLMEapNlied:APA91bEmCn_KvWRU4A5H9ORWGhmEF-ywZZ6TxYgItxhz6vmQ4qjiFLlkBmjFysxZmxbkngd1mIRYiUBjKIEkcdO3_6trmZ1b8qZYSJ5YGM6FRkR-YGieyNI
I/flutter ( 8380): [NotificationService] Initialized successfully
W/_mobile_flutter( 8380): Suspending all threads took: 8.562ms
I/_mobile_flutter( 8380): Background concurrent mark compact GC freed 1589KB AllocSpace bytes, 62(2264KB) LOS objects, 49% free, 3931KB/7863KB, paused 15.078ms,8.314ms total 211.533ms
I/_mobile_flutter( 8380): AssetManager2(0x7874cda68ad8) locale list changing from [] to [en-US]
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] *** Request ***
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] uri: http://10.0.2.2:3000/api/v1/auth/login
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] method: POST
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] responseType: ResponseType.json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] followRedirects: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] persistentConnection: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] connectTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] sendTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] receiveTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] receiveDataWhenStatusError: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] extra: {}
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] headers:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]  Content-Type: application/json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]  Accept: application/json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] data:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] {email: instructor1@example.com, password: Instructor123!, rememberMe: false}
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] *** Response ***
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] uri: http://10.0.2.2:3000/api/v1/auth/login
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] Response Text:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] {"success":true,"message":"Login successful","data":{"user":{"id":"00000000-0000-0000-0000-000000000003","email":"instructor1@example.com","username":"instructor1","first_name":"John","last_name":"Doe","phone":"+84901000003","bio":"Experienced software engineer with 10+ years in web development. Specializing in React, Node.js, and cloud architecture.","avatar":null,"role":"instructor","status":"active","email_verified":true,"student_id":null,"class":null,"major":null,"year":null,"gpa":null,"instructor_id":"INS001","department":"Computer Science","specialization":"Web Development, Cloud Computing","experience_years":10,"education_level":"master","research_interests":null,"date_of_birth":null,"gender":null,"address":null,"emergency_contact":null,"emergency_phone":null},"tokens":{"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDMiLCJlbWFpbCI6Imluc3RydWN0b3IxQGV4YW1wbGUuY29tIiwicm9sZSI6Imluc3RydWN0b3IiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0Ijo
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
I/flutter ( 8380): [NotificationService] Subscribed to user notifications: 00000000-0000-0000-0000-000000000003
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
I/_mobile_flutter( 8380): AssetManager2(0x7874cda9c0b8) locale list changing from [] to [en-US]
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
I/ImeTracker( 8380): com.example.lms_mobile_flutter:a1b2c22c: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
D/InsetsController( 8380): show(ime(), fromIme=false)
D/InsetsController( 8380): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor( 8380): The input method toggled cursor monitoring on
W/InteractionJankMonitor( 8380): Initializing without READ_DEVICE_CONFIG permission. enabled=false, interval=1, missedFrameThreshold=3, frameTimeThreshold=64, package=com.example.lms_mobile_flutter
I/ImeTracker( 8380): com.example.lms_mobile_flutter:a1b2c22c: onShown
I/ImeTracker( 8380): com.example.lms_mobile_flutter:7f3df62e: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
D/InsetsController( 8380): show(ime(), fromIme=false)
I/ImeTracker( 8380): com.example.lms_mobile_flutter:7f3df62e: onCancelled at PHASE_CLIENT_APPLY_ANIMATION
D/InputConnectionAdaptor( 8380): The input method toggled cursor monitoring on
I/ImeTracker( 8380): com.example.lms_mobile_flutter:d05afe3f: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController( 8380): hide(ime(), fromIme=false)
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=android.view.ImeBackAnimationController@90acd2a
D/InsetsController( 8380): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter( 8380): Compat change id reported: 395521150; UID 10248; state: ENABLED
I/ImeTracker( 8380): system_server:d626763f: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
W/WindowOnBackDispatcher( 8380): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@36d8d2f
I/_mobile_flutter( 8380): Background concurrent mark compact GC freed 2135KB AllocSpace bytes, 46(1752KB) LOS objects, 49% free, 4016KB/8031KB, paused 9.764ms,3.492ms total 53.151ms
D/InsetsController( 8380): hide(ime(), fromIme=false)
I/ImeTracker( 8380): com.example.lms_mobile_flutter:1bf156ab: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   CourseManagementService.createCourse (package:lms_mobile_flutter/features/courses/providers/course_provider.dart:440:17)
I/flutter ( 8380): 🐛 🌐 [API] Creating new course: gggggg
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   CourseService.createCourse (package:lms_mobile_flutter/features/courses/services/course_service.dart:186:17)
I/flutter ( 8380): 🐛 🌐 [API] Creating new course: gggggg
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] *** Request ***
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] uri: http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] method: POST
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] responseType: ResponseType.json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] followRedirects: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] persistentConnection: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] connectTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] sendTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] receiveTimeout: 0:00:30.000000
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] receiveDataWhenStatusError: true
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] extra: {}
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] headers:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]  Content-Type: application/json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]  Accept: application/json
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] data:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] {title: gggggg, description: gggggg, category: null, level: beginner, duration: 40, price: 0.0, thumbnail: null, status: draft, prerequisites: [], learning_objectives: []}
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] *** Response ***
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] uri: http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] Response Text:
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API] {"success":false,"message":"Unauthorized access","error":"Unauthorized access","data":null}
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8380): 🐛 🌐 [API]
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   CourseService.createCourse (package:lms_mobile_flutter/features/courses/services/course_service.dart:193:17)
I/flutter ( 8380): 🐛 🌐 [API] Course created successfully
I/flutter ( 8380): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8380): #1   CourseService.createCourse (package:lms_mobile_flutter/features/courses/services/course_service.dart:194:17)
I/flutter ( 8380): 🐛 🌐 [API] Response data: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/flutter ( 8380): Exception: Invalid response format: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/flutter ( 8380): #0   AppLogger.error (package:lms_mobile_flutter/core/utils/app_logger.dart:41:13)
I/flutter ( 8380): #1   CourseService.createCourse (package:lms_mobile_flutter/features/courses/services/course_service.dart:211:17)
I/flutter ( 8380): #2   <asynchronous suspension>
I/flutter ( 8380): #3   CourseManagementService.createCourse (package:lms_mobile_flutter/features/courses/providers/course_provider.dart:441:22)
I/flutter ( 8380): #4   <asynchronous suspension>
I/flutter ( 8380): #5   _CreateCourseScreenState._submitForm (package:lms_mobile_flutter/screens/teacher/courses/create_course_screen.dart:164:7)
I/flutter ( 8380): #6   <asynchronous suspension>
I/flutter ( 8380): ⛔ Failed to create course
I/flutter ( 8380): Exception: Invalid response format: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/flutter ( 8380): #0   AppLogger.error (package:lms_mobile_flutter/core/utils/app_logger.dart:41:13)
I/flutter ( 8380): #1   CourseManagementService.createCourse (package:lms_mobile_flutter/features/courses/providers/course_provider.dart:445:17)
I/flutter ( 8380): #2   <asynchronous suspension>
I/flutter ( 8380): #3   _CreateCourseScreenState._submitForm (package:lms_mobile_flutter/screens/teacher/courses/create_course_screen.dart:164:7)
I/flutter ( 8380): #4   <asynchronous suspension>
I/flutter ( 8380): ⛔ Failed to create course
I/ImeTracker( 8380): com.example.lms_mobile_flutter:4d6127a9: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
D/InsetsController( 8380): show(ime(), fromIme=false)
D/InsetsController( 8380): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor( 8380): The input method toggled cursor monitoring on
I/ImeTracker( 8380): com.example.lms_mobile_flutter:4d6127a9: onShown
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
I/flutter ( 8712): SecuritySessions DEBUG build: initialSessions is null
I/flutter ( 8712): SecuritySessions DEBUG: len=[].length, loading=false, error=null
I/_mobile_flutter( 8712): AssetManager2(0x7874cda66238) locale list changing from [] to [en-US]
I/flutter ( 8712): SecuritySessions DEBUG build: initialSessions is null
I/flutter ( 8712): SecuritySessions DEBUG: len=[].length, loading=true, error=null
I/flutter ( 8712): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/users/active-sessions
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 401 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 401 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/users/active-sessions
I/flutter ( 8712): 📋 Status: 401
I/flutter ( 8712): 📝 Response: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/flutter ( 8712): 🚀 API Request: POST http://10.0.2.2:3000/api/v1/auth/refresh-token
I/flutter ( 8712): 📤 Request Data: {refreshToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDMiLCJ0b2tlblZlcnNpb24iOjEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYyMTc5MjY2LCJleHAiOjE3NjI3ODQwNjYsImF1ZCI6Imxtcy1mcm9udGVuZCIsImlzcyI6Imxtcy1iYWNrZW5kIn0.2Ylm_DaRZw8Phym3WI6anRJ-zjYGF377fP2doYmzFko}        
I/flutter ( 8712): ✅ API Response: 200 /auth/refresh-token
I/flutter ( 8712): 🔄 Token refreshed successfully
I/flutter ( 8712): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/users/active-sessions
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 403 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 403 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/users/active-sessions
I/flutter ( 8712): 📋 Status: 403
I/flutter ( 8712): 📝 Response: {success: false, message: Access denied, error: Access denied, data: null}
I/flutter ( 8712): 🔒 Token refresh failed - cleared auth data
I/flutter ( 8712): SecuritySessions DEBUG build: initialSessions is null
I/flutter ( 8712): SecuritySessions DEBUG: len=[].length, loading=false, error=Không tải được danh sách phiên: {0}
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
D/InsetsController( 8712): hide(ime(), fromIme=false)
I/ImeTracker( 8712): com.example.lms_mobile_flutter:c423e5b0: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
I/flutter ( 8712): 🚀 API Request: POST http://10.0.2.2:3000/api/v1/users/upload-avatar
I/flutter ( 8712): 📤 Request Data: Instance of 'FormData'
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 401 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 401 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/users/upload-avatar
I/flutter ( 8712): 📋 Status: 401
I/flutter ( 8712): 📝 Response: {success: false, message: Unauthorized access, error: Unauthorized access, data: null}
I/flutter ( 8712): 🔒 Token refresh failed - cleared auth data
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API] Response Text:
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API] {"success":false,"message":"Unauthorized access","error":"Unauthorized access","data":null}
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API]
I/flutter ( 8712): AuthException: RepositoryException: Unexpected status code: 401      
I/flutter ( 8712): #0   AppLogger.warning (package:lms_mobile_flutter/core/utils/app_logger.dart:36:13)
I/flutter ( 8712): #1   AuthNotifier.logout (package:lms_mobile_flutter/features/auth/auth_state.dart:203:17)
I/flutter ( 8712): #2   <asynchronous suspension>
I/flutter ( 8712): #3   _ProfileScreenState._showLogoutDialog.<anonymous closure>.<anonymous closure> (package:lms_mobile_flutter/screens/shared/profile/profile_screen.dart:405:17)
I/flutter ( 8712): #4   <asynchronous suspension>
I/flutter ( 8712): ! Server logout error
I/flutter ( 8712): [NotificationService] Subscribed to user notifications: 00000000-0000-0000-0000-000000000003
I/flutter ( 8712): [NotificationService] Subscribed to user notifications: 00000000-0000-0000-0000-000000000003
I/flutter ( 8712): [NotificationService] Subscribed to user notifications: 00000000-0000-0000-0000-000000000003
I/_mobile_flutter( 8712): AssetManager2(0x7874cda87578) locale list changing from [] to [en-US]
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API] Response Text:
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API] {"success":false,"message":"Route /api/v1/v1/admin/users?page=1&limit=10&role=admin not found","error":"Route /api/v1/v1/admin/users?page=1&limit=10&role=admin not found"}
I/flutter ( 8712): #0   AppLogger.api (package:lms_mobile_flutter/core/utils/app_logger.dart:51:13)
I/flutter ( 8712): #1   ApiClient._setupInterceptors.<anonymous closure> (package:lms_mobile_flutter/core/network/api_client.dart:61:23)
I/flutter ( 8712): 🐛 🌐 [API]
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
W/WindowOnBackDispatcher( 8712): sendCancelIfRunning: isInProgress=false callback=io.flutter.embedding.android.FlutterActivity$1@bf7b914
I/flutter ( 8712): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): 🚀 API Request: GET http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 500 has the following meaning: "Server error - the server failed to fulfil an apparently valid request"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): 📋 Status: 500
I/flutter ( 8712): 📝 Response: {success: false, message: Database query failed, error: Database query failed}
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 500 has the following meaning: "Server error - the server failed to fulfil an apparently valid request"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): 📋 Status: 500
I/flutter ( 8712): 📝 Response: {success: false, message: Database query failed, error: Database query failed}
I/flutter ( 8712): ❌ API Error: This exception was thrown because the response has a status code of 500 and RequestOptions.validateStatus was configured to throw for this status code.
I/flutter ( 8712): The status code of 500 has the following meaning: "Server error - the server failed to fulfil an apparently valid request"
I/flutter ( 8712): Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
I/flutter ( 8712): In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.
I/flutter ( 8712): 📍 URL: http://10.0.2.2:3000/api/v1/courses
I/flutter ( 8712): 📋 Status: 500
I/flutter ( 8712): 📝 Response: {success: false, message: Database query failed, error: Database query failed}