enum SkillStatus { mastered, understood, needsWork }

class Skill {
  final String id;
  final String name;
  final String subject;
  final SkillStatus status;
  final DateTime lastPracticed;

  Skill({
    required this.id,
    required this.name,
    required this.subject,
    required this.status,
    required this.lastPracticed,
  });
}
