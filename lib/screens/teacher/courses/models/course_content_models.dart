class Lecture {
  final String id;
  String title;
  String type; // 'video', 'file', 'text' | backward: 'article','quiz'
  String? url; // for video link
  String? filePath; // for uploaded file
  String? textJson; // for quill document
  String? duration; // optional legacy

  Lecture({
    required this.id,
    required this.title,
    required this.type,
    this.url,
    this.filePath,
    this.textJson,
    this.duration,
  });
}

class CourseSection {
  final String id;
  String title;
  final List<Lecture> lectures;
  CourseSection({
    required this.id,
    required this.title,
    required this.lectures,
  });
}

class AssignmentItem {
  String title;
  DateTime deadline;
  int submitted;
  int total;
  String? description; // mô tả bài tập (tùy chọn)
  List<String> attachments; // danh sách tệp đính kèm (tên/đường dẫn)
  AssignmentItem({
    required this.title,
    required this.deadline,
    required this.submitted,
    required this.total,
    this.description,
    List<String>? attachments,
  }) : attachments = attachments ?? const [];
}
