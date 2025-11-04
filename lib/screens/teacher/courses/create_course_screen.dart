import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/utils/error_ui.dart';

import '../../../features/courses/providers/course_provider.dart';
import '../../../features/courses/services/course_service.dart';
import '../../../features/auth/auth_state.dart';

class CreateCourseScreen extends ConsumerStatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  ConsumerState<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends ConsumerState<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _durationController = TextEditingController(text: '40');

  String? _selectedCategory;
  String _selectedLevel = 'beginner';
  bool _isFree = true;
  File? _pickedImage;


  final List<String> _levels = [
    'beginner',
    'intermediate', 
    'advanced',
  ];

  String _getLevelDisplayName(String level) {
    switch (level) {
      case 'beginner':
        return 'Cơ bản';
      case 'intermediate':
        return 'Trung cấp';
      case 'advanced':
        return 'Nâng cao';
      default:
        return 'Cơ bản';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  void _submitForm() async {
    // if (_formKey.currentState!.validate()) {
    //   if (_pickedImage == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Vui lòng chọn ảnh bìa cho khóa học.'),
    //         backgroundColor: Colors.redAccent,
    //       ),
    //     );
    //     return;
    //   }

    //   final title = _titleController.text;
    //   final description = _descriptionController.text;
    //   final category = _selectedCategory;
    //   final startDate = _startDateController.text;
    //   final endDate = _endDateController.text;

    //   print('Course Title: $title');
    //   print('Description: $description');
    //   print('Category: $category');
    //   print('Start Date: $startDate');
    //   print('End Date: $endDate');
    //   print('Image Path: ${_pickedImage!.path}');
    // 1. Validate Form
    if (!_formKey.currentState!.validate()) {
      return; // Dừng lại nếu form không hợp lệ
    }
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          //         content: Text('Khóa học đã được tạo thành công!'),
          //         backgroundColor: Colors.green,
          //       ),
          //     );

          //     context.pop();
          //   }
          // }
          content: Text('Vui lòng chọn ảnh bìa cho khóa học.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 2. Get current user info
    final auth = ref.read(authProvider);
    final currentUser = auth.user;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đăng nhập để tạo khóa học'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Create course data object
    final price = _isFree ? 0.0 : double.tryParse(_priceController.text) ?? 0.0;
    final duration = int.tryParse(_durationController.text) ?? 40;
    
    final courseData = CourseCreateData(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      shortDescription: _descriptionController.text.trim().length > 100
          ? '${_descriptionController.text.trim().substring(0, 100)}...'
          : _descriptionController.text.trim(),
      categoryId: _selectedCategory, // Add selected category
      level: _selectedLevel,
      language: 'vi',
      price: price,
      currency: 'VND',
      isFree: _isFree,
      isFeatured: false,
      durationHours: duration,
      prerequisites: [],
      learningObjectives: [],
      tags: _selectedCategory != null ? [_selectedCategory!] : [],
    );

    try {
      // 4. Call CourseManagementService to create course
      final courseManagement = ref.read(courseManagementProvider);
      await courseManagement.createCourse(courseData);

      // 5. Refresh courses list
      ref.invalidate(coursesProvider);

      if (mounted) {
        // 6. Show success message and navigate back
        ErrorUI.showSuccessSnackBar(context, 'Khóa học đã được tạo thành công!');

        // Navigate back to teacher courses screen
        context.go('/teacher/courses');
      }
    } catch (e) {
      if (mounted) {
        ErrorUI.showErrorSnackBar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Tạo khóa học mới'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 12),
              _buildDetailsCard(),
              const SizedBox(height: 12),
              _buildImagePickerCard(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _simpleCard(
      children: [
        const SectionHeader(
          title: 'Thông tin cơ bản',
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _titleController,
          label: 'Tên khóa học',
          hint: 'Ví dụ: Lập trình Flutter cho người mới',
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _descriptionController,
          label: 'Mô tả khóa học',
          hint: 'Mô tả chi tiết về nội dung khóa học...',
          icon: Icons.description_outlined,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return _simpleCard(
      children: [
        const SectionHeader(
          title: 'Chi tiết khóa học',
          icon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 16),
        _buildDropdown(),
        const SizedBox(height: 12),
        _buildLevelDropdown(),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _durationController,
          label: 'Thời lượng (giờ)',
          hint: 'Ví dụ: 40',
          icon: Icons.access_time_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        _buildPricingSection(),
        const SizedBox(height: 12),
        _buildDatePickerField(
          controller: _startDateController,
          label: 'Ngày bắt đầu',
          icon: Icons.date_range_outlined,
        ),
        const SizedBox(height: 12),
        _buildDatePickerField(
          controller: _endDateController,
          label: 'Ngày kết thúc',
          icon: Icons.event_outlined,
        ),
      ],
    );
  }

  Widget _buildImagePickerCard() {
    return _simpleCard(
      children: [
        const SectionHeader(
          title: 'Ảnh bìa khóa học',
          icon: Icons.image_outlined,
        ),
        const SizedBox(height: 12),
        _buildImagePicker(),
      ],
    );
  }

  Widget _simpleCard({required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      onPressed: _submitForm,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Tạo khóa học'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, hint, icon),
      validator: (value) =>
          value == null || value.isEmpty ? '$label không được để trống' : null,
    );
  }

  DropdownButtonFormField<String> _buildDropdown() {
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.when(
      data: (categories) {
        final items = categories
            .map(
              (c) => DropdownMenuItem<String>(
                value: c.slug ?? c.id,
                child: Text(c.name),
              ),
            )
            .toList();

        return DropdownButtonFormField<String>(
          decoration: _inputDecoration(
            'Danh mục',
            'Chọn danh mục khóa học',
            Icons.category_outlined,
          ),
          // ignore: deprecated_member_use
          value: _selectedCategory,
          items: items,
          onChanged: (newValue) => setState(() => _selectedCategory = newValue),
          validator: (value) => value == null ? 'Vui lòng chọn danh mục' : null,
        );
      },
      loading: () => DropdownButtonFormField<String>(
        decoration: _inputDecoration(
          'Danh mục',
          'Đang tải danh mục...',
          Icons.category_outlined,
        ),
        items: const [],
        onChanged: null,
      ),
      error: (error, stack) => DropdownButtonFormField<String>(
        decoration: _inputDecoration(
          'Danh mục',
          'Không thể tải danh mục',
          Icons.category_outlined,
        ),
        items: const [],
        onChanged: null,
      ),
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _inputDecoration(label, 'Chọn $label', icon),
      onTap: () => _pickDate(controller),
      validator: (value) =>
          value == null || value.isEmpty ? '$label không được để trống' : null,
    );
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green.shade600, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _pickedImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _pickedImage!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 45,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhấn để tải lên ảnh bìa',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration('Cấp độ', 'Chọn cấp độ khóa học', Icons.school_outlined),
      // ignore: deprecated_member_use
      value: _selectedLevel,
      items: _levels
          .map(
            (level) => DropdownMenuItem<String>(
              value: level,
              child: Text(_getLevelDisplayName(level)),
            ),
          )
          .toList(),
      onChanged: (newValue) => setState(() => _selectedLevel = newValue!),
    );
  }

  Widget _buildPricingSection() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isFree,
              onChanged: (value) => setState(() => _isFree = value!),
            ),
            const Text('Khóa học miễn phí'),
          ],
        ),
        if (!_isFree) ...[
          const SizedBox(height: 8),
          _buildTextField(
            controller: _priceController,
            label: 'Giá khóa học (VND)',
            hint: 'Ví dụ: 500000',
            icon: Icons.attach_money_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }

}
