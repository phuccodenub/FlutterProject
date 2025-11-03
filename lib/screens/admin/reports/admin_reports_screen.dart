import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/common_app_bar.dart';

class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock chart data
    final lineData = [
      ChartData(label: 'T2', value: 120),
      ChartData(label: 'T3', value: 180),
      ChartData(label: 'T4', value: 160),
      ChartData(label: 'T5', value: 220),
      ChartData(label: 'T6', value: 260),
      ChartData(label: 'T7', value: 230),
      ChartData(label: 'CN', value: 200),
    ];

    final pieData = [
      ChartData(label: 'Học viên', value: 78),
      ChartData(label: 'Giáo viên', value: 18),
      ChartData(label: 'Admin', value: 4),
    ];

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Báo cáo & Thống kê',
        showNotificationsAction: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Tổng quan', icon: Icons.analytics),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: const [
              StatCard(
                icon: Icons.people_alt,
                value: '12,450',
                label: 'Người dùng hoạt động',
                color: Colors.blue,
                trend: '+3.2%',
              ),
              StatCard(
                icon: Icons.school,
                value: '342',
                label: 'Khóa học đang mở',
                color: Colors.green,
                trend: '+12',
              ),
              StatCard(
                icon: Icons.shopping_cart_checkout,
                value: '1,128',
                label: 'Đăng ký mới (30 ngày)',
                color: Colors.orange,
                trend: '+8.5%',
              ),
              StatCard(
                icon: Icons.star_rate,
                value: '4.6/5',
                label: 'Đánh giá trung bình',
                color: Colors.purple,
                trend: '+0.1',
              ),
            ],
          ),

          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Xu hướng sử dụng',
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SimpleLineChart(
                data: lineData,
                title: 'Người dùng hoạt động theo ngày',
                height: 200,
                lineColor: Colors.blue,
                showDots: true,
              ),
            ),
          ),

          const SizedBox(height: 24),

          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Cơ cấu người dùng',
            icon: Icons.pie_chart,
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SimplePieChart(
                data: pieData,
                title: 'Tỷ lệ vai trò',
                radius: 70,
                showLabels: true,
              ),
            ),
          ),

          const SizedBox(height: 24),
          const SectionHeader(title: 'Sự kiện gần đây', icon: Icons.history),
          const SizedBox(height: 12),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, color: Colors.indigo),
            ),
            title: 'Tạo báo cáo doanh thu tháng 10',
            subtitle: '1 giờ trước • bởi Hệ thống',
            trailing: const Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 8),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.sync, color: Colors.teal),
            ),
            title: 'Hoàn tất đồng bộ dữ liệu học viên',
            subtitle: 'Hôm qua • 22:30',
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
