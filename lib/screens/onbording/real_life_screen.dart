import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/life_challenge.dart';

import '../../providers/coaching_profile.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_indicator.dart';
import '../main/main_screen.dart';

class RealLifeScreen extends StatefulWidget {
  const RealLifeScreen({super.key});

  @override
  State<RealLifeScreen> createState() => _RealLifeScreenState();
}

class _RealLifeScreenState extends State<RealLifeScreen> {
  final TextEditingController _otherChallengeController =
      TextEditingController();

  @override
  void dispose() {
    _otherChallengeController.dispose();
    super.dispose();
  }

  // ==================================================
  // TERMINER L'ONBOARDING
  // ==================================================

  Future<void> _finish() async {
    final coachingProvider = context.read<CoachingProfileProvider>();

    final userProvider = context.read<UserProvider>();

    final user = userProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur introuvable.')));

      return;
    }

    // Enregistrer le texte "autre"
    coachingProvider.setOtherChallenge(_otherChallengeController.text.trim());

    // Créer le profil
    final saved = await coachingProvider.createProfile(userId: user.id);

    if (!mounted) return;

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            coachingProvider.error ?? 'Impossible d’enregistrer votre profil.',
          ),
        ),
      );
      return;
    }

    final profile = coachingProvider.profile;

    if (profile != null) {
      // Le profil est maintenant sauvegardé pour le chargement ultérieur du coach.
    }

    // Aller vers l'application principale
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  // ==================================================
  // WIDGET CHALLENGE
  // ==================================================

  Widget _challengeTile({
    required LifeChallengeType type,
    required String title,
    required IconData icon,
  }) {
    final provider = context.watch<CoachingProfileProvider>();

    final selected = provider.hasChallenge(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppTheme.primary : Colors.grey.shade300,
        ),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: (_) {
          context.read<CoachingProfileProvider>().toggleChallenge(type);
        },
        activeColor: AppTheme.primary,
        secondary: Icon(
          icon,
          color: selected ? AppTheme.primary : AppTheme.textMedium,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Votre quotidien')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressIndicatorWidget(currentStep: 4, totalSteps: 4),

              const SizedBox(height: 30),

              Text(
                'Quelles difficultés rencontrez-vous ?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Sélectionnez les situations qui peuvent rendre votre objectif plus difficile.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMedium),
              ),

              const SizedBox(height: 25),

              // REPAS PROFESSIONNELS
              _challengeTile(
                type: LifeChallengeType.professionalMeals,
                title: 'Repas professionnels',
                icon: Icons.restaurant,
              ),

              // VOYAGES
              _challengeTile(
                type: LifeChallengeType.frequentTravel,
                title: 'Déplacements fréquents',
                icon: Icons.flight_takeoff,
              ),

              // STRESS
              _challengeTile(
                type: LifeChallengeType.stress,
                title: 'Stress',
                icon: Icons.psychology,
              ),

              // PEU DE TEMPS
              _challengeTile(
                type: LifeChallengeType.littleTime,
                title: 'Peu de temps',
                icon: Icons.timer_outlined,
              ),

              // SOMMEIL
              _challengeTile(
                type: LifeChallengeType.irregularSleep,
                title: 'Sommeil irrégulier',
                icon: Icons.bedtime_outlined,
              ),

              const SizedBox(height: 15),

              // ======================================
              // AUTRE
              // ======================================
              Text(
                'Autre difficulté',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _otherChallengeController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Décrivez une autre difficulté...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              PrimaryButton(text: 'Terminer', onPressed: _finish),
            ],
          ),
        ),
      ),
    );
  }
}
