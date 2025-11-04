import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_cards.dart';
import 'student_content_tab.dart';

class LectureContentScreen extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const LectureContentScreen({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
  });

  // Widget hiển thị nội dung dựa trên loại bài học
  Widget _buildContentArea() {
    switch (lesson.type) {
      case 'video':
        return const CustomCard(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      case 'document':
        return const CustomCard(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 60, color: AppColors.error),
                SizedBox(height: 16),
                Text('Nội dung PDF sẽ được hiển thị ở đây.'),
              ],
            ),
          ),
        );
      default: // 'text'
        return const CustomCard(
          padding: EdgeInsets.all(16),
          child: Text(
            'Đây là nội dung bài học dạng văn bản. Markdown sẽ được render ở đây để hiển thị các định dạng phức tạp hơn như tiêu đề, danh sách, và liên kết.',
            style: AppTypography.bodyLarge,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // A local variable to track completion state, as StatelessWidget is immutable.
    bool isCompleted = lesson.isCompleted;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title, style: AppTypography.h6),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Khu vực nội dung
            _buildContentArea(),
            const SizedBox(height: 24),

            // 2. Nút "Hoàn thành"
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return CustomButton(
                  text: isCompleted
                      ? 'Đã hoàn thành'
                      : 'Đánh dấu đã hoàn thành',
                  onPressed: isCompleted
                      ? null // Vô hiệu hóa nếu đã hoàn thành
                      : () {
                          // TODO: Gọi API để cập nhật trạng thái
                          setState(() {
                            isCompleted = true;
                            lesson.isCompleted = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã cập nhật trạng thái bài học.'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                  variant: isCompleted
                      ? ButtonVariant.success
                      : ButtonVariant.primary,
                  icon: isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                );
              },
            ),
          ],
        ),
      ),
      // 3. Điều hướng "Bài trước" / "Bài tiếp theo"
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              if (onPrevious != null) {
                onPrevious!();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đây là bài đầu tiên, không có bài trước.'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Bài trước'),
            style: TextButton.styleFrom(
              foregroundColor: onPrevious != null
                  ? AppColors.primary
                  : AppColors.grey400,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              if (onNext != null) {
                onNext!();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đây là bài cuối cùng, không có bài tiếp theo.',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Bài tiếp theo'),
            style: TextButton.styleFrom(
              foregroundColor: onNext != null
                  ? AppColors.primary
                  : AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}
