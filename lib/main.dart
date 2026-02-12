import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/learning_paths/providers/learning_path_provider.dart';
import 'features/practice/providers/practice_provider.dart';
import 'features/progress/providers/progress_provider.dart';
import 'features/skills/providers/skill_mastery_provider.dart';

// Toggle this during development to force a logical screen size (no effect in release)
const bool kForceTestSize = true;
const Size kPhoneTestSize = Size(390, 844); // iPhone-ish

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kForceTestSize && !kReleaseMode) {
    runApp(ForcedSizeWrapper(size: kPhoneTestSize, child: const QuestLearnApp()));
  } else {
    runApp(const QuestLearnApp());
  }
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
        useInheritedMediaQuery: true, // allow ancestor MediaQuery (our ForcedSizeWrapper) to take effect
        home: const DashboardPage(),
      ),
    );
  }
}

class ForcedSizeWrapper extends StatelessWidget {
  final Size size;
  final Widget child;

  const ForcedSizeWrapper({required this.size, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use fromWindow (non-deprecated) to seed current values, then override size
    final base = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final forced = base.copyWith(
      size: size,
      // Optionally change other fields here, for example:
      // devicePixelRatio: 2.0,
      // textScaleFactor: 1.0,
    );

    return MediaQuery(data: forced, child: child);
  }
}