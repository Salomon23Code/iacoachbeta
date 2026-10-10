import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/daily_action_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../main/main_screen.dart';

class ActionCommitmentScreen extends StatelessWidget {
  const ActionCommitmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final action =
        context.watch<DailyActionProvider>().currentAction;

    if (action == null) {
      return const Scaffold(
        body: Center(
          child: Text('Aucune action disponible'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mon engagement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.check_circle,
                color: AppTheme.primary,
                size: 75,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'C’est parti ! 💚',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            _InfoSection(
              icon: Icons.directions_walk,
              title: 'Mon action',
              text: action.title,
            ),

            const SizedBox(height: 20),

            _InfoSection(
              icon: Icons.notifications_active,
              title: 'Mon déclencheur',
              text: action.trigger,
            ),

            const SizedBox(height: 20),

            _InfoSection(
              icon: Icons.track_changes,
              title: 'Mon suivi',
              text: action.tracking,
            ),

            const Spacer(),

            PrimaryButton(
              text: 'Retour à l’accueil',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  text,
                  style: const TextStyle(
                    height: 1.4,
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