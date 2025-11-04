import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Simple rich text editor
class SimpleRichTextEditor extends StatefulWidget {
  final String? initialText;
  final Function(String)? onTextChanged;
  final bool readOnly;
  final double minHeight;
  final String? placeholder;

  const SimpleRichTextEditor({
    super.key,
    this.initialText,
    this.onTextChanged,
    this.readOnly = false,
    this.minHeight = 200,
    this.placeholder,
  });

  @override
  State<SimpleRichTextEditor> createState() => _SimpleRichTextEditorState();
}

class _SimpleRichTextEditorState extends State<SimpleRichTextEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  TextAlign _textAlign = TextAlign.left;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [if (!widget.readOnly) _buildToolbar(), _buildEditor()],
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: AppColors.grey300),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          // Text formatting
          _buildToolbarButton(
            icon: Icons.format_bold,
            isActive: _isBold,
            onPressed: () => setState(() => _isBold = !_isBold),
            tooltip: 'Đậm',
          ),
          _buildToolbarButton(
            icon: Icons.format_italic,
            isActive: _isItalic,
            onPressed: () => setState(() => _isItalic = !_isItalic),
            tooltip: 'Nghiêng',
          ),
          _buildToolbarButton(
            icon: Icons.format_underlined,
            isActive: _isUnderline,
            onPressed: () => setState(() => _isUnderline = !_isUnderline),
            tooltip: 'Gạch chân',
          ),

          const SizedBox(width: AppSpacing.sm),
          Container(width: 1, height: 24, color: AppColors.grey300),
          const SizedBox(width: AppSpacing.sm),

          // Text alignment
          _buildToolbarButton(
            icon: Icons.format_align_left,
            isActive: _textAlign == TextAlign.left,
            onPressed: () => setState(() => _textAlign = TextAlign.left),
            tooltip: 'Căn trái',
          ),
          _buildToolbarButton(
            icon: Icons.format_align_center,
            isActive: _textAlign == TextAlign.center,
            onPressed: () => setState(() => _textAlign = TextAlign.center),
            tooltip: 'Căn giữa',
          ),
          _buildToolbarButton(
            icon: Icons.format_align_right,
            isActive: _textAlign == TextAlign.right,
            onPressed: () => setState(() => _textAlign = TextAlign.right),
            tooltip: 'Căn phải',
          ),

          const SizedBox(width: AppSpacing.sm),
          Container(width: 1, height: 24, color: AppColors.grey300),
          const SizedBox(width: AppSpacing.sm),

          // Lists
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            onPressed: () => _insertText('• '),
            tooltip: 'Danh sách dấu chấm',
          ),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            onPressed: () => _insertText('1. '),
            tooltip: 'Danh sách số',
          ),

          const SizedBox(width: AppSpacing.sm),
          Container(width: 1, height: 24, color: AppColors.grey300),
          const SizedBox(width: AppSpacing.sm),

          // Other formatting
          _buildToolbarButton(
            icon: Icons.link,
            onPressed: _insertLink,
            tooltip: 'Thêm liên kết',
          ),
          _buildToolbarButton(
            icon: Icons.image,
            onPressed: _insertImage,
            tooltip: 'Thêm hình ảnh',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    bool isActive = false,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconSm,
            color: isActive ? AppColors.primary : AppColors.grey600,
          ),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: AppColors.grey300),
        borderRadius: widget.readOnly
            ? BorderRadius.circular(AppRadius.md)
            : const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.md),
                bottomRight: Radius.circular(AppRadius.md),
              ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        maxLines: null,
        textAlign: _textAlign,
        style: TextStyle(
          fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
          decoration: _isUnderline
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder ?? 'Nhập nội dung...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppSpacing.md),
        ),
        onChanged: widget.onTextChanged,
      ),
    );
  }

  void _insertText(String text) {
    final cursorPosition = _controller.selection.start;
    final currentText = _controller.text;

    final newText =
        currentText.substring(0, cursorPosition) +
        text +
        currentText.substring(cursorPosition);

    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + text.length),
    );

    widget.onTextChanged?.call(newText);
  }

  void _insertLink() {
    showDialog(
      context: context,
      builder: (context) => _LinkDialog(
        onInsert: (url, text) {
          final linkText = '[${text.isNotEmpty ? text : url}]($url)';
          _insertText(linkText);
        },
      ),
    );
  }

  void _insertImage() {
    showDialog(
      context: context,
      builder: (context) => _ImageDialog(
        onInsert: (url, alt) {
          final imageText = '![${alt.isNotEmpty ? alt : 'image'}]($url)';
          _insertText(imageText);
        },
      ),
    );
  }
}

/// Dialog for inserting links
class _LinkDialog extends StatefulWidget {
  final Function(String url, String text) onInsert;

  const _LinkDialog({required this.onInsert});

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  final _urlController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm liên kết'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://example.com',
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Văn bản hiển thị',
              hintText: 'Văn bản liên kết',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (_urlController.text.isNotEmpty) {
              widget.onInsert(_urlController.text, _textController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}

/// Dialog for inserting images
class _ImageDialog extends StatefulWidget {
  final Function(String url, String alt) onInsert;

  const _ImageDialog({required this.onInsert});

  @override
  State<_ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<_ImageDialog> {
  final _urlController = TextEditingController();
  final _altController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _altController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm hình ảnh'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL hình ảnh',
              hintText: 'https://example.com/image.jpg',
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _altController,
            decoration: const InputDecoration(
              labelText: 'Văn bản thay thế',
              hintText: 'Mô tả hình ảnh',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (_urlController.text.isNotEmpty) {
              widget.onInsert(_urlController.text, _altController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}

/// Rich text viewer for displaying formatted content
class RichTextViewer extends StatelessWidget {
  final String content;
  final TextStyle? style;

  const RichTextViewer({super.key, required this.content, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.grey300),
      ),
      child: _parseAndDisplayContent(context),
    );
  }

  Widget _parseAndDisplayContent(BuildContext context) {
    // Simple markdown-like parsing
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (String line in lines) {
      widgets.add(_parseLineToWidget(context, line));
      widgets.add(const SizedBox(height: AppSpacing.xs));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _parseLineToWidget(BuildContext context, String line) {
    // Handle headers
    if (line.startsWith('# ')) {
      return Text(line.substring(2), style: AppTypography.h4);
    } else if (line.startsWith('## ')) {
      return Text(line.substring(3), style: AppTypography.h5);
    } else if (line.startsWith('### ')) {
      return Text(line.substring(4), style: AppTypography.h6);
    }
    // Handle lists
    else if (line.startsWith('• ') || line.startsWith('- ')) {
      return Padding(
        padding: const EdgeInsets.only(left: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                line.substring(2),
                style: style ?? AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      );
    } else if (RegExp(r'^\d+\. ').hasMatch(line)) {
      final match = RegExp(r'^(\d+)\. (.*)').firstMatch(line);
      if (match != null) {
        return Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${match.group(1)}. ',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  match.group(2) ?? '',
                  style: style ?? AppTypography.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }
    }

    // Handle links and images in text
    return _buildRichText(context, line);
  }

  Widget _buildRichText(BuildContext context, String text) {
    final spans = <InlineSpan>[];
    final linkRegex = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
    final imageRegex = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)');

    int lastIndex = 0;

    // Find all matches
    final allMatches = <RegExpMatch>[];
    allMatches.addAll(linkRegex.allMatches(text));
    allMatches.addAll(imageRegex.allMatches(text));
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      // Add text before the match
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: style ?? AppTypography.bodyMedium,
          ),
        );
      }

      // Add the match
      if (match.pattern == linkRegex) {
        spans.add(
          TextSpan(
            text: match.group(1),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      } else if (match.pattern == imageRegex) {
        spans.add(
          TextSpan(
            text: '[Hình ảnh: ${match.group(1)}]',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.secondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: style ?? AppTypography.bodyMedium,
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}

/// Markdown editor with preview
class MarkdownEditor extends StatefulWidget {
  final String? initialContent;
  final Function(String)? onChanged;
  final bool showPreview;

  const MarkdownEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.showPreview = true,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showPreview) _buildTabBar(),
        Expanded(
          child: widget.showPreview
              ? TabBarView(
                  controller: _tabController,
                  children: [_buildEditor(), _buildPreview()],
                )
              : _buildEditor(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: AppColors.grey300),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey600,
        tabs: const [
          Tab(text: 'Chỉnh sửa'),
          Tab(text: 'Xem trước'),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: AppColors.grey300),
        borderRadius: widget.showPreview
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.md),
                bottomRight: Radius.circular(AppRadius.md),
              )
            : BorderRadius.circular(AppRadius.md),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText:
              'Nhập nội dung Markdown...\n\n'
              '# Tiêu đề lớn\n'
              '## Tiêu đề nhỏ\n'
              '**Đậm** *Nghiêng*\n'
              '- Danh sách\n'
              '[Liên kết](url)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSpacing.md),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      child: RichTextViewer(content: _controller.text),
    );
  }
}
