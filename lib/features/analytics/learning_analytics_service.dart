import '../../core/network/dio_client.dart';

class LearningAnalyticsData {
  const LearningAnalyticsData({
    required this.totalTimeSpentMin,
    required this.activitiesCount,
    required this.averagePerformance,
    required this.learningStreakDays,
    required this.engagement,
  });

  final int totalTimeSpentMin;
  final int activitiesCount;
  final double averagePerformance; // 0..100
  final int learningStreakDays;
  final Map<String, int> engagement; // chat, quiz, livestream, material
}

class LearningAnalyticsService {
  late final DioClient _dioClient;
  
  LearningAnalyticsService() {
    _dioClient = DioClient();
  }

  Future<LearningAnalyticsData> getAnalytics(int userId) async {
    try {
      // Call real backend analytics API
      final response = await _dioClient.dio.get('/users/analytics');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final analyticsData = response.data['data'];
        
        return LearningAnalyticsData(
          totalTimeSpentMin: analyticsData['time_spent_learning']?.toInt() ?? 0,
          activitiesCount: (analyticsData['courses_enrolled']?.toInt() ?? 0) + 
                          (analyticsData['assignments_submitted']?.toInt() ?? 0) + 
                          (analyticsData['forum_posts']?.toInt() ?? 0),
          averagePerformance: _calculatePerformance(analyticsData),
          learningStreakDays: _calculateStreakDays(analyticsData['last_login']),
          engagement: {
            'chatParticipation': analyticsData['forum_posts']?.toInt() ?? 0,
            'quizCompletion': analyticsData['assignments_submitted']?.toInt() ?? 0,
            'livestreamAttendance': analyticsData['session_duration']?.toInt() ?? 0,
            'materialAccess': analyticsData['courses_enrolled']?.toInt() ?? 0,
          },
        );
      } else {
        throw Exception('Failed to fetch analytics: ${response.data}');
      }
    } catch (e) {
      // Fallback to placeholder data on error
      return const LearningAnalyticsData(
        totalTimeSpentMin: 0,
        activitiesCount: 0,
        averagePerformance: 0.0,
        learningStreakDays: 0,
        engagement: {
          'chatParticipation': 0,
          'quizCompletion': 0,
          'livestreamAttendance': 0,
          'materialAccess': 0,
        },
      );
    }
  }

  double _calculatePerformance(Map<String, dynamic> analyticsData) {
    final completed = analyticsData['courses_completed']?.toInt() ?? 0;
    final enrolled = analyticsData['courses_enrolled']?.toInt() ?? 0;
    
    if (enrolled == 0) return 0.0;
    return (completed / enrolled * 100).clamp(0.0, 100.0);
  }

  int _calculateStreakDays(dynamic lastLogin) {
    if (lastLogin == null) return 0;
    
    try {
      final lastLoginDate = DateTime.parse(lastLogin.toString());
      final now = DateTime.now();
      final difference = now.difference(lastLoginDate).inDays;
      
      // If logged in within last 2 days, consider it a streak
      return difference <= 2 ? difference + 1 : 0;
    } catch (e) {
      return 0;
    }
  }
}

final learningAnalyticsService = LearningAnalyticsService();
