import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'course_model.dart';

// State holds courses keyed by id for fast lookup
class CoursesNotifier extends StateNotifier<Map<String, Course>> {
  CoursesNotifier() : super(<String, Course>{});

  void addOrUpdate(Course course) {
    state = {...state, course.id: course};
  }

  Course? getById(String id) => state[id];
}

final coursesProvider =
    StateNotifierProvider<CoursesNotifier, Map<String, Course>>(
      (ref) => CoursesNotifier(),
    );

// Selector for a single course by id
final courseByIdProvider = Provider.family<Course?, String>((ref, id) {
  final map = ref.watch(coursesProvider);
  return map[id];
});
