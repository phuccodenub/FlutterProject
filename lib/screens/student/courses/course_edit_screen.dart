import 'package:flutter/material.dart';

class CourseEditScreen extends StatefulWidget {
  const CourseEditScreen({super.key, required this.courseId});
  
  final String courseId;

  @override
  State<CourseEditScreen> createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _requirementsController = TextEditingController();
  
  // Form values
  String _selectedCategory = 'Mobile Development';
  String _selectedLevel = 'Beginner';
  String _selectedLanguage = 'Vietnamese';
  bool _isPublished = false;
  bool _allowComments = true;
  bool _allowDownloads = false;
  bool _requireEnrollment = true;
  
  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }
  
  void _loadCourseData() {
    // Mock data loading based on courseId
    setState(() {
      _titleController.text = 'Flutter Development Complete';
      _descriptionController.text = 'Khóa học Flutter từ cơ bản đến nâng cao, bao gồm các dự án thực tế và best practices trong phát triển ứng dụng mobile.';
      _shortDescController.text = 'Học Flutter từ zero đến hero';
      _priceController.text = '2990000';
      _durationController.text = '8';
      _requirementsController.text = 'Kiến thức cơ bản về lập trình\nĐam mê phát triển mobile app';
      _selectedCategory = 'Mobile Development';
      _selectedLevel = 'Intermediate';
      _isPublished = true;
    });
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _shortDescController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa khóa học'),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text('Lưu nháp'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _saveCourse,
            child: const Text('Lưu'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildSection(
                title: 'Thông tin cơ bản',
                icon: Icons.info,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Tên khóa học',
                    hint: 'Nhập tên khóa học',
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng nhập tên khóa học';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _shortDescController,
                    label: 'Mô tả ngắn',
                    hint: 'Mô tả ngắn gọn về khóa học',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Mô tả chi tiết',
                    hint: 'Mô tả chi tiết về nội dung, mục tiêu khóa học',
                    maxLines: 5,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Course Settings
              _buildSection(
                title: 'Thông tin khóa học',
                icon: Icons.settings,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Danh mục',
                          value: _selectedCategory,
                          items: [
                            'Mobile Development',
                            'Web Development', 
                            'Data Science',
                            'UI/UX Design',
                            'DevOps',
                          ],
                          onChanged: (value) => setState(() => _selectedCategory = value!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Cấp độ',
                          value: _selectedLevel,
                          items: ['Beginner', 'Intermediate', 'Advanced'],
                          onChanged: (value) => setState(() => _selectedLevel = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Giá khóa học (VNĐ)',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _durationController,
                          label: 'Thời lượng (tuần)',
                          hint: '4',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Ngôn ngữ',
                    value: _selectedLanguage,
                    items: ['Vietnamese', 'English', 'Bilingual'],
                    onChanged: (value) => setState(() => _selectedLanguage = value!),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Requirements
              _buildSection(
                title: 'Yêu cầu & Điều kiện',
                icon: Icons.checklist,
                children: [
                  _buildTextField(
                    controller: _requirementsController,
                    label: 'Yêu cầu học viên',
                    hint: 'Các kiến thức, kỹ năng cần có trước khi học',
                    maxLines: 4,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Settings
              _buildSection(
                title: 'Cài đặt khóa học',
                icon: Icons.tune,
                children: [
                  _buildSwitchTile(
                    title: 'Công khai khóa học',
                    subtitle: 'Khóa học sẽ hiển thị trong danh sách công khai',
                    value: _isPublished,
                    onChanged: (value) => setState(() => _isPublished = value),
                  ),
                  _buildSwitchTile(
                    title: 'Cho phép bình luận',
                    subtitle: 'Học viên có thể bình luận trong bài học',
                    value: _allowComments,
                    onChanged: (value) => setState(() => _allowComments = value),
                  ),
                  _buildSwitchTile(
                    title: 'Cho phép tải tài liệu',
                    subtitle: 'Học viên có thể tải về tài liệu bài học',
                    value: _allowDownloads,
                    onChanged: (value) => setState(() => _allowDownloads = value),
                  ),
                  _buildSwitchTile(
                    title: 'Yêu cầu đăng ký',
                    subtitle: 'Học viên phải đăng ký trước khi xem bài học',
                    value: _requireEnrollment,
                    onChanged: (value) => setState(() => _requireEnrollment = value),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Course Image & Media
              _buildSection(
                title: 'Hình ảnh & Media',
                icon: Icons.image,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 48, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text('Tải lên ảnh bìa khóa học', 
                             style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text('Khuyên dùng: 1920x1080px, dưới 2MB',
                             style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chức năng tải lên ảnh bìa')),
                            );
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Chọn ảnh bìa'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chức năng tải lên video giới thiệu')),
                            );
                          },
                          icon: const Icon(Icons.video_library),
                          label: const Text('Video giới thiệu'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saveCourse,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Lưu thay đổi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu nháp thành công'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _saveCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulate saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu thay đổi thành công'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Delay then pop
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }
}