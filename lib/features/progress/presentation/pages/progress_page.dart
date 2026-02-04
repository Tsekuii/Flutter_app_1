// ============================================
// File: lib/features/progress/presentation/pages/progress_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/progress_provider.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final data = provider.progressData;
    final history = provider.getRecentHistory();

    final progressChange = data.totalProgress - data.yesterdayProgress;
    final pathsChange = data.pathsCompleted - 30;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Progress Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Comparing today\'s progress with yesterday',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Progress',
                '${data.totalProgress}',
                'vs ${data.yesterdayProgress} yesterday',
                progressChange > 0 ? '+$progressChange' : '$progressChange',
                AppTheme.primaryPurple,
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Current Difficulty',
                '${data.currentDifficulty}',
                'vs ${data.currentDifficulty} yesterday',
                'No change',
                AppTheme.blueInfo,
                false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Paths Completed',
                '${data.pathsCompleted}',
                '+$pathsChange since yesterday',
                '+$pathsChange',
                AppTheme.successGreen,
                true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Time Spent',
                '${data.timeSpentHours} hours',
                'No additional time spent',
                '-35',
                AppTheme.errorRed,
                false,
                showNegative: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Row(
          children: [
            Icon(Icons.history, size: 20),
            SizedBox(width: 8),
            Text(
              'Recent History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...history.map((item) {
          final isToday = item['isToday'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday ? AppTheme.lightPurple : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isToday
                    ? AppTheme.primaryPurple.withOpacity(0.3)
                    : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['date'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    '${item['progress']} progress',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Difficulty ${item['difficulty']}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${item['paths']} paths',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    String change,
    Color color,
    bool showPositive, {
    bool showNegative = false,
  }) {
    IconData icon = Icons.remove;
    Color changeColor = Colors.grey;

    if (showPositive && change.startsWith('+')) {
      icon = Icons.trending_up;
      changeColor = AppTheme.successGreen;
    } else if (showNegative && change.startsWith('-')) {
      icon = Icons.trending_down;
      changeColor = AppTheme.errorRed;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title.contains('Progress')
                      ? Icons.bolt
                      : title.contains('Difficulty')
                          ? Icons.trending_up
                          : title.contains('Paths')
                              ? Icons.menu_book
                              : Icons.access_time,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                if (change != 'No change')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: changeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 12, color: changeColor),
                        const SizedBox(width: 2),
                        Text(
                          change,
                          style: TextStyle(
                            fontSize: 11,
                            color: changeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
