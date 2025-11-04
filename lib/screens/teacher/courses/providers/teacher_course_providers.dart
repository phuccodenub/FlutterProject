import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_content_models.dart';
import '../../../../features/courses/course_model.dart';

// Current user (demo): Trong thực tế sẽ lấy từ hệ thống auth
final currentUserProvider = StateProvider<Map<String, String>?>((ref) {
  return {
    'id': 'SV001',
    'name': 'Nguyễn Văn A',
    'email': 'a.nguyen@example.com',
    'role': 'student',
  };
});

// Students
final studentsProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [
    {
      'id': 'SV001',
      'name': 'Nguyễn Văn A',
      'email': 'a.nguyen@example.com',
      'joined': '2025-10-01',
    },
    {
      'id': 'SV002',
      'name': 'Trần Thị B',
      'email': 'b.tran@example.com',
      'joined': '2025-10-02',
    },
    {
      'id': 'SV003',
      'name': 'Lê Hoàng C',
      'email': 'c.le@example.com',
      'joined': '2025-10-03',
    },
  ];
});

final studentQueryProvider = StateProvider<String>((ref) => '');

// Assignments
final assignmentsProvider = StateProvider<List<AssignmentItem>>((ref) {
  return [
    AssignmentItem(
      title: 'Bài tập 1: Widgets cơ bản',
      deadline: DateTime.now().add(const Duration(days: 3)),
      submitted: 12,
      total: 40,
    ),
    AssignmentItem(
      title: 'Quiz: State Management',
      deadline: DateTime.now().add(const Duration(days: 7)),
      submitted: 5,
      total: 40,
    ),
  ];
});

// Announcements
final announcementsProvider = StateProvider<List<Map<String, String>>>((ref) {
  return [
    {
      'title': 'Chào mừng đến với khóa học!',
      'message': 'Hãy đọc kỹ syllabus và hoàn thành khảo sát tuần 1.',
      'time': 'Hôm nay 09:00',
    },
    {
      'title': 'Cập nhật tài liệu buổi 2',
      'message': 'Đã upload slide và bài đọc tham khảo.',
      'time': 'Hôm qua 16:20',
    },
  ];
});

// =====================
// Courses (Teacher scope)
// =====================

class TeacherCoursesNotifier extends StateNotifier<Map<String, Course>> {
  TeacherCoursesNotifier() : super(<String, Course>{});

  void addOrUpdate(Course course) {
    state = {...state, course.id: course};
  }

  Course? getById(String id) => state[id];
}

final teacherCoursesProvider =
    StateNotifierProvider<TeacherCoursesNotifier, Map<String, Course>>(
      (ref) => TeacherCoursesNotifier(),
    );

final teacherCourseByIdProvider = Provider.family<Course?, String>((ref, id) {
  final map = ref.watch(teacherCoursesProvider);
  return map[id];
});
