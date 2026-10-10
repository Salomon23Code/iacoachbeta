import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/daily_action_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import 'action_comitment_screen.dart';

class ActionProposalScreen extends StatelessWidget {
  const ActionProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyActionProvider>();

    final action = provider.currentAction;

    if (action == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final user = context.read<UserProvider>().currentUser;
              if (user == null) return;
              final created = await provider.generateAction(userId: user.id);
              if (!context.mounted) return;
              if (!created) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.error ?? 'Création impossible.'),
                  ),
                );
              }
            },
            child: const Text('Proposer une action'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ta prochaine petite action')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: AppTheme.primary,
                    size: 35,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Merci pour ton honnêteté 💚',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Les petits pas créent un grand changement.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Ton coach te propose :',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            Text(
              action.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              action.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const Spacer(),

            PrimaryButton(
              text: 'Je m’engage',
              onPressed: () async {
                final user = context.read<UserProvider>().currentUser;
                if (user == null) return;
                final committed = await provider.commitAction(userId: user.id);
                if (!context.mounted) return;
                if (!committed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        provider.error ?? 'Enregistrement impossible.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActionCommitmentScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final user = context.read<UserProvider>().currentUser;
                  if (user == null) return;
                  final removed = await provider.removeCurrentAction(
                    userId: user.id,
                  );
                  if (!context.mounted || !removed) return;
                  await provider.generateAction(userId: user.id);
                },
                child: const Text('Modifier l’action'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
