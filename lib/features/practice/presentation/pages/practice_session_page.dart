// ============================================
// File: lib/features/practice/presentation/pages/practice_session_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/practice_provider.dart';

class PracticeSessionPage extends StatelessWidget {
  const PracticeSessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PracticeProvider>();
    final session = provider.currentSession;

    if (session == null) {
      return const Scaffold(body: Center(child: Text('No session selected')));
    }

    final currentQuestion = session.questions[provider.currentQuestionIndex];
    final hasAnswered = provider.hasAnswered();
    final selectedAnswer = provider.getSelectedAnswer();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            provider.exitSession();
            Navigator.pop(context);
          },
        ),
        title: Text('Practice: ${session.subject}'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${provider.currentQuestionIndex + 1} of ${session.totalQuestions}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (provider.currentQuestionIndex + 1) /
                        session.totalQuestions,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.warningOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.warningOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppTheme.warningOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Focus area: ${session.recentMistake}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    provider.currentQuestionIndex < session.totalQuestions - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => provider.nextQuestion(),
                      child: const Text('Next Question'),
                    ),
                  ),
                if (hasAnswered &&
                    provider.currentQuestionIndex == session.totalQuestions - 1)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.completeSession();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Practice session completed!'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      },
                      child: const Text('Complete Session'),
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
}
