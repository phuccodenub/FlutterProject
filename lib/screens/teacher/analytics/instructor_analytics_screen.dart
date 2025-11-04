import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/analytics_provider_mock.dart';
import '../../../core/models/analytics.dart';

class InstructorAnalyticsScreen extends ConsumerWidget {
  const InstructorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock instructor ID for demo
    const instructorId = 'instructor_1';
    final analyticsState = ref.watch(instructorAnalyticsProvider(instructorId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Analytics'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(instructorAnalyticsProvider(instructorId).notifier)
                  .refreshDashboard(instructorId);
            },
          ),
        ],
      ),
      body: analyticsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : analyticsState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${analyticsState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(
                          instructorAnalyticsProvider(instructorId).notifier,
                        )
                        .refreshDashboard(instructorId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _buildDashboardContent(context, analyticsState, ref, instructorId),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    InstructorDashboardState state,
    WidgetRef ref,
    String instructorId,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(instructorAnalyticsProvider(instructorId).notifier)
            .refreshDashboard(instructorId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(context, state.dashboardData),
            const SizedBox(height: 20),
            _buildCourseAnalyticsSection(context, state.courseAnalytics),
            const SizedBox(height: 20),
            _buildEngagementTrendsSection(context, state.engagementTrends),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(
    BuildContext context,
    InstructorDashboardData? data,
  ) {
    if (data == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Overview',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              context,
              'Total Courses',
              data.totalCourses.toString(),
              Icons.school,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'Total Students',
              data.totalStudents.toString(),
              Icons.group,
              Colors.green,
            ),
            _buildStatCard(
              context,
              'Active This Month',
              data.activeStudentsThisMonth.toString(),
              Icons.trending_up,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'Satisfaction',
              '${data.studentSatisfactionScore.toStringAsFixed(1)}/5',
              Icons.star,
              Colors.amber,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.attach_money, size: 40, color: Colors.green[600]),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue This Month',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '\$${data.revenueThisMonth.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseAnalyticsSection(
    BuildContext context,
    List<CourseAnalytics> courses,
  ) {
    if (courses.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Analytics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final course = courses[index];
                return _buildCourseCard(context, course);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseAnalytics course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.courseTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    '${course.averageProgress.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getProgressColor(
                    course.averageProgress,
                  ).withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: _getProgressColor(course.averageProgress),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Students',
                    course.totalStudents.toString(),
                    Icons.group,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Active',
                    course.activeStudents.toString(),
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Completed',
                    course.completedStudents.toString(),
                    Icons.check_circle,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Engagement',
                    '${course.engagementScore.toStringAsFixed(1)}/10',
                    Icons.favorite,
                    Colors.pink,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Retention',
                    '${course.retentionRate.toStringAsFixed(0)}%',
                    Icons.person_pin,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCourseMetric(
                    context,
                    'Avg Days',
                    course.averageCompletionTimeDays?.toStringAsFixed(0) ??
                        'N/A',
                    Icons.schedule,
                    Colors.indigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementTrendsSection(
    BuildContext context,
    List<EngagementTrend> trends,
  ) {
    if (trends.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Engagement Trends (Last 7 Days)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trends.length,
                itemBuilder: (context, index) {
                  final trend = trends[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.bottomCenter,
                              heightFactor: (trend.activeUsers / 80).clamp(
                                0.1,
                                1.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trend.activeUsers.toString(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatTrendDate(trend.date),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEngagementStat(
                  context,
                  'Avg Session',
                  '${trends.isNotEmpty ? trends.last.sessionDurationAvg.toStringAsFixed(1) : '0'}min',
                  Icons.timer,
                  Colors.orange,
                ),
                _buildEngagementStat(
                  context,
                  'Content Views',
                  trends.isNotEmpty ? trends.last.contentViews.toString() : '0',
                  Icons.visibility,
                  Colors.green,
                ),
                _buildEngagementStat(
                  context,
                  'Quiz Completions',
                  trends.isNotEmpty
                      ? trends.last.quizCompletions.toString()
                      : '0',
                  Icons.quiz,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementStat(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 80) return Colors.green;
    if (progress >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatTrendDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}
