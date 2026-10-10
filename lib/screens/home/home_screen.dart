import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cheicking_provider.dart';
import '../../providers/coaching_profile.dart';
import '../../providers/daily_action_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/weigtn_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/action_card.dart';

import '../../widgets/habit_card.dart';

import '../../widgets/primary_button.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/tip_card.dart';
import '../checkin/checkin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    final weightProvider = context.watch<WeightProvider>();

    final habitProvider = context.watch<HabitProvider>();

    final coachingProfileProvider = context.watch<CoachingProfileProvider>();

    final goalProvider = context.watch<GoalProvider>();

    final actionProvider = context.watch<DailyActionProvider>();

    final checkInProvider = context.watch<CheckInProvider>();

    final firstName = user?.firstName.trim().isNotEmpty == true
        ? user!.firstName.trim()
        : 'Vous';

    final profile = coachingProfileProvider.profile;
    final currentWeight =
        weightProvider.currentWeight ??
        (profile != null && profile.currentWeight > 0
            ? profile.currentWeight
            : null);
    final targetWeight =
        goalProvider.targetWeight ??
        (profile != null && profile.targetWeight > 0
            ? profile.targetWeight
            : coachingProfileProvider.targetWeight);
    final action = actionProvider.currentAction;
    final latestCheckIn = _latestCheckIn(checkInProvider.checkIns);
    final energy = _asInt(latestCheckIn?['energy']);
    final latestNote =
        (latestCheckIn?['note'] ?? latestCheckIn?['reason'] ?? '')
            .toString()
            .trim();

    final today = DateTime.now();
    final firstDayOfWeek = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));
    final activeHabitDays = habitProvider.completedHabits
        .map(
          (habit) =>
              DateTime(habit.date.year, habit.date.month, habit.date.day),
        )
        .where((date) => !date.isBefore(firstDayOfWeek))
        .toSet()
        .length;

    final tipTitle = latestNote.isNotEmpty
        ? 'Votre dernier check-in'
        : 'Votre repère du jour';
    final tipMessage = latestNote.isNotEmpty
        ? latestNote
        : action != null
        ? 'Votre action : ${action.title}. Chaque petit pas compte.'
        : targetWeight != null
        ? 'Votre objectif est de ${targetWeight.toStringAsFixed(1)} kg. Avançons à votre rythme.'
        : 'Choisissez une petite action réalisable aujourd’hui. La régularité compte plus que la perfection.';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour $firstName',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user == null
                              ? 'Bienvenue dans votre espace personnel.'
                              : 'Heureux de vous revoir !',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              CoachTipCard(title: tipTitle, message: tipMessage),

              const SizedBox(height: 22),

              const Text(
                'Votre prochaine petite action',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 10),

              ActionCard(
                title: action?.title ?? 'Aucune action proposée',
                subtitle:
                    action?.trigger ?? 'Votre prochaine action apparaîtra ici.',
                icon: Icons.directions_walk_outlined,
                progress: activeHabitDays / 7,
                progressLabel:
                    '$activeHabitDays jour(s) actif(s) sur les 7 derniers jours',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckInScreen()),
                  );
                },
              ),

              const SizedBox(height: 18),

              PrimaryButton(
                text: 'Faire mon check-in',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckInScreen()),
                  );
                },
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  StatCard(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Poids actuel',
                    value: currentWeight == null
                        ? '-- kg'
                        : '${currentWeight.toStringAsFixed(1)} kg',
                  ),

                  const SizedBox(width: 8),

                  StatCard(
                    icon: Icons.track_changes,
                    label: 'Objectif',
                    value: targetWeight == null
                        ? '-- kg'
                        : '${targetWeight.toStringAsFixed(1)} kg',
                  ),

                  const SizedBox(width: 8),

                  StatCard(
                    icon: Icons.bolt_outlined,
                    label: 'Énergie',
                    value: energy == null ? '--/10' : '$energy/10',
                  ),
                ],
              ),

              const SizedBox(height: 22),

              HabitStreakCard(streak: habitProvider.currentStreak),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? _latestCheckIn(List<dynamic> checkIns) {
    final entries = checkIns.whereType<Map<String, dynamic>>().toList();
    if (entries.isEmpty) return null;

    DateTime dateFor(Map<String, dynamic> entry) {
      final value = entry['date'] ?? entry['createdAt'] ?? entry['created_at'];
      return DateTime.tryParse(value?.toString() ?? '') ?? DateTime(1970);
    }

    entries.sort((a, b) => dateFor(b).compareTo(dateFor(a)));
    return entries.first;
  }

  int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '');
  }
}
