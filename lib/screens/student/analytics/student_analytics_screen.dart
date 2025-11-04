import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/analytics_provider_mock.dart';
import '../../../core/models/analytics.dart';

class StudentAnalyticsScreen extends ConsumerWidget {
  const StudentAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock student ID for demo
    const studentId = 'student_1';

    final analyticsState = ref.watch(studentAnalyticsProvider(studentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(studentAnalyticsProvider(studentId).notifier)
                  .refreshDashboard(studentId);
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
                        .read(studentAnalyticsProvider(studentId).notifier)
                        .refreshDashboard(studentId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _buildDashboardContent(context, analyticsState, ref),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    StudentDashboardState state,
    WidgetRef ref,
  ) {
    const studentId = 'student_1';
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(studentAnalyticsProvider(studentId).notifier)
            .refreshDashboard(studentId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(context, state.dashboardData),
            const SizedBox(height: 20),
            _buildProgressSection(context, state.studentProgress),
            const SizedBox(height: 20),
            _buildQuizPerformanceSection(context, state.quizPerformance),
            const SizedBox(height: 20),
            _buildLearningPatternSection(context, state.learningPattern),
            const SizedBox(height: 20),
            _buildRecentActivitiesSection(context, state.recentActivities),
            const SizedBox(height: 20),
            _buildUpcomingDeadlinesSection(context, state.upcomingDeadlines),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, StudentDashboardData? data) {
    if (data == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
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
              'Enrolled Courses',
              data.enrolledCourses.toString(),
              Icons.school,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'Completed Courses',
              data.completedCourses.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              context,
              'Study Streak',
              '${data.studyStreakDays} days',
              Icons.local_fire_department,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'Study Time',
              '${data.totalStudyTimeHours.toStringAsFixed(1)}h',
              Icons.access_time,
              Colors.purple,
            ),
          ],
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

  Widget _buildProgressSection(
    BuildContext context,
    List<StudentProgress> progress,
  ) {
    if (progress.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Progress',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: progress.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = progress[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.courseId,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Text(
                          '${item.completionPercentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: item.isCompleted
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: item.completionPercentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        item.isCompleted ? Colors.green : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${item.lessonsCompleted}/${item.totalLessons} lessons',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        if (item.quizAverageScore != null)
                          Text(
                            'Quiz avg: ${item.quizAverageScore!.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizPerformanceSection(
    BuildContext context,
    QuizPerformance? performance,
  ) {
    if (performance == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Performance',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceMetric(
                    context,
                    'Average Score',
                    '${performance.averageScore.toStringAsFixed(1)}%',
                    Icons.analytics,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceMetric(
                    context,
                    'Highest Score',
                    '${performance.highestScore.toStringAsFixed(1)}%',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPerformanceMetric(
                    context,
                    'Total Quizzes',
                    performance.totalQuizzesTaken.toString(),
                    Icons.quiz,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPerformanceMetric(
                    context,
                    'Improvement',
                    '+${performance.improvementTrend.toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            if (performance.strongSubjects.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Strong Subjects',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: performance.strongSubjects.map((subject) {
                  return Chip(
                    label: Text(subject),
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(color: Colors.green),
                  );
                }).toList(),
              ),
            ],
            if (performance.areasForImprovement.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Areas for Improvement',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: performance.areasForImprovement.map((area) {
                  return Chip(
                    label: Text(area),
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(color: Colors.orange),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
      ),
    );
  }

  Widget _buildLearningPatternSection(
    BuildContext context,
    LearningPattern? pattern,
  ) {
    if (pattern == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Pattern',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPatternInfo(
                    context,
                    'Study Streak',
                    '${pattern.studyStreakDays} days',
                    Icons.local_fire_department,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPatternInfo(
                    context,
                    'Avg Session',
                    '${pattern.averageSessionDurationMinutes} min',
                    Icons.timer,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPatternInfo(
                    context,
                    'Completion Rate',
                    '${pattern.completionRate.toStringAsFixed(1)}%',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPatternInfo(
                    context,
                    'Learning Velocity',
                    '${pattern.learningVelocity.toStringAsFixed(1)}x',
                    Icons.speed,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            if (pattern.preferredContentType != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.favorite, color: Colors.blue),
                    const SizedBox(height: 4),
                    Text(
                      'Preferred Content',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      pattern.preferredContentType!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatternInfo(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
      ),
    );
  }

  Widget _buildRecentActivitiesSection(
    BuildContext context,
    List<ActivityRecord> activities,
  ) {
    if (activities.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: _getActivityColor(
                      activity.activityType,
                    ).withValues(alpha: 0.1),
                    child: Icon(
                      _getActivityIcon(activity.activityType),
                      color: _getActivityColor(activity.activityType),
                    ),
                  ),
                  title: Text(activity.description),
                  subtitle: Text(
                    '${activity.courseTitle} • ${_formatTimeAgo(activity.timestamp)}',
                  ),
                  trailing: activity.score != null
                      ? Chip(
                          label: Text('${activity.score!.toStringAsFixed(1)}%'),
                          backgroundColor: Colors.green.withValues(alpha: 0.1),
                        )
                      : activity.durationMinutes != null
                      ? Text('${activity.durationMinutes}min')
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingDeadlinesSection(
    BuildContext context,
    List<Deadline> deadlines,
  ) {
    if (deadlines.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Deadlines',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deadlines.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final deadline = deadlines[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: _getPriorityColor(
                      deadline.priority,
                    ).withValues(alpha: 0.1),
                    child: Icon(
                      _getDeadlineIcon(deadline.type),
                      color: _getPriorityColor(deadline.priority),
                    ),
                  ),
                  title: Text(deadline.title),
                  subtitle: Text(
                    '${deadline.courseTitle} • Due: ${_formatDate(deadline.dueDate)}',
                  ),
                  trailing: Chip(
                    label: Text(deadline.priority),
                    backgroundColor: _getPriorityColor(
                      deadline.priority,
                    ).withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: _getPriorityColor(deadline.priority),
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'lesson_completed':
        return Icons.check_circle;
      case 'quiz_completed':
        return Icons.quiz;
      case 'assignment_submitted':
        return Icons.assignment_turned_in;
      default:
        return Icons.event;
    }
  }

  Color _getActivityColor(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'lesson_completed':
        return Colors.green;
      case 'quiz_completed':
        return Colors.blue;
      case 'assignment_submitted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getDeadlineIcon(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz;
      case 'assignment':
        return Icons.assignment;
      case 'lesson':
        return Icons.play_lesson;
      default:
        return Icons.event;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays > 0) {
      return 'In ${difference.inDays} days';
    } else {
      return 'Overdue';
    }
  }
}
