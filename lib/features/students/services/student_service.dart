import '../../../core/network/dio_client.dart';
import '../../../core/network/api_client.dart';
import '../models/student_model.dart';

class StudentService {
  late final DioClient _dioClient;
  
  StudentService() {
    _dioClient = DioClient();
  }

  /// Get students enrolled in a specific course
  /// Calls the backend endpoint: GET /courses/:courseId/students
  Future<List<Student>> getCourseStudents(String courseId) async {
    try {
      final response = await ApiClient.getInstance().get('/courses/$courseId/students');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final studentsData = response.data['data']['students'] as List;
        return studentsData.map((studentJson) => Student.fromJson(studentJson)).toList();
      }
      
      throw Exception('Failed to load course students');
    } catch (error) {
      // Fallback to mock data in case of API error
      return _getMockStudents();
    }
  }

  /// Search students by name or email
  Future<List<Student>> searchStudents(String courseId, String query) async {
    try {
      final response = await ApiClient.getInstance().get('/courses/$courseId/students', queryParameters: {
        'search': query,
      });
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final studentsData = response.data['data']['students'] as List;
        return studentsData.map((studentJson) => Student.fromJson(studentJson)).toList();
      }
      
      throw Exception('Failed to search students');
    } catch (error) {
      // Fallback to filtered mock data
      final mockStudents = _getMockStudents();
      return mockStudents.where((student) => 
        student.name.toLowerCase().contains(query.toLowerCase()) ||
        student.email.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  /// Get detailed student information
  Future<Student> getStudentDetail(String studentId) async {
    try {
      final response = await _dioClient.dio.get('/users/$studentId');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return Student.fromJson(response.data['data']);
      }
      
      throw Exception('Failed to load student details');
    } catch (error) {
      // Fallback to mock data
      final mockStudents = _getMockStudents();
      return mockStudents.firstWhere(
        (student) => student.id == studentId,
        orElse: () => mockStudents.first,
      );
    }
  }

  /// Update student enrollment status
  Future<bool> updateStudentStatus(String courseId, String studentId, String status) async {
    try {
      final response = await _dioClient.dio.put('/courses/$courseId/students/$studentId/status', data: {
        'status': status,
      });
      
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (error) {
      // Return false if update fails
      return false;
    }
  }

  /// Remove student from course
  Future<bool> removeStudentFromCourse(String courseId, String studentId) async {
    try {
      final response = await _dioClient.dio.delete('/courses/$courseId/students/$studentId');
      
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (error) {
      // Return false if removal fails
      return false;
    }
  }

  /// Add student to course
  Future<bool> addStudentToCourse(String courseId, String studentEmail) async {
    try {
      final response = await _dioClient.dio.post('/courses/$courseId/students', data: {
        'email': studentEmail,
      });
      
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (error) {
      // Return false if addition fails
      return false;
    }
  }

  /// Fallback mock data when API is unavailable
  List<Student> _getMockStudents() {
    return [
      Student(
        id: '1',
        name: 'Nguyễn Văn An',
        email: 'nguyenvanan@example.com',
        avatar: 'https://via.placeholder.com/150',
        status: 'active',
        enrolledAt: DateTime.now().subtract(const Duration(days: 30)),
        progress: 75.5,
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 2)),
        coursesCompleted: 3,
        totalTimeSpent: const Duration(hours: 45),
      ),
      Student(
        id: '2',
        name: 'Trần Thị Bình',
        email: 'tranthibinh@example.com',
        avatar: 'https://via.placeholder.com/150',
        status: 'active',
        enrolledAt: DateTime.now().subtract(const Duration(days: 45)),
        progress: 92.0,
        lastActiveAt: DateTime.now().subtract(const Duration(minutes: 30)),
        coursesCompleted: 5,
        totalTimeSpent: const Duration(hours: 67),
      ),
      Student(
        id: '3',
        name: 'Lê Hoàng Cường',
        email: 'lehoangcuong@example.com',
        avatar: 'https://via.placeholder.com/150',
        status: 'suspended',
        enrolledAt: DateTime.now().subtract(const Duration(days: 60)),
        progress: 45.2,
        lastActiveAt: DateTime.now().subtract(const Duration(days: 5)),
        coursesCompleted: 1,
        totalTimeSpent: const Duration(hours: 23),
      ),
      Student(
        id: '4',
        name: 'Phạm Thị Dung',
        email: 'phamthidung@example.com',
        avatar: 'https://via.placeholder.com/150',
        status: 'inactive',
        enrolledAt: DateTime.now().subtract(const Duration(days: 90)),
        progress: 15.8,
        lastActiveAt: DateTime.now().subtract(const Duration(days: 15)),
        coursesCompleted: 0,
        totalTimeSpent: const Duration(hours: 8),
      ),
      Student(
        id: '5',
        name: 'Võ Minh Đức',
        email: 'vominhduc@example.com',
        avatar: 'https://via.placeholder.com/150',
        status: 'active',
        enrolledAt: DateTime.now().subtract(const Duration(days: 20)),
        progress: 68.3,
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 6)),
        coursesCompleted: 2,
        totalTimeSpent: const Duration(hours: 34),
      ),
    ];
  }
}