import 'package:flutter/material.dart';
import 'calendar_screen.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});
  
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sự kiện'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng chỉnh sửa sự kiện')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chia sẻ sự kiện')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [event.color.withValues(alpha: 0.1), event.color.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: event.color.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: event.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          event.type == 'assignment' ? Icons.assignment
                              : event.type == 'exam' ? Icons.quiz
                              : event.type == 'lecture' ? Icons.school
                              : Icons.event,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatEventType(event.type),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: event.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date & Time
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        _formatEventDateTime(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Description Section
            Text(
              'Mô tả',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                _getEventDescription(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Location Section (if applicable)
            if (event.type == 'lecture' || event.type == 'exam') ...[
              Text(
                'Địa điểm',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      _getEventLocation(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã thêm vào lịch cá nhân')),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Thêm vào lịch'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã đặt nhắc nhở')),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                    label: const Text('Nhắc nhở'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatEventType(String type) {
    switch (type) {
      case 'assignment': return 'Bài tập';
      case 'exam': return 'Kiểm tra';
      case 'lecture': return 'Bài giảng';
      default: return 'Sự kiện';
    }
  }
  
  String _formatEventDateTime() {
    final date = event.date;
    final weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    final weekday = weekdays[date.weekday % 7];
    
    return '$weekday, ${date.day}/${date.month}/${date.year} • ${_getEventTime()}';
  }
  
  String _getEventTime() {
    switch (event.type) {
      case 'assignment': return 'Hạn nộp: 23:59';
      case 'exam': return '09:00 - 10:30';
      case 'lecture': return '13:30 - 15:30';
      default: return 'Cả ngày';
    }
  }
  
  String _getEventDescription() {
    switch (event.type) {
      case 'assignment':
        return 'Hoàn thành bài tập về ${event.title.toLowerCase()}. Nộp bài qua hệ thống LMS trước ${_formatEventDateTime()}. Bài tập bao gồm lý thuyết và thực hành, yêu cầu nộp file PDF và source code.';
      case 'exam':
        return 'Kiểm tra giữa kỳ môn ${event.title}. Thời gian làm bài: 90 phút. Hình thức: Trắc nghiệm và tự luận. Sinh viên cần mang theo giấy tờ tùy thân và dụng cụ học tập.';
      case 'lecture':
        return 'Bài giảng về ${event.title}. Nội dung bao gồm lý thuyết cơ bản và các ví dụ thực tế. Sinh viên cần chuẩn bị trước bài học và tham gia tích cực thảo luận.';
      default:
        return 'Chi tiết về sự kiện ${event.title}. Vui lòng kiểm tra thông tin cập nhật từ giảng viên hoặc bộ môn phụ trách.';
    }
  }
  
  String _getEventLocation() {
    switch (event.type) {
      case 'exam': return 'Phòng B101 - Tòa nhà B';
      case 'lecture': return 'Phòng A205 - Tòa nhà A';
      default: return 'Online / LMS Platform';
    }
  }
}