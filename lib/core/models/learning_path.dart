class LearningPath {
  final String id;
  final String title;
  final String subject;
  final String difficulty;
  final String goal;
  final String weakSkill;
  final String nextTask;
  final int progressPoints;
  final int duration;
  final int difficultyLevel;
  final bool isLocked;
  final bool isCompleted;
  final List<Question> questions;

  LearningPath({
    required this.id,
    required this.title,
    required this.subject,
    required this.difficulty,
    required this.goal,
    required this.weakSkill,
    required this.nextTask,
    required this.progressPoints,
    required this.duration,
    required this.difficultyLevel,
    this.isLocked = false,
    this.isCompleted = false,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}
