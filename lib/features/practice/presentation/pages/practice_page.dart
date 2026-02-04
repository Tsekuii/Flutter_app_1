// ============================================
// File: lib/features/practice/presentation/pages/practice_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/practice_provider.dart';
import 'practice_session_page.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PracticeProvider>();
    final sessions = provider.sessions;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Practice & Diagnosis',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${sessions.where((s) => !s.isCompleted).length} active',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 20),
        ...sessions.map((session) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PracticeCard(session: session),
            )),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final dynamic session;

  const _PracticeCard({required this.session});

  String _getStatusLabel() {
    if (session.isCompleted) return 'Completed';
    return 'In Progress';
  }

  Color _getStatusColor() {
    if (session.isCompleted) return AppTheme.successGreen;
    return AppTheme.blueInfo;
  }

  @override
  Widget build(BuildContext context) {
    final progress = session.completedQuestions / session.totalQuestions;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.subject,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  size: 18,
                  color: AppTheme.warningOrange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recent Mistake: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(session.recentMistake,
                style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.task_alt,
                  size: 18,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Practice Task: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(session.practiceTask,
                style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${session.completedQuestions}/${session.totalQuestions} completed',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStatusColor(),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.star_border, size: 16),
                    const SizedBox(width: 4),
                    Text('${session.progressPoints} Progress',
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: session.isCompleted
                    ? null
                    : () {
                        context.read<PracticeProvider>().startSession(session);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PracticeSessionPage(),
                          ),
                        );
                      },
                child: Text(session.isCompleted ? 'Completed' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
