// ============================================
// File: lib/features/practice/providers/practice_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../../../core/models/practice_session.dart';
import '../../../core/models/learning_path.dart';

class PracticeProvider with ChangeNotifier {
  List<PracticeSession> _sessions = [];
  PracticeSession? _currentSession;
  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];

  List<PracticeSession> get sessions => _sessions;
  PracticeSession? get currentSession => _currentSession;
  int get currentQuestionIndex => _currentQuestionIndex;

  PracticeProvider() {
    _initializeSessions();
  }

  void _initializeSessions() {
    _sessions = [
      PracticeSession(
        id: 'p1',
        subject: 'Mathematics',
        recentMistake: 'Wrong unit conversion (m/s → km/h)',
        practiceTask: 'Convert 3 problems correctly',
        progressPoints: 200,
        totalQuestions: 5,
        completedQuestions: 1,
        questions: _generateUnitConversionQuestions(),
      ),
      PracticeSession(
        id: 'p2',
        subject: 'Chemistry',
        recentMistake: 'Incorrect chemical bond identification',
        practiceTask: 'Identify 5 ionic and covalent bonds',
        progressPoints: 150,
        totalQuestions: 5,
        completedQuestions: 0,
        questions: _generateChemistryPracticeQuestions(),
      ),
      PracticeSession(
        id: 'p3',
        subject: 'Physics',
        recentMistake: 'Force direction confused with acceleration',
        practiceTask: 'Solve 4 vector problems with correct directions',
        progressPoints: 250,
        totalQuestions: 5,
        completedQuestions: 2,
        questions: _generatePhysicsPracticeQuestions(),
      ),
    ];
    notifyListeners();
  }

  List<Question> _generateUnitConversionQuestions() {
    return [
      Question(
        id: 'uc1',
        text: 'Convert 20 m/s to km/h',
        options: ['72 km/h', '20 km/h', '36 km/h', '50 km/h'],
        correctAnswerIndex: 0,
        explanation: 'Multiply by 3.6: 20 × 3.6 = 72 km/h',
      ),
      Question(
        id: 'uc2',
        text: 'Convert 90 km/h to m/s',
        options: ['15 m/s', '25 m/s', '30 m/s', '90 m/s'],
        correctAnswerIndex: 1,
        explanation: 'Divide by 3.6: 90 ÷ 3.6 = 25 m/s',
      ),
      Question(
        id: 'uc3',
        text: 'Convert 15 m/s to km/h',
        options: ['45 km/h', '54 km/h', '60 km/h', '15 km/h'],
        correctAnswerIndex: 1,
        explanation: 'Multiply by 3.6: 15 × 3.6 = 54 km/h',
      ),
      Question(
        id: 'uc4',
        text: 'Convert 108 km/h to m/s',
        options: ['25 m/s', '30 m/s', '35 m/s', '40 m/s'],
        correctAnswerIndex: 1,
        explanation: 'Divide by 3.6: 108 ÷ 3.6 = 30 m/s',
      ),
      Question(
        id: 'uc5',
        text: 'A car travels at 25 m/s. How fast is this in km/h?',
        options: ['75 km/h', '80 km/h', '90 km/h', '100 km/h'],
        correctAnswerIndex: 2,
        explanation: 'Multiply by 3.6: 25 × 3.6 = 90 km/h',
      ),
    ];
  }

  List<Question> _generateChemistryPracticeQuestions() {
    return [
      Question(
        id: 'cp1',
        text: 'Which type of bond is in NaCl (table salt)?',
        options: ['Ionic', 'Covalent', 'Metallic', 'Hydrogen'],
        correctAnswerIndex: 0,
        explanation: 'NaCl forms an ionic bond between Na+ and Cl- ions',
      ),
    ];
  }

  List<Question> _generatePhysicsPracticeQuestions() {
    return [
      Question(
        id: 'pp1',
        text:
            'A 10N force acts eastward on an object. What is the direction of acceleration?',
        options: ['East', 'West', 'North', 'South'],
        correctAnswerIndex: 0,
        explanation: 'Acceleration is always in the direction of the net force',
      ),
    ];
  }

  void startSession(PracticeSession session) {
    _currentSession = session;
    _currentQuestionIndex = session.completedQuestions;
    _selectedAnswers = [];
    notifyListeners();
  }

  void selectAnswer(int answerIndex) {
    _selectedAnswers.add(answerIndex);
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentSession != null &&
        _currentQuestionIndex < _currentSession!.totalQuestions - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void completeSession() {
    if (_currentSession == null) return;

    final sessionIndex =
        _sessions.indexWhere((s) => s.id == _currentSession!.id);
    if (sessionIndex != -1) {
      _sessions[sessionIndex] = PracticeSession(
        id: _currentSession!.id,
        subject: _currentSession!.subject,
        recentMistake: _currentSession!.recentMistake,
        practiceTask: _currentSession!.practiceTask,
        progressPoints: _currentSession!.progressPoints,
        totalQuestions: _currentSession!.totalQuestions,
        completedQuestions: _currentSession!.totalQuestions,
        isCompleted: true,
        questions: _currentSession!.questions,
      );
    }

    _currentSession = null;
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
    notifyListeners();
  }

  void exitSession() {
    _currentSession = null;
    _currentQuestionIndex = 0;
    _selectedAnswers = [];
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
