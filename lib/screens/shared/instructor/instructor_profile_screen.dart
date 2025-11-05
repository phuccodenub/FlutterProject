import 'package:flutter/material.dart';
import '../../../core/services/user_api_service.dart';
import '../../../core/services/course_api_service.dart';
import '../../../core/models/models.dart';

class InstructorProfileScreen extends StatelessWidget {
  final String instructorId;

  const InstructorProfileScreen({
    super.key,
    required this.instructorId,
  });

  @override
  Widget build(BuildContext context) {
    final userService = UserApiService();
    final courseService = CourseApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin giảng viên'),
      ),
      body: FutureBuilder<User>(
        future: userService.getUserById(instructorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          final instructor = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar and basic info
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: instructor.avatar != null
                            ? NetworkImage(instructor.avatar!)
                            : null,
                        child: instructor.avatar == null
                            ? Text(
                                '${instructor.firstName[0]}${instructor.lastName[0]}',
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${instructor.firstName} ${instructor.lastName}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (instructor.educationLevel != null)
                        Text(
                          _getEducationLevelText(instructor.educationLevel!),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bio
                if (instructor.bio != null) ...[
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(instructor.bio!),
                  const SizedBox(height: 16),
                ],

                // Department
                _buildInfoCard(
                  context,
                  icon: Icons.business,
                  title: 'Khoa/Phòng ban',
                  content: instructor.department ?? 'Chưa cập nhật',
                ),

                // Specialization
                if (instructor.specialization != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.school,
                    title: 'Chuyên môn',
                    content: instructor.specialization!,
                  ),

                // Experience
                if (instructor.experienceYears != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.work,
                    title: 'Kinh nghiệm',
                    content: '${instructor.experienceYears} năm',
                  ),

                // Research interests
                if (instructor.researchInterests != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Lĩnh vực nghiên cứu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(instructor.researchInterests!),
                ],

                const SizedBox(height: 24),

                // Courses by this instructor
                const Text(
                  'Khóa học của giảng viên',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<PaginatedResponse<Course>>(
                  future: courseService
                      .getCoursesByInstructor(instructorId: instructorId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text('Không thể tải khóa học: ${snapshot.error}');
                    }

                    final courses = snapshot.data?.items ?? [];

                    if (courses.isEmpty) {
                      return const Text('Chưa có khóa học nào');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          child: ListTile(
                            title: Text(course.title),
                            subtitle: course.description != null &&
                                    course.description!.isNotEmpty
                                ? Text(course.description!)
                                : null,
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigate to course detail if needed
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }

  String _getEducationLevelText(EducationLevel level) {
    switch (level) {
      case EducationLevel.bachelor:
        return 'Cử nhân';
      case EducationLevel.master:
        return 'Thạc sĩ';
      case EducationLevel.phd:
        return 'Tiến sĩ';
      case EducationLevel.professor:
        return 'Giáo sư';
    }
  }
}
