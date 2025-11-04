import '../courses/course_model.dart';

class Recommendation {
  const Recommendation({
    required this.id,
    required this.course,
    required this.reason,
    required this.confidence,
    required this.category,
  });

  final String id;
  final Course course;
  final String reason;
  final double confidence; // 0..1
  final String
  category; // similar_users | content_based | trending | completion_pattern
}

class RecommendationService {
  Future<List<Recommendation>> getRecommendations(
    int userId, {
    int limit = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final demoCourses = _demoCourses();
    return [
      Recommendation(
        id: 'rec-1',
        course: demoCourses[0],
        reason: 'Based on your interest in React',
        confidence: 0.86,
        category: 'content_based',
      ),
      Recommendation(
        id: 'rec-2',
        course: demoCourses[1],
        reason: 'Popular among similar students',
        confidence: 0.78,
        category: 'similar_users',
      ),
      Recommendation(
        id: 'rec-3',
        course: demoCourses[2],
        reason: 'Trending course with high engagement',
        confidence: 0.73,
        category: 'trending',
      ),
    ].take(limit).toList();
  }

  List<Course> _demoCourses() => const [
    Course(
      id: '1',
      title: 'Introduction to React Development',
      description: 'Learn React fundamentals: components, hooks, state.',
      code: 'CS101',
      instructorName: 'Dr. John Smith',
      thumbnailUrl: null,
      enrollmentCount: 23,
    ),
    Course(
      id: '2',
      title: 'Advanced JavaScript Concepts',
      description: 'Closures, prototypes, async programming, ES6+.',
      code: 'CS201',
      instructorName: 'Prof. Sarah Wilson',
      thumbnailUrl: null,
      enrollmentCount: 18,
    ),
    Course(
      id: '3',
      title: 'Full-Stack Web Development',
      description: 'Frontend + Backend with Node.js, React, DBs.',
      code: 'CS301',
      instructorName: 'Dr. John Smith',
      thumbnailUrl: null,
      enrollmentCount: 35,
    ),
  ];
}

final recommendationService = RecommendationService();
