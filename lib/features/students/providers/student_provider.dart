import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

// Student service provider
final studentServiceProvider = Provider<StudentService>((ref) {
  return StudentService();
});

// Students state provider for a specific course
final courseStudentsProvider = StateNotifierProvider.family<CourseStudentsNotifier, AsyncValue<List<Student>>, String>((ref, courseId) {
  return CourseStudentsNotifier(ref.read(studentServiceProvider), courseId);
});

// Search query provider
final studentSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered students provider
final filteredStudentsProvider = Provider.family<AsyncValue<List<Student>>, String>((ref, courseId) {
  final studentsAsync = ref.watch(courseStudentsProvider(courseId));
  final searchQuery = ref.watch(studentSearchQueryProvider);
  
  return studentsAsync.when(
    data: (students) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(students);
      }
      
      final filtered = students.where((student) {
        return student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
               student.email.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// Student status filter provider
final studentStatusFilterProvider = StateProvider<String>((ref) => 'all');

// Students filtered by status
final statusFilteredStudentsProvider = Provider.family<AsyncValue<List<Student>>, String>((ref, courseId) {
  final filteredStudents = ref.watch(filteredStudentsProvider(courseId));
  final statusFilter = ref.watch(studentStatusFilterProvider);
  
  return filteredStudents.when(
    data: (students) {
      if (statusFilter == 'all') {
        return AsyncValue.data(students);
      }
      
      final filtered = students.where((student) {
        switch (statusFilter) {
          case 'active':
            return student.status == 'active';
          case 'suspended':
            return student.status == 'suspended';
          case 'inactive':
            return student.status == 'inactive';
          default:
            return true;
        }
      }).toList();
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

class CourseStudentsNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final StudentService _studentService;
  final String courseId;

  CourseStudentsNotifier(this._studentService, this.courseId) : super(const AsyncValue.loading()) {
    loadStudents();
  }

  Future<void> loadStudents() async {
    state = const AsyncValue.loading();
    
    try {
      final students = await _studentService.getCourseStudents(courseId);
      state = AsyncValue.data(students);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshStudents() async {
    // Keep current data while refreshing
    final currentState = state;
    
    try {
      final students = await _studentService.getCourseStudents(courseId);
      state = AsyncValue.data(students);
    } catch (error) {
      // Revert to current state if refresh fails
      state = currentState;
      rethrow;
    }
  }

  Future<bool> updateStudentStatus(String studentId, String newStatus) async {
    try {
      final success = await _studentService.updateStudentStatus(courseId, studentId, newStatus);
      
      if (success) {
        // Update local state
        state.whenData((students) {
          final updatedStudents = students.map((student) {
            if (student.id == studentId) {
              return student.copyWith(status: newStatus);
            }
            return student;
          }).toList();
          
          state = AsyncValue.data(updatedStudents);
        });
      }
      
      return success;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeStudent(String studentId) async {
    try {
      final success = await _studentService.removeStudentFromCourse(courseId, studentId);
      
      if (success) {
        // Remove from local state
        state.whenData((students) {
          final updatedStudents = students.where((student) => student.id != studentId).toList();
          state = AsyncValue.data(updatedStudents);
        });
      }
      
      return success;
    } catch (error) {
      return false;
    }
  }

  Future<bool> addStudent(String studentEmail) async {
    try {
      final success = await _studentService.addStudentToCourse(courseId, studentEmail);
      
      if (success) {
        // Refresh the list to get the new student
        await refreshStudents();
      }
      
      return success;
    } catch (error) {
      return false;
    }
  }
}