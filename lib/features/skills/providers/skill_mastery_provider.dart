// ============================================
// File: lib/features/skills/providers/skill_mastery_provider.dart
// ============================================
import 'package:flutter/foundation.dart';
import '../../../core/models/skill.dart';

class SkillMasteryProvider with ChangeNotifier {
  List<Skill> _skills = [];

  List<Skill> get skills => _skills;

  int get masteredCount =>
      _skills.where((s) => s.status == SkillStatus.mastered).length;
  int get understoodCount =>
      _skills.where((s) => s.status == SkillStatus.understood).length;
  int get needsWorkCount =>
      _skills.where((s) => s.status == SkillStatus.needsWork).length;

  SkillMasteryProvider() {
    _initializeSkills();
  }

  void _initializeSkills() {
    _skills = [
      // Mathematics
      Skill(
        id: 'm1',
        name: 'Time calculation',
        subject: 'Mathematics',
        status: SkillStatus.mastered,
        lastPracticed: DateTime(2026, 1, 2),
      ),
      Skill(
        id: 'm2',
        name: 'Linear equation basics',
        subject: 'Mathematics',
        status: SkillStatus.understood,
        lastPracticed: DateTime(2026, 1, 1),
      ),
      Skill(
        id: 'm3',
        name: 'Unit conversion',
        subject: 'Mathematics',
        status: SkillStatus.needsWork,
        lastPracticed: DateTime(2026, 1, 3),
      ),

      // Chemistry
      Skill(
        id: 'c1',
        name: 'Chemical bonding',
        subject: 'Chemistry',
        status: SkillStatus.understood,
        lastPracticed: DateTime(2025, 12, 30),
      ),
      Skill(
        id: 'c2',
        name: 'Periodic table navigation',
        subject: 'Chemistry',
        status: SkillStatus.mastered,
        lastPracticed: DateTime(2025, 12, 28),
      ),

      // Physics
      Skill(
        id: 'p1',
        name: 'Newton\'s laws application',
        subject: 'Physics',
        status: SkillStatus.needsWork,
        lastPracticed: DateTime(2026, 1, 3),
      ),
      Skill(
        id: 'p2',
        name: 'Velocity and acceleration',
        subject: 'Physics',
        status: SkillStatus.understood,
        lastPracticed: DateTime(2026, 1, 1),
      ),

      // Biology
      Skill(
        id: 'b1',
        name: 'Cell structure identification',
        subject: 'Biology',
        status: SkillStatus.mastered,
        lastPracticed: DateTime(2025, 12, 29),
      ),
      Skill(
        id: 'b2',
        name: 'Photosynthesis process',
        subject: 'Biology',
        status: SkillStatus.understood,
        lastPracticed: DateTime(2025, 12, 31),
      ),
    ];
    notifyListeners();
  }

  List<Skill> getSkillsBySubject(String subject) {
    return _skills.where((s) => s.subject == subject).toList();
  }
}
