import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/services/chat_service.dart';
import '../../../features/courses/services/course_service.dart';
import 'conversation_list_screen.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final ChatService _chatService = ChatService();
  final CourseService _courseService = CourseService();

  void _showCreateChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo cuộc trò chuyện mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Chọn khóa học để tạo nhóm chat:'),
            const SizedBox(height: 16),
            FutureBuilder(
              future: _courseService.getAllCourses(limit: 50),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Lỗi: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return const Text('Không có khóa học nào');
                }

                final courses = snapshot.data!.items;
                return SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return ListTile(
                        title: Text(course.title),
                        subtitle: course.description.isNotEmpty
                            ? Text(
                                course.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () async {
                          Navigator.pop(context);
                          await _createChat(course.id, course.title);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  Future<void> _createChat(String courseId, String courseTitle) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const Center(child: CircularProgressIndicator()),
      );

      await _chatService.createConversation(
        courseId: courseId,
        title: 'Chat: $courseTitle',
      );

      if (!mounted) return;

      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tạo cuộc trò chuyện mới')),
      );

      // Optionally refresh the conversation list
      setState(() {});
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Tin nhắn',
        showNotificationsAction: false,
        actions: [
          IconButton(
            tooltip: 'Tạo cuộc trò chuyện',
            icon: const Icon(Icons.create_outlined),
            onPressed: _showCreateChatDialog,
          ),
        ],
      ),
      body: const ConversationListScreen(),
    );
  }
}
