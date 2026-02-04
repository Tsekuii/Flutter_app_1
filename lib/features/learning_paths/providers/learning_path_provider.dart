// ============================================
// File: lib/features/learning_paths/providers/learning_path_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../../../core/models/learning_path.dart';

class LearningPathProvider with ChangeNotifier {
  List<LearningPath> _paths = [];
  LearningPath? _currentPath;
  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];
  int _correctAnswers = 0;

  List<LearningPath> get paths => _paths;
  LearningPath? get currentPath => _currentPath;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _currentPath?.questions.length ?? 0;
  int get correctAnswers => _correctAnswers;

  LearningPathProvider() {
    _initializePaths();
  }

  void _initializePaths() {
    _paths = [
      LearningPath(
        id: '1',
        title: 'Speed & Time Mastery',
        subject: 'Mathematics',
        difficulty: 'medium',
        goal: 'Understand speed-time problems',
        weakSkill: 'Time calculation',
        nextTask: 'Reach school before 9:00 AM',
        progressPoints: 250,
        duration: 3,
        difficultyLevel: 10,
        questions: _generateSpeedTimeQuestions(),
      ),
      LearningPath(
        id: '2',
        title: 'Chemical Formulas Fundamentals',
        subject: 'Chemistry',
        difficulty: 'easy',
        goal: 'Write correct chemical formulas',
        weakSkill: 'Molecular composition',
        nextTask: 'Identify compounds in daily life',
        progressPoints: 150,
        duration: 2,
        difficultyLevel: 8,
        questions: _generateChemistryQuestions(),
      ),
      LearningPath(
        id: '3',
        title: 'Newton\'s Laws Application',
        subject: 'Physics',
        difficulty: 'hard',
        goal: 'Apply Newton\'s laws to motion',
        weakSkill: 'Force and acceleration relationship',
        nextTask: 'Calculate force needed to push a cart',
        progressPoints: 350,
        duration: 4,
        difficultyLevel: 15,
        isLocked: true,
        questions: _generatePhysicsQuestions(),
      ),
      LearningPath(
        id: '4',
        title: 'Ancient Civilizations Timeline',
        subject: 'History',
        difficulty: 'medium',
        goal: 'Understand ancient civilization chronology',
        weakSkill: 'Historical timeline ordering',
        nextTask: 'Place Egypt, Greece, and Rome on timeline',
        progressPoints: 200,
        duration: 2,
        difficultyLevel: 11,
        questions: _generateHistoryQuestions(),
      ),
    ];
    notifyListeners();
  }

  List<Question> _generateSpeedTimeQuestions() {
    return [
      Question(
        id: 'st1',
        text:
            'You leave home at 8:30 AM. School is 5 km away and you walk at 5 km/h. Will you reach school before 9:00 AM?',
        options: [
          'Yes, at 8:50 AM',
          'No, at 9:10 AM',
          'Yes, at 9:00 AM exactly',
          'Yes, at 8:45 AM',
        ],
        correctAnswerIndex: 0,
        explanation:
            'Time = Distance/Speed = 5km/5km/h = 1 hour. Starting at 8:30, you would arrive at 9:30 AM, which is after 9:00.',
      ),
      Question(
        id: 'st2',
        text: 'If a car travels 120 km in 2 hours, what is its average speed?',
        options: ['50 km/h', '60 km/h', '70 km/h', '80 km/h'],
        correctAnswerIndex: 1,
        explanation: 'Speed = Distance/Time = 120km/2h = 60 km/h',
      ),
      Question(
        id: 'st3',
        text: 'A train covers 120 km in 2 hours. What is its average speed?',
        options: ['50 km/h', '60 km/h', '70 km/h', '80 km/h'],
        correctAnswerIndex: 1,
        explanation: 'Speed = Distance/Time = 120km/2h = 60 km/h',
      ),
    ];
  }

  List<Question> _generateChemistryQuestions() {
    return [
      Question(
        id: 'ch1',
        text: 'What is the chemical formula for water?',
        options: ['H2O', 'CO2', 'O2', 'H2O2'],
        correctAnswerIndex: 0,
        explanation:
            'Water consists of 2 hydrogen atoms and 1 oxygen atom: H2O',
      ),
      Question(
        id: 'ch2',
        text: 'What is the chemical formula for carbon dioxide?',
        options: ['CO', 'CO2', 'C2O', 'O2C'],
        correctAnswerIndex: 1,
        explanation: 'Carbon dioxide has 1 carbon and 2 oxygen atoms: CO2',
      ),
    ];
  }

  List<Question> _generatePhysicsQuestions() {
    return [
      Question(
        id: 'ph1',
        text:
            'According to Newton\'s Second Law, F = ma. If mass doubles and acceleration stays the same, what happens to force?',
        options: ['Halves', 'Doubles', 'Stays same', 'Quadruples'],
        correctAnswerIndex: 1,
        explanation:
            'If mass doubles and acceleration is constant, force must double (F = 2m × a = 2F)',
      ),
    ];
  }

  List<Question> _generateHistoryQuestions() {
    return [
      Question(
        id: 'hi1',
        text: 'Which civilization built the pyramids?',
        options: ['Greek', 'Roman', 'Egyptian', 'Persian'],
        correctAnswerIndex: 2,
        explanation: 'The ancient Egyptians built the pyramids around 2600 BC',
      ),
    ];
  }

  void startPath(LearningPath path) {
    if (path.isLocked) return;
    _currentPath = path;
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
    _correctAnswers = 0;
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    if (_currentPath == null) return;

    final isCorrect =
        _currentPath!.questions[_currentQuestionIndex].correctAnswerIndex ==
            answerIndex;

    if (isCorrect) {
      _correctAnswers++;
    }

    _selectedAnswers.add(answerIndex);
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < totalQuestions - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void completePath() {
    if (_currentPath == null) return;

    final pathIndex = _paths.indexWhere((p) => p.id == _currentPath!.id);
    if (pathIndex != -1) {
      _paths[pathIndex] = LearningPath(
        id: _currentPath!.id,
        title: _currentPath!.title,
        subject: _currentPath!.subject,
        difficulty: _currentPath!.difficulty,
        goal: _currentPath!.goal,
        weakSkill: _currentPath!.weakSkill,
        nextTask: _currentPath!.nextTask,
        progressPoints: _currentPath!.progressPoints,
        duration: _currentPath!.duration,
        difficultyLevel: _currentPath!.difficultyLevel,
        isLocked: false,
        isCompleted: true,
        questions: _currentPath!.questions,
      );
    }

    _currentPath = null;
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
    notifyListeners();
  }

  void exitPath() {
    _currentPath = null;
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
    _correctAnswers = 0;
    notifyListeners();
  }

  bool hasAnswered() {
    return _selectedAnswers.length > _currentQuestionIndex;
  }

  int? getSelectedAnswer() {
    if (_selectedAnswers.length > _currentQuestionIndex) {
      return _selectedAnswers[_currentQuestionIndex];
    }
    return null;
  }
}
