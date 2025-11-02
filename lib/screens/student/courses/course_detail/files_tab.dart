import 'package:flutter/material.dart';
import '../../../../features/files/file_service.dart';
import '../../../../features/files/file_models.dart';
import '../../../../core/services/file_saver_service.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:async';
import '../../../shared/viewers/pdf_viewer_screen.dart';
import '../../../shared/viewers/video_viewer_screen.dart';

class FilesTabView extends StatefulWidget {
  const FilesTabView({super.key, required this.courseId});
  final String courseId;

  @override
  State<FilesTabView> createState() => _FilesTabViewState();
}

class _FilesTabViewState extends State<FilesTabView> {
  List<CourseFile> files = const [];
  bool loading = true;
  String category = 'all';
  String term = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await fileService.init();
    final list = await fileService.getFilesByCourse(widget.courseId);
    setState(() {
      files = list;
      loading = false;
    });
  }

  Future<void> _upload() async {
    final f = await fileService.pickAndUpload(widget.courseId);
    if (f != null) {
      final list = await fileService.getFilesByCourse(widget.courseId);
      setState(() => files = list);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _upload,
                child: const Text('Upload File'),
              ),
              const SizedBox(width: 8),
              Text('Files (${files.length})'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search files...',
                  ),
                  onChanged: (v) async {
                    term = v;
                    _debounce?.cancel();
                    _debounce = Timer(
                      const Duration(milliseconds: 300),
                      () async {
                        files = await fileService.searchFiles(
                          widget.courseId,
                          term: term,
                          category: category,
                        );
                        if (mounted) setState(() {});
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'lecture', child: Text('Lectures')),
                  DropdownMenuItem(
                    value: 'assignment',
                    child: Text('Assignments'),
                  ),
                  DropdownMenuItem(value: 'resource', child: Text('Resources')),
                  DropdownMenuItem(value: 'video', child: Text('Videos')),
                  DropdownMenuItem(value: 'document', child: Text('Documents')),
                  DropdownMenuItem(value: 'image', child: Text('Images')),
                ],
                onChanged: (v) async {
                  category = v ?? 'all';
                  files = await fileService.searchFiles(
                    widget.courseId,
                    term: term,
                    category: category,
                  );
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: files.isEmpty
              ? const Center(child: Text('No files'))
              : ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final f = files[index];
                    return ListTile(
                      title: Text(f.originalName),
                      subtitle: Text('${f.category} • ${f.mimeType}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Download button
                          IconButton(
                            tooltip: 'Tải xuống',
                            icon: const Icon(Icons.download),
                            onPressed: () async {
                              _showDownloadDialog(context, f);
                            },
                          ),
                          if (f.previewable)
                            IconButton(
                              tooltip: 'Preview',
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () async {
                                if (f.localPath != null) {
                                  await OpenFilex.open(f.localPath!);
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Không có file cục bộ để xem',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          Text('${f.downloadCount}'),
                        ],
                      ),
                      onTap: () async {
                        await fileService.incrementDownload(f.id);
                        final list = await fileService.getFilesByCourse(
                          widget.courseId,
                        );
                        setState(() => files = list);
                        if (f.localPath != null) {
                          if (f.mimeType.contains('pdf')) {
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PdfViewerScreen(path: f.localPath!),
                                ),
                              );
                            }
                          } else if (f.mimeType.startsWith('video/')) {
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      VideoViewerScreen(path: f.localPath!),
                                ),
                              );
                            }
                          }
                        }
                      },
                      onLongPress: () async {
                        final ok =
                            await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Xóa tệp?'),
                                content: Text(
                                  'Bạn chắc chắn muốn xóa "${f.originalName}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Hủy'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                        if (ok) {
                          await fileService.deleteFile(f.id);
                          final list = await fileService.getFilesByCourse(
                            widget.courseId,
                          );
                          setState(() => files = list);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _showDownloadDialog(BuildContext context, CourseFile file) async {
    if (!context.mounted) return;

    double progress = 0.0;
    String? errorMessage;

    // Show dialog
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, setDialogState) {
            return AlertDialog(
              title: const Text('Đang tải xuống'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tệp: ${file.originalName}',
                    style: Theme.of(statefulContext).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage == null) ...[
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(statefulContext).textTheme.bodySmall,
                    ),
                  ] else ...[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: Theme.of(statefulContext).textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Đóng'),
                ),
              ],
            );
          },
        );
      },
    );

    // Perform download
    try {
      // Build download URL (adjust based on your API)
      final downloadUrl =
          'https://api.lms.local/files/${file.id}/download';

      await FileSaverService.downloadAndSave(
        url: downloadUrl,
        fileName: file.originalName,
        onProgress: (progressValue) {
          progress = progressValue;
          // Rebuild dialog to show progress
        },
      );

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tải xuống "${file.originalName}" thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      errorMessage = e.toString();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi tải xuống: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
