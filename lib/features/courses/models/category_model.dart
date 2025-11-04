import 'package:equatable/equatable.dart';

/// Category Model for course categorization
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? iconUrl;
  final String? colorHex;
  final int courseCount;
  final bool isActive;
  final int sortOrder;
  final String? parentId;
  final List<CategoryModel> subcategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.iconUrl,
    this.colorHex,
    this.courseCount = 0,
    this.isActive = true,
    this.sortOrder = 0,
    this.parentId,
    this.subcategories = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      iconUrl: (json['icon_url'] as String?) ?? (json['icon'] as String?),
      colorHex: (json['color_hex'] as String?) ?? (json['color'] as String?),
      courseCount: json['course_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? (json['order_index'] as int? ?? 0),
      parentId: json['parent_id'] as String?,
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
                .map((subcat) => CategoryModel.fromJson(subcat))
                .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon_url': iconUrl,
      'color_hex': colorHex,
      'course_count': courseCount,
      'is_active': isActive,
      'sort_order': sortOrder,
      'parent_id': parentId,
      'subcategories': subcategories.map((subcat) => subcat.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? iconUrl,
    String? colorHex,
    int? courseCount,
    bool? isActive,
    int? sortOrder,
    String? parentId,
    List<CategoryModel>? subcategories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      colorHex: colorHex ?? this.colorHex,
      courseCount: courseCount ?? this.courseCount,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      parentId: parentId ?? this.parentId,
      subcategories: subcategories ?? this.subcategories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties
  bool get isParentCategory => parentId == null;
  bool get hasSubcategories => subcategories.isNotEmpty;
  String get courseCountDisplay =>
      courseCount == 0 ? 'Chưa có khóa học' : '$courseCount khóa học';

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    iconUrl,
    colorHex,
    courseCount,
    isActive,
    sortOrder,
    parentId,
    subcategories,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() =>
      'CategoryModel(id: $id, name: $name, courseCount: $courseCount)';
}

/// Category with statistics for analytics
class CategoryWithStats extends CategoryModel {
  final int totalEnrollments;
  final double averageRating;
  final int totalInstructors;
  final double totalRevenue;

  const CategoryWithStats({
    required super.id,
    required super.name,
    super.description,
    super.iconUrl,
    super.colorHex,
    super.courseCount,
    super.isActive,
    super.sortOrder,
    super.parentId,
    super.subcategories,
    required super.createdAt,
    required super.updatedAt,
    this.totalEnrollments = 0,
    this.averageRating = 0.0,
    this.totalInstructors = 0,
    this.totalRevenue = 0.0,
  });

  factory CategoryWithStats.fromJson(Map<String, dynamic> json) {
    final category = CategoryModel.fromJson(json);
    final stats = json['statistics'] as Map<String, dynamic>? ?? {};

    return CategoryWithStats(
      id: category.id,
      name: category.name,
      description: category.description,
      iconUrl: category.iconUrl,
      colorHex: category.colorHex,
      courseCount: category.courseCount,
      isActive: category.isActive,
      sortOrder: category.sortOrder,
      parentId: category.parentId,
      subcategories: category.subcategories,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      totalEnrollments: stats['total_enrollments'] as int? ?? 0,
      averageRating: (stats['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalInstructors: stats['total_instructors'] as int? ?? 0,
      totalRevenue: (stats['total_revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get formattedRating => averageRating.toStringAsFixed(1);
  String get enrollmentDisplay =>
      totalEnrollments == 0 ? 'Chưa có học viên' : '$totalEnrollments học viên';
  String get instructorDisplay => totalInstructors == 0
      ? 'Chưa có giảng viên'
      : '$totalInstructors giảng viên';

  @override
  List<Object?> get props => [
    ...super.props,
    totalEnrollments,
    averageRating,
    totalInstructors,
    totalRevenue,
  ];
}

/// Predefined categories for fallback
class DefaultCategories {
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'programming',
      'name': 'Lập trình',
      'description': 'Các khóa học về lập trình và phát triển phần mềm',
      'icon_url': '💻',
      'color_hex': '#3B82F6',
      'course_count': 0,
      'subcategories': [
        {'id': 'web-dev', 'name': 'Phát triển Web', 'parent_id': 'programming'},
        {
          'id': 'mobile-dev',
          'name': 'Phát triển Mobile',
          'parent_id': 'programming',
        },
        {
          'id': 'backend-dev',
          'name': 'Phát triển Backend',
          'parent_id': 'programming',
        },
      ],
    },
    {
      'id': 'design',
      'name': 'Thiết kế',
      'description': 'Thiết kế đồ họa, UI/UX và nghệ thuật số',
      'icon_url': '🎨',
      'color_hex': '#EF4444',
      'course_count': 0,
      'subcategories': [
        {'id': 'ui-ux', 'name': 'UI/UX Design', 'parent_id': 'design'},
        {
          'id': 'graphic-design',
          'name': 'Thiết kế đồ họa',
          'parent_id': 'design',
        },
      ],
    },
    {
      'id': 'business',
      'name': 'Kinh doanh',
      'description': 'Quản lý, marketing và phát triển kinh doanh',
      'icon_url': '💼',
      'color_hex': '#10B981',
      'course_count': 0,
      'subcategories': [
        {'id': 'marketing', 'name': 'Marketing', 'parent_id': 'business'},
        {'id': 'management', 'name': 'Quản lý', 'parent_id': 'business'},
      ],
    },
    {
      'id': 'language',
      'name': 'Ngôn ngữ',
      'description': 'Học ngoại ngữ và giao tiếp',
      'icon_url': '🌐',
      'color_hex': '#F59E0B',
      'course_count': 0,
      'subcategories': [
        {'id': 'english', 'name': 'Tiếng Anh', 'parent_id': 'language'},
        {'id': 'japanese', 'name': 'Tiếng Nhật', 'parent_id': 'language'},
      ],
    },
    {
      'id': 'science',
      'name': 'Khoa học',
      'description': 'Toán học, vật lý, hóa học và khoa học tự nhiên',
      'icon_url': '🔬',
      'color_hex': '#8B5CF6',
      'course_count': 0,
      'subcategories': [
        {'id': 'mathematics', 'name': 'Toán học', 'parent_id': 'science'},
        {'id': 'physics', 'name': 'Vật lý', 'parent_id': 'science'},
      ],
    },
  ];

  static List<CategoryModel> getDefaultCategories() {
    return categories.map((categoryData) {
      final data = Map<String, dynamic>.from(categoryData);
      data['created_at'] = DateTime.now().toIso8601String();
      data['updated_at'] = DateTime.now().toIso8601String();

      // Handle subcategories
      if (data['subcategories'] != null) {
        final subcats = (data['subcategories'] as List).map((subcat) {
          final subcatData = Map<String, dynamic>.from(subcat);
          subcatData['id'] = subcatData['id'] ?? '';
          subcatData['name'] = subcatData['name'] ?? '';
          subcatData['created_at'] = DateTime.now().toIso8601String();
          subcatData['updated_at'] = DateTime.now().toIso8601String();
          subcatData['course_count'] = 0;
          return subcatData;
        }).toList();
        data['subcategories'] = subcats;
      }

      return CategoryModel.fromJson(data);
    }).toList();
  }
}
