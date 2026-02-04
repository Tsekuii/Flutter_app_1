// ============================================
// File: lib/features/progress/providers/progress_provider.dart
// ============================================
import 'package:flutter/foundation.dart';

class ProgressData {
  final int totalProgress;
  final int yesterdayProgress;
  final int currentDifficulty;
  final int pathsCompleted;
  final int totalPaths;
  final int timeSpentHours;

  ProgressData({
    required this.totalProgress,
    required this.yesterdayProgress,
    required this.currentDifficulty,
    required this.pathsCompleted,
    required this.totalPaths,
    required this.timeSpentHours,
  });
}

class ProgressProvider with ChangeNotifier {
  ProgressData _progressData = ProgressData(
    totalProgress: 2450,
    yesterdayProgress: 2200,
    currentDifficulty: 12,
    pathsCompleted: 32,
    totalPaths: 45,
    timeSpentHours: 85,
  );

  ProgressData get progressData => _progressData;

  List<Map<String, dynamic>> getRecentHistory() {
    return [
      {
        'date': '2026-01-03',
        'progress': 2450,
        'difficulty': 12,
        'paths': 32,
        'isToday': true
      },
      {
        'date': '2026-01-02',
        'progress': 2200,
        'difficulty': 12,
        'paths': 30,
        'isToday': false
      },
      {
        'date': '2026-01-01',
        'progress': 1950,
        'difficulty': 11,
        'paths': 28,
        'isToday': false
      },
      {
        'date': '2025-12-31',
        'progress': 1800,
        'difficulty': 11,
        'paths': 27,
        'isToday': false
      },
      {
        'date': '2025-12-30',
        'progress': 1650,
        'difficulty': 11,
        'paths': 25,
        'isToday': false
      },
    ];
  }
}
