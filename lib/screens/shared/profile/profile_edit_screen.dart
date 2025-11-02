import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/animated_form_widgets.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../../../core/animations/app_animations.dart';

// Form validation provider
final formValidationProvider = StateProvider.family<Map<String, String>, String>(
  (ref, formId) => {},
);

// Form submission state provider  
final formSubmissionProvider = StateProvider.family<FormSubmissionState, String>(
  (ref, formId) => FormSubmissionState.idle,
);

enum FormSubmissionState { idle, loading, success, error }

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> 
    with TickerProviderStateMixin {
  
  late AnimationController _pageController;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _linkedinController = TextEditingController();
  
  // Form values
  String _selectedGender = 'Nam';
  DateTime _selectedBirthDate = DateTime(1995, 1, 1);
  String _selectedCountry = 'Vietnam';
  bool _isPublicProfile = true;
  bool _allowMessages = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pageController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    
    _loadUserData();
    
    // Start page animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.forward();
    });
  }

  void _loadUserData() {
    // Mock current user data
    setState(() {
      _firstNameController.text = 'Nguyễn';
      _lastNameController.text = 'Văn An';
      _emailController.text = 'nguyenvanan@gmail.com';
      _phoneController.text = '0987654321';
      _bioController.text = 'Lập trình viên Flutter với 3 năm kinh nghiệm. Đam mê phát triển mobile app và học hỏi công nghệ mới.';
      _addressController.text = '123 Đường ABC, Quận 1, TP.HCM';
      _websiteController.text = 'https://nguyenvanan.dev';
      _linkedinController.text = 'https://linkedin.com/in/nguyenvanan';
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        actions: [
          BounceButton(
            onPressed: _saveProfile,
            child: TextButton(
              onPressed: _saveProfile,
              child: const Text('Lưu'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              FadeSlideAnimation(
                slideBegin: const Offset(0, -0.3),
                child: Center(
                  child: Column(
                    children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Chức năng thay đổi ảnh đại diện')),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Thay đổi ảnh đại diện',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Personal Information
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 100),
                child: _buildSection(
                  title: 'Thông tin cá nhân',
                  icon: Icons.person,
                  children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          label: 'Họ',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập họ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          label: 'Tên',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Vui lòng nhập tên';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    label: 'Ngày sinh',
                    value: _selectedBirthDate,
                    onChanged: (date) => setState(() => _selectedBirthDate = date),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Giới tính',
                    value: _selectedGender,
                    items: ['Nam', 'Nữ', 'Khác'],
                    onChanged: (value) => setState(() => _selectedGender = value!),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _bioController,
                    label: 'Giới thiệu bản thân',
                    hint: 'Viết vài dòng về bản thân...',
                    maxLines: 4,
                  ),
                ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Contact Information
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 200),
                child: _buildSection(
                  title: 'Thông tin liên hệ',
                  icon: Icons.contact_phone,
                children: [
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Vui lòng nhập email';
                      }
                      if (!value!.contains('@')) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Địa chỉ',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Quốc gia',
                    value: _selectedCountry,
                    items: ['Vietnam', 'Singapore', 'Thailand', 'Malaysia', 'Other'],
                    onChanged: (value) => setState(() => _selectedCountry = value!),
                  ),
                ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Social Links
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 300),
                child: _buildSection(
                  title: 'Liên kết xã hội',
                  icon: Icons.link,
                children: [
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website/Portfolio',
                    hint: 'https://yourwebsite.com',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _linkedinController,
                    label: 'LinkedIn',
                    hint: 'https://linkedin.com/in/yourprofile',
                    keyboardType: TextInputType.url,
                  ),
                ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy Settings
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 400),
                child: _buildSection(
                  title: 'Cài đặt riêng tư',
                  icon: Icons.privacy_tip,
                children: [
                  _buildSwitchTile(
                    title: 'Hồ sơ công khai',
                    subtitle: 'Cho phép người khác xem hồ sơ của bạn',
                    value: _isPublicProfile,
                    onChanged: (value) => setState(() => _isPublicProfile = value),
                  ),
                  _buildSwitchTile(
                    title: 'Cho phép nhắn tin',
                    subtitle: 'Người khác có thể gửi tin nhắn cho bạn',
                    value: _allowMessages,
                    onChanged: (value) => setState(() => _allowMessages = value),
                  ),
                ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Notification Settings
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 500),
                child: _buildSection(
                  title: 'Thông báo',
                  icon: Icons.notifications,
                children: [
                  _buildSwitchTile(
                    title: 'Thông báo email',
                    subtitle: 'Nhận thông báo qua email',
                    value: _emailNotifications,
                    onChanged: (value) => setState(() => _emailNotifications = value),
                  ),
                  _buildSwitchTile(
                    title: 'Thông báo đẩy',
                    subtitle: 'Nhận thông báo đẩy trên điện thoại',
                    value: _pushNotifications,
                    onChanged: (value) => setState(() => _pushNotifications = value),
                  ),
                ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              FadeSlideAnimation(
                delay: const Duration(milliseconds: 600),
                slideBegin: const Offset(0, 0.5),
                child: Row(
                  children: [
                    Expanded(
                      child: BounceButton(
                        onPressed: () => Navigator.pop(context),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Hủy'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final submissionState = ref.watch(formSubmissionProvider('profile'));
                          
                          return AnimatedFormSubmitButton(
                            text: 'Lưu thay đổi',
                            icon: Icons.save,
                            onPressed: _saveProfile,
                            isLoading: submissionState == FormSubmissionState.loading,
                            isSuccess: submissionState == FormSubmissionState.success,
                            isError: submissionState == FormSubmissionState.error,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
    final validationErrors = ref.watch(formValidationProvider('profile'));
    final fieldError = validationErrors[label];
    
    return AnimatedTextField(
      controller: controller,
      labelText: label,
      hintText: hint,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      errorText: fieldError,
      showError: fieldError != null,
      onChanged: (value) {
        // Clear error when user starts typing
        if (fieldError != null) {
          ref.read(formValidationProvider('profile').notifier).update(
            (state) => Map.from(state)..remove(label),
          );
        }
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return AnimatedDropdown<String>(
      value: value,
      items: items,
      itemLabel: (item) => item,
      labelText: label,
      onChanged: onChanged,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required void Function(DateTime) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text('${value.day}/${value.month}/${value.year}'),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return AnimatedCheckbox(
      value: value,
      title: title,
      subtitle: subtitle,
      onChanged: (newValue) => onChanged(newValue ?? false),
    );
  }

  void _saveProfile() async {
    // Clear previous errors
    ref.read(formValidationProvider('profile').notifier).state = {};
    
    // Validate form
    final errors = <String, String>{};
    
    if (_firstNameController.text.trim().isEmpty) {
      errors['Họ'] = 'Vui lòng nhập họ';
    }
    
    if (_lastNameController.text.trim().isEmpty) {
      errors['Tên'] = 'Vui lòng nhập tên';
    }
    
    if (_emailController.text.trim().isEmpty) {
      errors['Email'] = 'Vui lòng nhập email';
    } else if (!_emailController.text.contains('@')) {
      errors['Email'] = 'Email không hợp lệ';
    }
    
    if (errors.isNotEmpty) {
      // Set errors to trigger animations
      ref.read(formValidationProvider('profile').notifier).state = errors;
      return;
    }
    
    // Start loading
    ref.read(formSubmissionProvider('profile').notifier).state = FormSubmissionState.loading;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success state
      ref.read(formSubmissionProvider('profile').notifier).state = FormSubmissionState.success;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật hồ sơ thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Delay then pop
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          ref.read(formSubmissionProvider('profile').notifier).state = FormSubmissionState.idle;
          Navigator.pop(context);
        }
      });
      
    } catch (e) {
      // Error state
      ref.read(formSubmissionProvider('profile').notifier).state = FormSubmissionState.error;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      // Reset to idle after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          ref.read(formSubmissionProvider('profile').notifier).state = FormSubmissionState.idle;
        }
      });
    }
  }
}