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
  final String? category; // Danh mục khóa học (Programming, Design, Business, etc.)
}

