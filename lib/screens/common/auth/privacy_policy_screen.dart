import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chính sách bảo mật'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chính sách bảo mật',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Cập nhật lần cuối: 30/10/2024',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chúng tôi cam kết bảo vệ quyền riêng tư và thông tin cá nhân của bạn. Chính sách này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ dữ liệu của bạn.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 1. Thông tin thu thập
            _buildSection(
              context,
              icon: Icons.info_outline,
              title: '1. Thông tin chúng tôi thu thập',
              content: [
                _buildSubSection('Thông tin cá nhân:', [
                  'Họ tên, email, số điện thoại',
                  'Thông tin đăng nhập (username, mật khẩu mã hóa)',
                  'Ảnh đại diện và thông tin hồ sơ',
                  'Thông tin học tập và tiến độ khóa học',
                ]),
                _buildSubSection('Dữ liệu sử dụng:', [
                  'Lịch sử truy cập và hoạt động trong ứng dụng',
                  'Thiết bị và thông tin kỹ thuật (IP, browser, OS)',
                  'Thời gian sử dụng và tương tác với nội dung',
                  'Thống kê học tập và kết quả bài tập',
                ]),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 2. Mục đích sử dụng
            _buildSection(
              context,
              icon: Icons.assignment_outlined,
              title: '2. Mục đích sử dụng thông tin',
              content: [
                _buildSubSection('Cung cấp dịch vụ:', [
                  'Quản lý tài khoản và xác thực người dùng',
                  'Cung cấp nội dung học tập phù hợp',
                  'Theo dõi tiến độ và cấp chứng chỉ',
                  'Hỗ trợ kỹ thuật và giải đáp thắc mắc',
                ]),
                _buildSubSection('Cải thiện dịch vụ:', [
                  'Phân tích hành vi người dùng để tối ưu UX',
                  'Phát triển tính năng mới phù hợp',
                  'Cải thiện chất lượng nội dung',
                  'Ngăn chặn gian lận và lạm dụng',
                ]),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 3. Chia sẻ thông tin
            _buildSection(
              context,
              icon: Icons.share_outlined,
              title: '3. Chia sẻ thông tin với bên thứ ba',
              content: [
                _buildNoticeBox(
                  context,
                  'Chúng tôi KHÔNG bán thông tin cá nhân của bạn',
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildSubSection('Trường hợp chia sẻ hợp lệ:', [
                  'Với sự đồng ý rõ ràng của bạn',
                  'Tuân thủ yêu cầu pháp luật',
                  'Bảo vệ quyền lợi hợp pháp của chúng tôi',
                  'Các đối tác dịch vụ với hợp đồng bảo mật',
                ]),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 4. Bảo mật dữ liệu
            _buildSection(
              context,
              icon: Icons.security,
              title: '4. Biện pháp bảo mật',
              content: [
                _buildSubSection('Bảo mật kỹ thuật:', [
                  'Mã hóa SSL/TLS cho tất cả dữ liệu truyền tải',
                  'Mã hóa mật khẩu với thuật toán an toàn',
                  'Firewall và hệ thống giám sát 24/7',
                  'Sao lưu dữ liệu định kỳ và phục hồi thảm họa',
                ]),
                _buildSubSection('Bảo mật quản lý:', [
                  'Kiểm soát truy cập nghiêm ngặt',
                  'Đào tạo nhân viên về bảo mật thông tin',
                  'Audit và kiểm tra bảo mật định kỳ',
                  'Phản ứng nhanh với sự cố bảo mật',
                ]),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 5. Quyền của người dùng
            _buildSection(
              context,
              icon: Icons.account_circle_outlined,
              title: '5. Quyền của bạn',
              content: [
                _buildRightItem(Icons.visibility, 'Truy cập', 'Xem thông tin cá nhân chúng tôi lưu trữ'),
                _buildRightItem(Icons.edit, 'Chỉnh sửa', 'Cập nhật hoặc sửa đổi thông tin cá nhân'),
                _buildRightItem(Icons.delete, 'Xóa bỏ', 'Yêu cầu xóa tài khoản và dữ liệu'),
                _buildRightItem(Icons.download, 'Xuất dữ liệu', 'Tải về bản sao dữ liệu cá nhân'),
                _buildRightItem(Icons.block, 'Phản đối', 'Từ chối xử lý dữ liệu cho mục đích cụ thể'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 6. Cookie và theo dõi
            _buildSection(
              context,
              icon: Icons.cookie,
              title: '6. Cookie và công nghệ theo dõi',
              content: [
                const Text(
                  'Chúng tôi sử dụng cookie và các công nghệ tương tự để:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                _buildBulletList([
                  'Duy trì phiên đăng nhập của bạn',
                  'Ghi nhớ tùy chọn và cài đặt',
                  'Phân tích cách sử dụng website/ứng dụng',
                  'Cung cấp nội dung được cá nhân hóa',
                ]),
                const SizedBox(height: 12),
                _buildNoticeBox(
                  context,
                  'Bạn có thể quản lý cookie trong cài đặt trình duyệt',
                  Colors.blue,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 7. Lưu trữ dữ liệu
            _buildSection(
              context,
              icon: Icons.storage,
              title: '7. Thời gian lưu trữ',
              content: [
                _buildSubSection('Dữ liệu tài khoản:', [
                  'Lưu trữ trong suốt thời gian tài khoản hoạt động',
                  'Xóa sau 2 năm không hoạt động (trừ khi có yêu cầu pháp lý)',
                ]),
                _buildSubSection('Dữ liệu học tập:', [
                  'Lưu trữ vĩnh viễn để cấp chứng chỉ và xác thực',
                  'Có thể ẩn danh hóa sau khi xóa tài khoản',
                ]),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 8. Liên hệ
            _buildSection(
              context,
              icon: Icons.contact_support,
              title: '8. Liên hệ về bảo mật',
              content: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Email bảo mật:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('privacy@lms.edu.vn'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Hotline:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('1900 1234 (8:00 - 17:00, T2-T6)'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Footer actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã tải xuống bản PDF chính sách bảo mật')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Tải PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Đã hiểu'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        ),
      ],
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        _buildBulletList(items),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(item)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoticeBox(BuildContext context, String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}