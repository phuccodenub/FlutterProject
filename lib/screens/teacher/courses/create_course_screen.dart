import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../features/courses/course_model.dart';
import 'providers/teacher_course_providers.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/custom_cards.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/section_header.dart';

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

  String? _selectedCategory;
  File? _pickedImage;

  // Biến cờ để ngăn việc gọi image_picker nhiều lần
  bool _isPickingImage = false;

  final List<String> _categories = [
    'Lập trình di động',
    'Phát triển Web',
    'Khoa học dữ liệu',
    'Thiết kế UI/UX',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // SỬA LỖI: Cập nhật hàm _pickImage với biến cờ
  Future<void> _pickImage() async {
    // 1. Kiểm tra xem có đang chọn ảnh hay không, nếu có thì thoát
    if (_isPickingImage) return;

    try {
      // 2. Đặt cờ thành true để báo hiệu đang bận
      setState(() {
        _isPickingImage = true;
      });

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Lỗi khi chọn ảnh: $e');
      // Bạn có thể hiển thị SnackBar lỗi ở đây nếu muốn
    } finally {
      // 3. (QUAN TRỌNG) Luôn đặt cờ về false sau khi hoàn tất
      //    (dù thành công hay thất bại)
      setState(() {
        _isPickingImage = false;
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Capture messenger early to avoid using context across async gaps
    final messenger = ScaffoldMessenger.of(context);

    if (_pickedImage == null) {
      messenger.showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Vui lòng chọn ảnh bìa cho khóa học.')),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    try {
      // "Upload" ảnh: sao chép vào thư mục ứng dụng để dùng lâu dài
      final docsDir = await getApplicationDocumentsDirectory();
      final id = const Uuid().v4();
      final originalPath = _pickedImage!.path;
      final dotIndex = originalPath.lastIndexOf('.');
      final ext = dotIndex != -1 ? originalPath.substring(dotIndex) : '';
      final fileName = 'course_$id$ext';
      final destPath = '${docsDir.path}${Platform.pathSeparator}$fileName';
      final savedFile = await _pickedImage!.copy(destPath);

      // Parse ngày từ ô nhập (định dạng dd/MM/yyyy)
      DateTime? parseDdMMyyyy(String s) {
        try {
          final parts = s.split('/');
          if (parts.length != 3) return null;
          final d = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final y = int.tryParse(parts[2]);
          if (d == null || m == null || y == null) return null;
          return DateTime(y, m, d);
        } catch (_) {
          return null;
        }
      }

      final start = parseDdMMyyyy(_startDateController.text.trim());
      final end = parseDdMMyyyy(_endDateController.text.trim());

      final newCourse = Course(
        id: id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        code: 'NEW101',
        instructorName: 'Tên giáo viên',
        imageFile: savedFile,
        category: _selectedCategory,
        startDate: start,
        endDate: end,
      );

      // Lưu bằng Riverpod (teacher scope)
      ref.read(teacherCoursesProvider.notifier).addOrUpdate(newCourse);

      if (!mounted) return;
      // Điều hướng đến trang chi tiết của khóa học vừa tạo
      context.go('/course/${newCourse.id}');
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Không thể lưu khóa học: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CommonAppBar(
        title: 'Tạo khóa học mới',
        showNotificationsAction: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 16),
              _buildDetailsCard(),
              const SizedBox(height: 16),
              _buildImagePickerCard(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Thông tin cơ bản',
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 8),
        CustomCard(
          child: Column(
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Tên khóa học',
                hint: 'Ví dụ: Lập trình Flutter cho người mới',
                prefixIcon: const Icon(Icons.school_outlined),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tên khóa học không được để trống'
                    : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Mô tả khóa học',
                hint: 'Mô tả chi tiết về nội dung khóa học...',
                prefixIcon: const Icon(Icons.description_outlined),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Mô tả khóa học không được để trống'
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Chi tiết khóa học',
          icon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 8),
        CustomCard(
          child: Column(
            children: [
              _buildDropdown(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _startDateController,
                      label: 'Ngày bắt đầu',
                      hint: 'Chọn Ngày bắt đầu',
                      prefixIcon: const Icon(Icons.date_range_outlined),
                      readOnly: true,
                      onTap: () => _pickDate(_startDateController),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ngày bắt đầu không được để trống'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _endDateController,
                      label: 'Ngày kết thúc',
                      hint: 'Chọn Ngày kết thúc',
                      prefixIcon: const Icon(Icons.event_outlined),
                      readOnly: true,
                      onTap: () => _pickDate(_endDateController),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ngày kết thúc không được để trống'
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Ảnh bìa khóa học',
          icon: Icons.image_outlined,
        ),
        const SizedBox(height: 8),
        CustomCard(child: _buildImagePicker()),
      ],
    );
  }

  // _simpleCard không còn cần thiết vì đã dùng CustomCard

  Widget _buildSubmitButton() {
    return CustomButton(
      // Vô hiệu hóa nút khi đang chọn ảnh
      onPressed: _isPickingImage ? null : _submitForm,
      text: 'Tạo khóa học',
      icon: Icons.add_circle_outline,
      isExpanded: true,
    );
  }

  // Dùng CustomTextField thay vì TextFormField thông thường

  DropdownButtonFormField<String> _buildDropdown() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        labelText: 'Danh mục',
        hintText: 'Chọn danh mục khóa học',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category_outlined),
      ),

      initialValue: _selectedCategory,
      items: _categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            ),
          )
          .toList(),
      onChanged: (newValue) => setState(() => _selectedCategory = newValue),
      validator: (value) => value == null ? 'Vui lòng chọn danh mục' : null,
    );
  }

  // _buildDatePickerField và _inputDecoration không còn cần thiết

  Widget _buildImagePicker() {
    return GestureDetector(
      // Chỉ cho phép nhấn nếu không đang chọn ảnh
      onTap: _isPickingImage ? null : _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: _pickedImage != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _pickedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      // Hiển thị loading nếu đang chọn
                      child: _isPickingImage
                          ? const CircularProgressIndicator()
                          : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: Colors.green.shade600,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isPickingImage
                          ? 'Đang mở thư viện...'
                          : 'Nhấn để tải lên ảnh bìa',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PNG, JPG (tối đa 5MB)',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
