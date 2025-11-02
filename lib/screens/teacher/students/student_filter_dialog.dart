import 'package:flutter/material.dart';

class StudentFilterDialog extends StatefulWidget {
  const StudentFilterDialog({super.key});

  @override
  State<StudentFilterDialog> createState() => _StudentFilterDialogState();
}

class _StudentFilterDialogState extends State<StudentFilterDialog> {
  // Filter state variables
  String? selectedCourse;
  String? selectedStatus;
  String? selectedGradeRange;
  RangeValues attendanceRange = const RangeValues(0, 100);
  bool showOnlyProblematic = false;
  String searchText = '';
  
  final TextEditingController _searchController = TextEditingController();

  // Sample data for dropdowns
  final List<String> courses = ['Tất cả khóa học', 'Toán cao cấp', 'Lập trình Java', 'Cơ sở dữ liệu', 'Mạng máy tính'];
  final List<String> statuses = ['Tất cả trạng thái', 'Đang học', 'Tạm dừng', 'Hoàn thành', 'Bỏ học'];
  final List<String> gradeRanges = ['Tất cả điểm', 'Xuất sắc (9-10)', 'Giỏi (8-8.9)', 'Khá (7-7.9)', 'Trung bình (5-6.9)', 'Yếu (<5)'];

  @override
  void initState() {
    super.initState();
    selectedCourse = courses[0];
    selectedStatus = statuses[0];
    selectedGradeRange = gradeRanges[0];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Lọc sinh viên'),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              _buildSection(
                title: 'Tìm kiếm theo tên',
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên sinh viên...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                searchText = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Course filter
              _buildSection(
                title: 'Khóa học',
                child: DropdownButtonFormField<String>(
                  initialValue: selectedCourse,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: courses.map((course) {
                    return DropdownMenuItem(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Status filter
              _buildSection(
                title: 'Trạng thái',
                child: DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(status),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(status),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Grade range filter
              _buildSection(
                title: 'Khoảng điểm',
                child: DropdownButtonFormField<String>(
                  initialValue: selectedGradeRange,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: gradeRanges.map((range) {
                    return DropdownMenuItem(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGradeRange = value;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Attendance range
              _buildSection(
                title: 'Tỷ lệ tham gia (${attendanceRange.start.round()}% - ${attendanceRange.end.round()}%)',
                child: RangeSlider(
                  values: attendanceRange,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  labels: RangeLabels(
                    '${attendanceRange.start.round()}%',
                    '${attendanceRange.end.round()}%',
                  ),
                  onChanged: (values) {
                    setState(() {
                      attendanceRange = values;
                    });
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Special filters
              _buildSection(
                title: 'Bộ lọc đặc biệt',
                child: CheckboxListTile(
                  value: showOnlyProblematic,
                  onChanged: (value) {
                    setState(() {
                      showOnlyProblematic = value ?? false;
                    });
                  },
                  title: const Text('Chỉ hiển thị sinh viên có vấn đề'),
                  subtitle: const Text('Điểm thấp, vắng nhiều, hoặc chưa nộp bài tập'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quick filters
              _buildSection(
                title: 'Bộ lọc nhanh',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickFilter('Sinh viên giỏi', Icons.star, Colors.orange),
                    _buildQuickFilter('Cần hỗ trợ', Icons.help, Colors.red),
                    _buildQuickFilter('Hoạt động tích cực', Icons.thumb_up, Colors.green),
                    _buildQuickFilter('Mới tham gia', Icons.new_releases, Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilters,
          child: const Text('Đặt lại'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Áp dụng'),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildQuickFilter(String label, IconData icon, Color color) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        // Handle quick filter selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã áp dụng bộ lọc: $label')),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đang học':
        return Colors.green;
      case 'Tạm dừng':
        return Colors.orange;
      case 'Hoàn thành':
        return Colors.blue;
      case 'Bỏ học':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _resetFilters() {
    setState(() {
      selectedCourse = courses[0];
      selectedStatus = statuses[0];
      selectedGradeRange = gradeRanges[0];
      attendanceRange = const RangeValues(0, 100);
      showOnlyProblematic = false;
      searchText = '';
      _searchController.clear();
    });
  }

  void _applyFilters() {
    // Simulate applying filters
    Navigator.pop(context);
    
    final filterSummary = _buildFilterSummary();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã áp dụng bộ lọc: $filterSummary'),
        action: SnackBarAction(
          label: 'Xem kết quả',
          onPressed: () {
            // Navigate to filtered results
          },
        ),
      ),
    );
  }

  String _buildFilterSummary() {
    List<String> activeFilers = [];
    
    if (searchText.isNotEmpty) {
      activeFilers.add('Tìm kiếm: "$searchText"');
    }
    
    if (selectedCourse != courses[0]) {
      activeFilers.add('Khóa học: $selectedCourse');
    }
    
    if (selectedStatus != statuses[0]) {
      activeFilers.add('Trạng thái: $selectedStatus');
    }
    
    if (selectedGradeRange != gradeRanges[0]) {
      activeFilers.add('Điểm: $selectedGradeRange');
    }
    
    if (attendanceRange.start != 0 || attendanceRange.end != 100) {
      activeFilers.add('Tham gia: ${attendanceRange.start.round()}-${attendanceRange.end.round()}%');
    }
    
    if (showOnlyProblematic) {
      activeFilers.add('Sinh viên có vấn đề');
    }
    
    return activeFilers.isEmpty ? 'Không có bộ lọc nào' : activeFilers.join(', ');
  }
}