import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/learning_paths/providers/learning_path_provider.dart';
import 'features/practice/providers/practice_provider.dart';
import 'features/progress/providers/progress_provider.dart';
import 'features/skills/providers/skill_mastery_provider.dart';

void main() {
  runApp(const QuestLearnApp());
}

class QuestLearnApp extends StatelessWidget {
  const QuestLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LearningPathProvider()),
        ChangeNotifierProvider(create: (_) => PracticeProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => SkillMasteryProvider()),
      ],
      child: MaterialApp(
        title: 'QuestLearn',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const DashboardPage(),
      ),
    );
  }
}
