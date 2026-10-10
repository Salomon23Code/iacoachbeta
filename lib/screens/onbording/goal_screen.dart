import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/coaching_profile.dart';
import '../../providers/goal_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_indicator.dart';
import 'real_life_screen.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _targetWeightController = TextEditingController();

  final TextEditingController _motivationController = TextEditingController();

  @override
  void dispose() {
    _targetWeightController.dispose();
    _motivationController.dispose();

    super.dispose();
  }

  // ==================================================
  // CONTINUER
  // ==================================================

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double targetWeight = double.parse(
      _targetWeightController.text.trim().replaceAll(',', '.'),
    );

    final String motivation = _motivationController.text.trim();

    context.read<CoachingProfileProvider>().setGoalInformation(
      targetWeight: targetWeight,
      motivation: motivation,
    );

    final user = context.read<UserProvider>().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur introuvable.')));
      return;
    }

    final saved = await context.read<GoalProvider>().createGoal(
      userId: user.id,
      targetWeight: targetWeight,
      objective: 'Atteindre un poids de ${targetWeight.toStringAsFixed(1)} kg',
      motivation: motivation,
    );

    if (!mounted) return;
    if (!saved) {
      final error = context.read<GoalProvider>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Impossible d’enregistrer votre objectif.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RealLifeScreen()),
    );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<GoalProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Votre objectif')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressIndicatorWidget(currentStep: 3, totalSteps: 4),

                const SizedBox(height: 30),

                Text(
                  'Quel est votre objectif ?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Définissons ensemble un objectif réaliste et adapté à votre situation.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMedium),
                ),

                const SizedBox(height: 30),

                // ======================================
                // POIDS CIBLE
                // ======================================
                CustomTextField(
                  controller: _targetWeightController,
                  label: 'Poids cible',
                  hint: 'Ex : 70 kg',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre poids cible';
                    }

                    final targetWeight = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );

                    if (targetWeight == null) {
                      return 'Veuillez entrer un poids valide';
                    }

                    if (targetWeight < 30 || targetWeight > 300) {
                      return 'Poids cible invalide';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // ======================================
                // MOTIVATION
                // ======================================
                CustomTextField(
                  controller: _motivationController,
                  label: 'Votre motivation',
                  hint: 'Pourquoi souhaitez-vous atteindre cet objectif ?',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez expliquer votre motivation';
                    }

                    if (value.trim().length < 5) {
                      return 'Votre motivation est trop courte';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 35),

                PrimaryButton(
                  text: isSaving ? 'Enregistrement...' : 'Continuer',
                  onPressed: _continue,
                  loading: isSaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
