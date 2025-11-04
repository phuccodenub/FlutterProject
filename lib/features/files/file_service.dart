import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'file_models.dart';

class FileService {
  static const _boxName = 'course_files';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
  }

  Future<List<CourseFile>> getFilesByCourse(String courseId) async {
    final box = Hive.box<Map>(_boxName);
    final items =
        box.values
            .map((e) => _fromMap(Map<String, dynamic>.from(e)))
            .where((f) => f.courseId == courseId)
            .toList()
          ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return items;
  }

  Future<List<CourseFile>> searchFiles(
    String courseId, {
    String? term,
    String? category,
  }) async {
    final all = await getFilesByCourse(courseId);
    return all.where((f) {
      final okTerm =
          term == null ||
          term.isEmpty ||
          f.originalName.toLowerCase().contains(term.toLowerCase());
      final okCat =
          category == null || category == 'all' || f.category == category;
      return okTerm && okCat;
    }).toList();
  }

  Future<CourseFile?> getById(String id) async {
    final box = Hive.box<Map>(_boxName);
    for (final e in box.values) {
      final f = _fromMap(Map<String, dynamic>.from(e));
      if (f.id == id) return f;
    }
    return null;
  }

  Future<CourseFile?> pickAndUpload(
    String courseId, {
    String category = 'document',
  }) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    final file = result.files.single;

    final tmpDir = await getApplicationDocumentsDirectory();
    final destPath =
        '${tmpDir.path}/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    if (file.path != null) {
      await File(file.path!).copy(destPath);
    } else if (file.bytes != null) {
      await File(destPath).writeAsBytes(file.bytes!);
    } else {
      return null;
    }

    final cf = CourseFile(
      id: 'file-${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      originalName: file.name,
      mimeType: file.extension != null
          ? _mimeFromExt(file.extension!)
          : 'application/octet-stream',
      size: file.size,
      uploadedAt: DateTime.now(),
      category: category,
      localPath: destPath,
      previewable: _isPreviewable(
        file.extension != null ? _mimeFromExt(file.extension!) : '',
      ),
    );
    await _save(cf);
    return cf;
  }

  Future<void> incrementDownload(String fileId) async {
    final f = await getById(fileId);
    if (f == null) return;
    final updated = CourseFile(
      id: f.id,
      courseId: f.courseId,
      originalName: f.originalName,
      mimeType: f.mimeType,
      size: f.size,
      uploadedAt: f.uploadedAt,
      category: f.category,
      localPath: f.localPath,
      previewable: f.previewable,
      downloadCount: f.downloadCount + 1,
    );
    await _save(updated);
  }

  Future<void> deleteFile(String fileId) async {
    final box = Hive.box<Map>(_boxName);
    await box.delete(fileId);
  }

  Future<void> _save(CourseFile f) async {
    final box = Hive.box<Map>(_boxName);
    await box.put(f.id, _toMap(f));
  }

  bool _isPreviewable(String mime) {
    return mime.startsWith('image/') ||
        mime.contains('pdf') ||
        mime.startsWith('text/') ||
        mime.startsWith('video/') ||
        mime.startsWith('audio/');
  }

  String _mimeFromExt(String ext) {
    final e = ext.toLowerCase();
    switch (e) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'mp4':
      case 'mov':
      case 'm4v':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  Map<String, dynamic> _toMap(CourseFile f) => {
    'id': f.id,
    'courseId': f.courseId,
    'originalName': f.originalName,
    'mimeType': f.mimeType,
    'size': f.size,
    'uploadedAt': f.uploadedAt.toIso8601String(),
    'category': f.category,
    'localPath': f.localPath,
    'previewable': f.previewable,
    'downloadCount': f.downloadCount,
  };

  CourseFile _fromMap(Map<String, dynamic> m) => CourseFile(
    id: m['id'] as String,
    courseId: m['courseId'] as String,
    originalName: m['originalName'] as String,
    mimeType: m['mimeType'] as String,
    size: m['size'] as int,
    uploadedAt: DateTime.parse(m['uploadedAt'] as String),
    category: m['category'] as String,
    localPath: m['localPath'] as String?,
    previewable: m['previewable'] as bool? ?? false,
    downloadCount: m['downloadCount'] as int? ?? 0,
  );
}

final fileService = FileService();
