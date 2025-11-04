import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';
import '../models/course_content_models.dart';

class TeacherContentTab extends StatefulWidget {
  const TeacherContentTab({
    super.key,
    required this.courseContent,
    required this.onAddSection,
    required this.onEditSection,
    required this.onDeleteSection,
    required this.onAddEditLecture,
    required this.onDeleteLecture,
    required this.onReorderSections,
    required this.onReorderLectures,
    required this.getIconForType,
    required this.getColorForType,
  });

  final List<dynamic> courseContent;
  final void Function(BuildContext ctx) onAddSection;
  final void Function(BuildContext ctx, int sectionIndex) onEditSection;
  final void Function(BuildContext ctx, int sectionIndex) onDeleteSection;
  final void Function(
    BuildContext ctx,
    int sectionIndex, {
    dynamic lecture,
    int? lectureIndex,
  })
  onAddEditLecture;
  final void Function(
    BuildContext ctx,
    int sectionIndex,
    int lectureIndex,
    String title,
  )
  onDeleteLecture;
  final void Function(int oldIndex, int newIndex) onReorderSections;
  final void Function(int sectionIndex, int oldIndex, int newIndex)
  onReorderLectures;
  final IconData Function(String type) getIconForType;
  final Color Function(String type) getColorForType;

  @override
  State<TeacherContentTab> createState() => _TeacherContentTabState();
}

class _TeacherContentTabState extends State<TeacherContentTab> {
  late List<CourseSection> _sections;

  @override
  void initState() {
    super.initState();
    _sections = widget.courseContent.isEmpty
        ? <CourseSection>[]
        : widget.courseContent.map((s) => _coerceSection(s)).toList();
  }

  CourseSection _coerceSection(dynamic s) {
    try {
      // Nếu đã đúng model chuẩn
      if (s is CourseSection) return s;
      // Nếu là Map hoặc object có các field title/lectures
      final title = _getString(s, ['title']) ?? 'Chương mới';
      final id =
          _getString(s, ['id']) ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final List<dynamic> rawLectures =
          _getList(s, ['lectures']) ?? <dynamic>[];
      final lectures = rawLectures.map((l) => _coerceLecture(l)).toList();
      return CourseSection(id: id, title: title, lectures: lectures);
    } catch (_) {
      return CourseSection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Chương mới',
        lectures: <Lecture>[],
      );
    }
  }

  Lecture _coerceLecture(dynamic l) {
    try {
      if (l is Lecture) return l;
      final title = _getString(l, ['title']) ?? 'Bài giảng mới';
      final id =
          _getString(l, ['id']) ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final type = _getString(l, ['type']) ?? 'text';
      return Lecture(
        id: id,
        title: title,
        type: type,
        url: _getString(l, ['url']),
        filePath: _getString(l, ['filePath']),
        textJson: _getString(l, ['textJson']),
        duration: _getString(l, ['duration']),
      );
    } catch (_) {
      return Lecture(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Bài giảng mới',
        type: 'text',
      );
    }
  }

  String? _getString(dynamic obj, List<String> keys) {
    try {
      if (obj is Map) {
        for (final k in keys) {
          final v = obj[k];
          if (v is String && v.isNotEmpty) return v;
          if (v is num) return v.toString();
        }
      } else {
        for (final k in keys) {
          try {
            final toJson = (obj as dynamic).toJson;
            if (toJson is Function) {
              final m = toJson();
              if (m is Map && m.containsKey(k)) {
                final v = m[k];
                if (v is String && v.isNotEmpty) return v;
                if (v is num) return v.toString();
              }
            }
          } catch (_) {}
          try {
            final v2 = (obj as dynamic);
            switch (k) {
              case 'id':
                final w = v2.id;
                if (w is String && w.isNotEmpty) return w;
                if (w is num) return w.toString();
                break;
              case 'title':
                final w = v2.title;
                if (w is String && w.isNotEmpty) return w;
                break;
              case 'type':
                final w = v2.type;
                if (w is String && w.isNotEmpty) return w;
                break;
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    return null;
  }

  List<dynamic>? _getList(dynamic obj, List<String> keys) {
    try {
      if (obj is Map) {
        for (final k in keys) {
          final v = obj[k];
          if (v is List) return v;
        }
      } else {
        for (final k in keys) {
          try {
            final toJson = (obj as dynamic).toJson;
            if (toJson is Function) {
              final m = toJson();
              if (m is Map && m.containsKey(k)) {
                final v = m[k];
                if (v is List) return v;
              }
            }
          } catch (_) {
            try {
              final v2 = (obj as dynamic).lectures;
              if (v2 is List) return v2;
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _handleAddSection(BuildContext ctx) async {
    final title = await _showSectionDialog(ctx);
    if (!mounted) return;
    if (title == null) return;
    setState(() {
      _sections.add(
        CourseSection(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          lectures: <Lecture>[],
        ),
      );
    });
    // Hook
    try {
      widget.onAddSection(context);
    } catch (_) {}
  }

  Future<void> _handleEditSection(BuildContext ctx, int sectionIndex) async {
    final section = _sections[sectionIndex];
    final currentTitle = _getString(section, ['title']) ?? '';
    final title = await _showSectionDialog(ctx, initial: currentTitle);
    if (!mounted) return;
    if (title == null) return;
    setState(() {
      section.title = title;
    });
    try {
      widget.onEditSection(context, sectionIndex);
    } catch (_) {}
  }

  Future<void> _handleDeleteSection(BuildContext ctx, int sectionIndex) async {
    final confirmed = await _confirmDelete(ctx, 'Xóa chương này?');
    if (!mounted) return;
    if (confirmed != true) return;
    setState(() {
      _sections.removeAt(sectionIndex);
    });
    try {
      widget.onDeleteSection(context, sectionIndex);
    } catch (_) {}
  }

  Future<void> _handleAddEditLecture(
    BuildContext ctx,
    int sectionIndex, {
    dynamic lecture,
    int? lectureIndex,
  }) async {
    final initialTitle = lecture == null
        ? ''
        : _getString(lecture, ['title']) ?? '';
    final initialType = lecture == null
        ? 'text'
        : _getString(lecture, ['type']) ?? 'text';
    final initialUrl = lecture == null ? null : _getString(lecture, ['url']);
    final initialFilePath = lecture == null
        ? null
        : _getString(lecture, ['filePath']);

    final result = await _showLectureDialog(
      ctx,
      initialTitle: initialTitle,
      initialType: initialType,
      initialUrl: initialUrl,
      initialFilePath: initialFilePath,
    );
    if (!mounted) return;
    if (result == null) return;

    final section = _sections[sectionIndex];

    setState(() {
      if (lecture == null) {
        section.lectures.add(
          Lecture(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: result.title,
            type: result.type,
            url: result.url,
            filePath: result.filePath,
          ),
        );
      } else {
        if (lectureIndex != null &&
            lectureIndex >= 0 &&
            lectureIndex < section.lectures.length) {
          final target = section.lectures[lectureIndex];
          target.title = result.title;
          target.type = result.type;
          target.url = result.url;
          target.filePath = result.filePath;
        }
      }
    });

    try {
      widget.onAddEditLecture(
        context,
        sectionIndex,
        lecture: lecture,
        lectureIndex: lectureIndex,
      );
    } catch (_) {}
  }

  Future<void> _handleDeleteLecture(
    BuildContext ctx,
    int sectionIndex,
    int lectureIndex,
    String title,
  ) async {
    final confirmed = await _confirmDelete(ctx, 'Xóa bài giảng "$title"?');
    if (!mounted) return;
    if (confirmed != true) return;
    final section = _sections[sectionIndex];
    setState(() {
      section.lectures.removeAt(lectureIndex);
    });
    try {
      widget.onDeleteLecture(context, sectionIndex, lectureIndex, title);
    } catch (_) {}
  }

  Future<String?> _showSectionDialog(
    BuildContext context, {
    String initial = '',
  }) async {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Chương'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Tên chương'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final v = controller.text.trim();
                if (v.isEmpty) return;
                Navigator.of(ctx).pop(v);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<_LectureFormResult?> _showLectureDialog(
    BuildContext context, {
    String initialTitle = '',
    String initialType = 'text',
    String? initialUrl,
    String? initialFilePath,
  }) async {
    final titleCtrl = TextEditingController(text: initialTitle);
    String type = initialType;
    final linkCtrl = TextEditingController(text: initialUrl ?? '');
    String? pickedFilePath = initialFilePath;
    String pickedFileName = pickedFilePath != null && pickedFilePath.isNotEmpty
        ? pickedFilePath.split('\\').last.split('/').last
        : '';
    return showDialog<_LectureFormResult>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Bài giảng'),
          content: StatefulBuilder(
            builder: (ctx, setLocal) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: 'Tiêu đề'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      items: const [
                        DropdownMenuItem(value: 'video', child: Text('Video')),
                        DropdownMenuItem(value: 'file', child: Text('Tệp')),
                        DropdownMenuItem(value: 'text', child: Text('Văn bản')),
                      ],
                      onChanged: (v) {
                        if (v != null) setLocal(() => type = v);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Loại nội dung',
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (type == 'video') ...[
                      TextField(
                        controller: linkCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Link Youtube/Vimeo',
                          hintText: 'https://...',
                        ),
                      ),
                    ] else if (type == 'file') ...[
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final res = await FilePicker.platform.pickFiles();
                              if (res != null && res.files.isNotEmpty) {
                                setLocal(() {
                                  pickedFilePath = res.files.single.path;
                                  pickedFileName = res.files.single.name;
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Chọn tệp'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              pickedFileName.isNotEmpty
                                  ? pickedFileName
                                  : 'Chưa chọn tệp',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final t = titleCtrl.text.trim();
                if (t.isEmpty) return;
                Navigator.of(ctx).pop(
                  _LectureFormResult(
                    title: t,
                    type: type,
                    url: type == 'video' ? linkCtrl.text.trim() : null,
                    filePath: type == 'file' ? pickedFilePath : null,
                  ),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _openLecture(Lecture lecture) async {
    try {
      // Capture messenger before any await to avoid using BuildContext across async gaps
      final messenger = ScaffoldMessenger.of(context);
      if (lecture.type == 'video') {
        final raw = lecture.url?.trim();
        if (raw == null || raw.isEmpty) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Không có URL để mở.')),
          );
          return;
        }
        Uri? uri = Uri.tryParse(raw);
        // Thêm https:// nếu thiếu scheme
        if (uri != null && !uri.hasScheme) {
          uri = Uri.parse('https://$raw');
        }
        if (uri == null) {
          messenger.showSnackBar(
            const SnackBar(content: Text('URL không hợp lệ.')),
          );
          return;
        }
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          messenger.showSnackBar(
            SnackBar(content: Text('Không thể mở URL: ${uri.toString()}')),
          );
        }
      } else if (lecture.type == 'file') {
        final path = lecture.filePath;
        if (path == null || path.isEmpty) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Không có tệp để mở.')),
          );
          return;
        }
        final res = await OpenFilex.open(path);
        if (res.type != ResultType.done) {
          messenger.showSnackBar(
            SnackBar(content: Text('Không thể mở tệp: ${res.message}')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return; // guard context usage if ever added below
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi khi mở nội dung: $e')),
      );
    }
  }

  void _reorderSections(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _sections.removeAt(oldIndex);
      _sections.insert(newIndex, item);
    });
    try {
      widget.onReorderSections(oldIndex, newIndex);
    } catch (_) {}
  }

  void _reorderLectures(int sectionIndex, int oldIndex, int newIndex) {
    final section = _sections[sectionIndex];
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = section.lectures.removeAt(oldIndex);
      section.lectures.insert(newIndex, item);
    });
    try {
      widget.onReorderLectures(sectionIndex, oldIndex, newIndex);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_sections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'Chưa có chương nào trong khóa học',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Hãy bắt đầu bằng cách thêm Chương mới để tổ chức nội dung.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _handleAddSection(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm Chương mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: _sections.length,
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) =>
                _reorderSections(oldIndex, newIndex),
            itemBuilder: (context, index) {
              final section = _sections[index];
              final List<Lecture> lectures = section.lectures;
              return Container(
                key: ValueKey(section.id),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.folder_rounded,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      section.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${lectures.length} bài giảng',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Sửa tên chương',
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _handleEditSection(context, index),
                        ),
                        IconButton(
                          tooltip: 'Xóa chương',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _handleDeleteSection(context, index),
                        ),
                        ReorderableDragStartListener(
                          index: index,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(Icons.drag_handle_rounded),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _handleAddEditLecture(context, index),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Thêm bài giảng'),
                          ),
                        ),
                      ),
                      if (lectures.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Chưa có bài giảng nào trong chương này',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        ReorderableListView.builder(
                          key: ValueKey('lectures-$index'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lectures.length,
                          buildDefaultDragHandles: false,
                          onReorder: (oldIndex, newIndex) =>
                              _reorderLectures(index, oldIndex, newIndex),
                          itemBuilder: (context, li) {
                            final lecture = lectures[li];
                            final color = widget.getColorForType(lecture.type);
                            String subtitle = '';
                            switch (lecture.type) {
                              case 'video':
                                subtitle =
                                    (lecture.url != null &&
                                        lecture.url!.isNotEmpty)
                                    ? 'Video • ${lecture.url}'
                                    : 'Video';
                                break;
                              case 'file':
                                final name = (lecture.filePath ?? '')
                                    .split('\\')
                                    .last
                                    .split('/')
                                    .last;
                                subtitle = name.isNotEmpty
                                    ? 'Tệp • $name'
                                    : 'Tệp tin';
                                break;
                              case 'text':
                                subtitle = 'Văn bản';
                                break;
                              default:
                                subtitle = lecture.duration ?? '';
                            }
                            return Container(
                              key: ValueKey(lecture.id),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    widget.getIconForType(lecture.type),
                                    color: color,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  lecture.title,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: subtitle.isEmpty
                                    ? null
                                    : Builder(
                                        builder: (context) {
                                          final isClickableVideo =
                                              lecture.type == 'video' &&
                                              (lecture.url?.isNotEmpty ??
                                                  false);
                                          final isClickableFile =
                                              lecture.type == 'file' &&
                                              (lecture.filePath?.isNotEmpty ??
                                                  false);
                                          final clickable =
                                              isClickableVideo ||
                                              isClickableFile;
                                          final baseStyle = TextStyle(
                                            fontSize: 12,
                                            color: clickable
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.primary
                                                : Colors.grey[600],
                                            decoration: clickable
                                                ? TextDecoration.underline
                                                : TextDecoration.none,
                                          );
                                          final sub = Text(
                                            subtitle,
                                            style: baseStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                          if (!clickable) return sub;
                                          return InkWell(
                                            onTap: () => _openLecture(lecture),
                                            child: sub,
                                          );
                                        },
                                      ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'Sửa bài giảng',
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                      ),
                                      onPressed: () => _handleAddEditLecture(
                                        context,
                                        index,
                                        lecture: lecture,
                                        lectureIndex: li,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Xóa bài giảng',
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _handleDeleteLecture(
                                        context,
                                        index,
                                        li,
                                        lecture.title,
                                      ),
                                    ),
                                    ReorderableDragStartListener(
                                      index: li,
                                      child: const Icon(
                                        Icons.drag_handle_rounded,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _openLecture(lecture),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () => _handleAddSection(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm Chương mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LectureFormResult {
  final String title;
  final String type;
  final String? url;
  final String? filePath;
  _LectureFormResult({
    required this.title,
    required this.type,
    this.url,
    this.filePath,
  });
}
