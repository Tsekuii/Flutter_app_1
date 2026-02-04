// ============================================
// File: lib/features/skills/presentation/pages/skill_mastery_page.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/skill.dart';
import '../../providers/skill_mastery_provider.dart';

class SkillMasteryPage extends StatelessWidget {
  const SkillMasteryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SkillMasteryProvider>();
    final skills = provider.skills;

    // Group skills by subject
    final Map<String, List<Skill>> skillsBySubject = {};
    for (var skill in skills) {
      if (!skillsBySubject.containsKey(skill.subject)) {
        skillsBySubject[skill.subject] = [];
      }
      skillsBySubject[skill.subject]!.add(skill);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _buildStatusCard(
              provider.masteredCount,
              'Skills Mastered',
              AppTheme.successGreen,
              Icons.check_circle,
            ),
            const SizedBox(width: 12),
            _buildStatusCard(
              provider.understoodCount,
              'Skills Understood',
              AppTheme.blueInfo,
              Icons.info,
            ),
            const SizedBox(width: 12),
            _buildStatusCard(
              provider.needsWorkCount,
              'Need More Work',
              AppTheme.warningOrange,
              Icons.error,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...skillsBySubject.entries.map((entry) {
          final subject = entry.key;
          final subjectSkills = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getSubjectColor(subject).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 13,
                            color: _getSubjectColor(subject),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${subjectSkills.length} skills',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              ...subjectSkills.map((skill) => _SkillCard(skill: skill)),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatusCard(int count, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathematics':
        return AppTheme.primaryPurple;
      case 'Chemistry':
        return AppTheme.successGreen;
      case 'Physics':
        return AppTheme.errorRed;
      case 'Biology':
        return AppTheme.blueInfo;
      default:
        return Colors.grey;
    }
  }
}

class _SkillCard extends StatelessWidget {
  final Skill skill;

  const _SkillCard({required this.skill});

  Color _getStatusColor() {
    switch (skill.status) {
      case SkillStatus.mastered:
        return AppTheme.successGreen;
      case SkillStatus.understood:
        return AppTheme.blueInfo;
      case SkillStatus.needsWork:
        return AppTheme.warningOrange;
    }
  }

  String _getStatusLabel() {
    switch (skill.status) {
      case SkillStatus.mastered:
        return 'Mastered';
      case SkillStatus.understood:
        return 'Understood';
      case SkillStatus.needsWork:
        return 'Needs Work';
    }
  }

  IconData _getStatusIcon() {
    switch (skill.status) {
      case SkillStatus.mastered:
        return Icons.check_circle;
      case SkillStatus.understood:
        return Icons.info;
      case SkillStatus.needsWork:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Last practiced ${dateFormat.format(skill.lastPracticed)}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusLabel(),
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(),
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
