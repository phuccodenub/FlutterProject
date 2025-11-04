import 'dart:io'; // <-- QUAN TRỌNG: Cần import để sử dụng kiểu 'File'

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.instructorName,
    this.thumbnailUrl,
    this.enrollmentCount = 0,
    this.duration,
    this.imageFile, // <-- Thêm thuộc tính này
    this.category, // <-- Thêm category
    this.startDate, // <-- Thêm ngày bắt đầu
    this.endDate, // <-- Thêm ngày kết thúc
  });

  final String id;
  final String title;
  final String description;
  final String code;
  final String instructorName;
  final String? thumbnailUrl; // Dùng cho ảnh từ server
  final int enrollmentCount;
  final String? duration;
  final File? imageFile; // Dùng cho ảnh vừa chọn từ máy
  final String?
  category; // Danh mục khóa học (Programming, Design, Business, etc.)
  final DateTime? startDate; // Ngày bắt đầu khóa học
  final DateTime? endDate; // Ngày kết thúc khóa học
}
