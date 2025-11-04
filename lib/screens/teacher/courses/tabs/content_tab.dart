import 'package:flutter/material.dart';

class ContentTab extends StatelessWidget {
  const ContentTab({
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (courseContent.isEmpty) {
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
                onPressed: () => onAddSection(context),
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
            itemCount: courseContent.length,
            buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIndex) =>
                onReorderSections(oldIndex, newIndex),
            itemBuilder: (context, index) {
              final section = courseContent[index];
              final List<dynamic> lectures = section.lectures as List<dynamic>;
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
                      section.title as String,
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
                          onPressed: () => onEditSection(context, index),
                        ),
                        IconButton(
                          tooltip: 'Xóa chương',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => onDeleteSection(context, index),
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
                            onPressed: () => onAddEditLecture(context, index),
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
                          key: ValueKey('${section.id}-lectures'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lectures.length,
                          buildDefaultDragHandles: false,
                          onReorder: (oldIndex, newIndex) =>
                              onReorderLectures(index, oldIndex, newIndex),
                          itemBuilder: (context, li) {
                            final lecture = lectures[li];
                            final color = getColorForType(
                              lecture.type as String,
                            );
                            String subtitle = '';
                            switch (lecture.type as String) {
                              case 'video':
                                subtitle =
                                    (lecture.url as String?) != null &&
                                        (lecture.url as String).isNotEmpty
                                    ? 'Video • ${lecture.url}'
                                    : 'Video';
                                break;
                              case 'file':
                                final name =
                                    ((lecture.filePath as String?) ?? '')
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
                                subtitle = (lecture.duration as String?) ?? '';
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
                                    getIconForType(lecture.type as String),
                                    color: color,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  lecture.title as String,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: subtitle.isEmpty
                                    ? null
                                    : Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
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
                                      onPressed: () => onAddEditLecture(
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
                                      onPressed: () => onDeleteLecture(
                                        context,
                                        index,
                                        li,
                                        lecture.title as String,
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
                                onTap: () {},
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
                onPressed: () => onAddSection(context),
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
