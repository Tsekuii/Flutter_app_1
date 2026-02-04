// ============================================
// File: lib/features/learning_paths/presentation/pages/path_quiz_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/learning_path_provider.dart';
import 'dart:async';

class PathQuizPage extends StatefulWidget {
  const PathQuizPage({Key? key}) : super(key: key);

  @override
  State<PathQuizPage> createState() => _PathQuizPageState();
}

class _PathQuizPageState extends State<PathQuizPage> {
  Timer? _timer;
  int _secondsRemaining = 180; // 3 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LearningPathProvider>();
    final path = provider.currentPath;

    if (path == null) {
      return const Scaffold(body: Center(child: Text('No path selected')));
    }

    final currentQuestion = path.questions[provider.currentQuestionIndex];
    final hasAnswered = provider.hasAnswered();
    final selectedAnswer = provider.getSelectedAnswer();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            provider.exitPath();
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(path.title, overflow: TextOverflow.ellipsis),
            Text(
              'AI-powered personalized learning path',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.lightPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(_formatTime(),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.flag, 'Current Learning Goal:', path.goal,
                    AppTheme.blueInfo),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.warning_amber, 'Detected Weak Skill:',
                    path.weakSkill, AppTheme.warningOrange),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.task_alt, 'Recommended Task:',
                    path.nextTask, AppTheme.successGreen),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${provider.currentQuestionIndex + 1} of ${provider.totalQuestions}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${provider.correctAnswers} correct',
                      style: const TextStyle(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (provider.currentQuestionIndex + 1) /
                        provider.totalQuestions,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryPurple,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(currentQuestion.options.length, (index) {
                    final isSelected = selectedAnswer == index;
                    final isCorrect =
                        index == currentQuestion.correctAnswerIndex;
                    final showFeedback = hasAnswered;

                    Color borderColor = Colors.grey[300]!;
                    Color bgColor = Colors.white;
                    IconData? icon;
                    Color? iconColor;

                    if (showFeedback) {
                      if (isSelected) {
                        if (isCorrect) {
                          borderColor = AppTheme.successGreen;
                          bgColor = AppTheme.successGreen.withOpacity(0.1);
                          icon = Icons.check_circle;
                          iconColor = AppTheme.successGreen;
                        } else {
                          borderColor = AppTheme.errorRed;
                          bgColor = AppTheme.errorRed.withOpacity(0.1);
                          icon = Icons.cancel;
                          iconColor = AppTheme.errorRed;
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: hasAnswered
                            ? null
                            : () => provider.selectAnswer(index),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentQuestion.options[index],
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              if (icon != null)
                                Icon(icon, color: iconColor, size: 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (hasAnswered) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blueInfo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.blueInfo.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lightbulb, color: AppTheme.blueInfo),
                              SizedBox(width: 8),
                              Text(
                                'Explanation:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQuestion.explanation,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (hasAnswered &&
                    provider.currentQuestionIndex < provider.totalQuestions - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => provider.nextQuestion(),
                      child: const Text('Next Question'),
                    ),
                  ),
                if (hasAnswered &&
                    provider.currentQuestionIndex ==
                        provider.totalQuestions - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCompletionDialog(context, provider);
                      },
                      child: const Text('Complete Path'),
                    ),
                  ),
                if (!hasAnswered)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      child: const Text('Select an answer'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _showCompletionDialog(
      BuildContext context, LearningPathProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withOpacity(0.8),
                      AppTheme.primaryPurple,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Learning Path Complete!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You answered ${provider.correctAnswers} out of ${provider.totalQuestions} questions correctly',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.star_border, color: AppTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    '+${provider.currentPath?.progressPoints ?? 0} Progress',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.completePath();
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close quiz page
                  },
                  child: const Text('Claim Rewards'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
