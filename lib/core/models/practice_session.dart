// ============================================
// File: lib/core/models/practice_session.dart
// ============================================
import 'package:questlearn/core/models/learning_path.dart';

class PracticeSession {
  final String id;
  final String subject;
  final String recentMistake;
  final String practiceTask;
  final int progressPoints;
  final int totalQuestions;
  final int completedQuestions;
  final bool isCompleted;
  final List<Question> questions;

  PracticeSession({
    required this.id,
    required this.subject,
    required this.recentMistake,
    required this.practiceTask,
    required this.progressPoints,
    required this.totalQuestions,
    required this.completedQuestions,
    this.isCompleted = false,
    required this.questions,
  });
}
