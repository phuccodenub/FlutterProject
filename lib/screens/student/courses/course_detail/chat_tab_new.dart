import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/chat/chat.dart';
import '../../../../features/courses/providers/course_provider.dart';

/// Chat Tab View for Course Detail Screen
class ChatTabView extends ConsumerWidget {
  const ChatTabView({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get course information from provider
    final coursesState = ref.watch(coursesProvider);
    
    // Find course in loaded courses
    final course = coursesState.courses.where((c) => c.id == courseId).isNotEmpty 
        ? coursesState.courses.where((c) => c.id == courseId).first 
        : null;
    
    if (coursesState.isLoading && course == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (coursesState.error != null && course == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Lỗi tải thông tin khóa học: ${coursesState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(coursesProvider.notifier).refresh();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final courseName = course?.title ?? 'Khóa học';

    // Embed ChatScreen directly in the tab
    return ChatScreen(courseId: courseId, courseName: courseName);
  }
}
