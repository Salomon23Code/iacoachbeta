import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/life_challenge.dart';
import '../../providers/coaching_profile.dart';
import '../../providers/user_provider.dart';

import '../../providers/goal_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    final profile = context.watch<CoachingProfileProvider>().profile;

    final goal = context.watch<GoalProvider>().goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppTheme.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user?.firstName.isNotEmpty == true
                      ? user!.firstName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              user?.fullName ?? 'Utilisateur',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 13, color: AppTheme.textMedium),
            ),

            const SizedBox(height: 28),

            _ProfileSection(
              title: 'Informations personnelles',
              children: [
                _ProfileRow(
                  label: 'Âge',
                  value: profile != null ? '${profile.age} ans' : '-',
                ),
                _ProfileRow(
                  label: 'Taille',
                  value: profile != null
                      ? '${profile.height.toStringAsFixed(0)} cm'
                      : '-',
                ),
                _ProfileRow(
                  label: 'Poids actuel',
                  value: profile != null
                      ? '${profile.currentWeight.toStringAsFixed(1)} kg'
                      : '-',
                ),
                _ProfileRow(label: 'Pays', value: profile?.country ?? '-'),
              ],
            ),

            const SizedBox(height: 15),

            _ProfileSection(
              title: 'Mon accompagnement',
              children: [
                _ProfileRow(
                  label: 'Objectif',
                  value: goal != null
                      ? '${goal.targetWeight.toStringAsFixed(1)} kg'
                      : '-',
                ),
                _ProfileRow(
                  label: 'Motivation',
                  value: profile?.motivation ?? '-',
                ),
                _ProfileRow(
                  label: 'Façon de parler',
                  value: profile?.addressingLabel ?? '-',
                ),
              ],
            ),

            const SizedBox(height: 15),

            _ProfileSection(
              title: 'Mes défis',
              children: [
                if (profile != null &&
                    profile.challenges
                        .where((challenge) => challenge.selected)
                        .isNotEmpty)
                  ...profile.challenges
                      .where((challenge) => challenge.selected)
                      .map(
                        (challenge) => _ProfileRow(
                          label: challenge.label,
                          value: challenge.type == LifeChallengeType.other
                              ? challenge.description ?? ''
                              : '',
                        ),
                      )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Aucun défi sélectionné.',
                      style: TextStyle(color: AppTheme.textMedium),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 12),

          ...children,
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
