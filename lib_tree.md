lib
│   app.dart
│   main.dart
│   
├───core
│   ├───animations
│   │       app_animations.dart
│   │
│   ├───config
│   │       app_config.dart
│   │
│   ├───data
│   │       demo_data.dart
│   │
│   ├───error
│   │       global_error_handler.dart
│   │
│   ├───network
│   │       connectivity_service.dart
│   │       dio_client.dart
│   │
│   ├───realtime
│   │       socket_client.dart
│   │       socket_events.dart
│   │
│   ├───storage
│   │       prefs.dart
│   │
│   ├───theme
│   │       app_colors.dart
│   │       app_dimensions.dart
│   │       app_theme.dart
│   │       app_typography.dart
│   │
│   ├───utils
│   │       layout_utils.dart
│   │       responsive_utils.dart
│   │
│   ├───webrtc
│   │       webrtc_client.dart
│   │
│   └───widgets
│           calendar.dart
│           charts.dart
│           course_card.dart
│           custom_button.dart
│           custom_cards.dart
│           custom_text_field.dart
│           empty_state.dart
│           info_card.dart
│           loading_indicators.dart
│           loading_widgets.dart
│           progress_card.dart
│           quick_action_card.dart
│           rich_text_editor.dart
│           safe_wrapper.dart
│           section_header.dart
│           stat_card.dart
│           theme_switcher.dart
│           widgets.dart
│
├───features
│   ├───analytics
│   │       learning_analytics_service.dart
│   │
│   ├───auth
│   │       auth_state.dart
│   │
│   ├───chat
│   │       chat_store.dart
│   │
│   ├───chatbot
│   │       chatbot_store.dart
│   │       chatbot_widget.dart
│   │
│   ├───courses
│   │       courses_service.dart
│   │       course_model.dart
│   │
│   ├───files
│   │       file_models.dart
│   │       file_service.dart
│   │
│   ├───livestream
│   │       livestream_store.dart
│   │
│   ├───notifications
│   │       local_notification_service.dart
│   │       notification_models.dart
│   │       notification_store.dart
│   │
│   ├───quiz
│   │       quiz_service.dart
│   │
│   └───recommendations
│           recommendation_service.dart
│
├───routes
│   │   app_router.dart
│   │
│   └───guards
│           auth_guard.dart
│
└───screens
    ├───admin
    │   ├───analytics
    │   ├───courses
    │   │       course_management_screen.dart
    │   │
    │   ├───dashboard
    │   │       admin_dashboard.dart
    │   │
    │   ├───system
    │   │       system_settings_screen.dart
    │   │
    │   └───users
    │           user_management_screen.dart
    │
    ├───common
    │   │   home_screen.dart
    │   │   not_found_screen.dart
    │   │   root_shell.dart
    │   │
    │   └───auth
    │           forgot_password_screen.dart
    │           login_screen.dart
    │           register_screen.dart
    │
    ├───shared
    │   ├───dashboard
    │   │       dashboard_dispatcher.dart
    │   │
    │   ├───livestream
    │   │       livestream_screen.dart
    │   │
    │   ├───notifications
    │   │       notifications_prefs_screen.dart
    │   │       notifications_screen.dart
    │   │
    │   ├───profile
    │   │       profile_screen.dart
    │   │
    │   ├───settings
    │   │       settings_screen.dart
    │   │
    │   └───viewers
    ├───student
    │   ├───assignments
    │   ├───calendar
    │   ├───courses
    │   │   │   student_courses_screen.dart
    │   │   │
    │   │   └───course_detail
    │   │           chat_tab.dart
    │   │           course_detail_screen.dart
    │   │           files_tab.dart
    │   │           quizzes_tab.dart
    │   │
    │   ├───dashboard
    │   │       student_dashboard.dart
    │   │
    │   └───grades
    └───teacher
        ├───analytics
        ├───assignments
        ├───courses
        │       teacher_courses_screen.dart
        │
        ├───dashboard
        │       teacher_dashboard.dart
        │
        ├───gradebook
        ├───messaging
        ├───quiz
        │       quiz_creation_screen.dart
        │
        └───students
                student_management_screen.dart