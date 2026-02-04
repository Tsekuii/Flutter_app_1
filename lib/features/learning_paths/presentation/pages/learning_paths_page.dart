// ============================================
// File: lib/features/learning_paths/presentation/pages/learning_paths_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/learning_path_provider.dart';
import 'path_quiz_page.dart';

class LearningPathsPage extends StatelessWidget {
  const LearningPathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LearningPathProvider>();
    final paths = provider.paths;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Available Learning Paths',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('5 paths available', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        ...paths.map((path) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PathCard(path: path),
            )),
      ],
    );
  }
}

class _PathCard extends StatelessWidget {
  final dynamic path;

  const _PathCard({required this.path});

  Color _getDifficultyColor() {
    switch (path.difficulty) {
      case 'easy':
        return AppTheme.successGreen;
      case 'medium':
        return AppTheme.warningOrange;
      case 'hard':
        return AppTheme.errorRed;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            path.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  path.subject,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  path.difficulty,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getDifficultyColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.tablet, 'Your Goal:', path.goal),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.warning_amber,
                  'Weak Skill:',
                  path.weakSkill,
                  color: AppTheme.warningOrange,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.task_alt,
                  'Next Task:',
                  path.nextTask,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${path.progressPoints} Progress',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${path.duration}m',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Difficulty ${path.difficultyLevel}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: path.isLocked
                          ? null
                          : () {
                              context
                                  .read<LearningPathProvider>()
                                  .startPath(path);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PathQuizPage(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: path.isLocked
                            ? Colors.grey[300]
                            : AppTheme.primaryPurple,
                      ),
                      child: Text(path.isLocked ? 'Locked' : 'Start Path'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (path.isLocked)
            Positioned(
              top: 12,
              right: 12,
              child: Icon(Icons.lock, color: Colors.grey[400]),
            ),
          if (path.isCompleted)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.emoji_events, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color ?? AppTheme.blueInfo),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
