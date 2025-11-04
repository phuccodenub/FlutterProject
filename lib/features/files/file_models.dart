class CourseFile {
  const CourseFile({
    required this.id,
    required this.courseId,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.uploadedAt,
    required this.category,
    this.localPath,
    this.previewable = false,
    this.downloadCount = 0,
  });

  final String id;
  final String courseId;
  final String originalName;
  final String mimeType;
  final int size;
  final DateTime uploadedAt;
  final String
  category; // lecture | assignment | resource | video | document | image
  final String? localPath;
  final bool previewable;
  final int downloadCount;
}
