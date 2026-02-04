// ============================================
// File: lib/features/dashboard/presentation/pages/dashboard_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../learning_paths/presentation/pages/learning_paths_page.dart';
import '../../../practice/presentation/pages/practice_page.dart';
import '../../../progress/presentation/pages/progress_page.dart';
import '../../../skills/presentation/pages/skill_mastery_page.dart';
import '../../../progress/providers/progress_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LearningPathsPage(),
    const PracticePage(),
    const ProgressPage(),
    const SkillMasteryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>().progressData;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('QuestLearn', style: TextStyle(fontSize: 18)),
                Text('Level Up Your Knowledge',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.lightPurple,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppTheme.primaryPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up,
                          size: 16, color: AppTheme.primaryPurple),
                      const SizedBox(width: 4),
                      Text(
                        'Difficulty ${progress.currentDifficulty}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Stack(
                  children: [
                    Container(
                      width: 180,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress.totalProgress / 3000,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryPurple),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          'Progress ${progress.totalProgress} / 3000',
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 16, color: AppTheme.errorRed),
                      const SizedBox(width: 4),
                      const Text('Mastery #5',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Alex Champion',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatCard(
                  'Total Progress',
                  '${progress.totalProgress}',
                  Icons.bolt,
                  AppTheme.primaryPurple,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Current Difficulty',
                  '${progress.currentDifficulty}',
                  Icons.trending_up,
                  AppTheme.blueInfo,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Learning Paths Completed',
                  '${progress.pathsCompleted}/${progress.totalPaths}',
                  Icons.check_circle,
                  AppTheme.successGreen,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Success Rate',
                  '71%',
                  Icons.auto_graph,
                  AppTheme.errorRed,
                ),
              ],
            ),
          ),
          // Navigation Tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildNavTab('Learning Paths', Icons.school, 0),
                _buildNavTab('Practice & Diagnosis', Icons.fitness_center, 1),
                _buildNavTab('Progress Overview', Icons.show_chart, 2),
                _buildNavTab('Skill Mastery', Icons.emoji_events, 3),
              ],
            ),
          ),
          // Page Content
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(String label, IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppTheme.primaryPurple : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryPurple : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
