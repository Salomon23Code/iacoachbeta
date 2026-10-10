import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/daily_checking.dart';
import '../../providers/cheicking_provider.dart';
import '../../providers/daily_action_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/cheicking_option.dart';
import '../../widgets/primary_button.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _reasonController = TextEditingController();
  CheckInStatus? _selectedStatus;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final checkInProvider = context.read<CheckInProvider>();

    final user = context.read<UserProvider>().currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur introuvable.')));
      return;
    }

    final reason = _reasonController.text.trim();

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Choisissez une réponse.')));
      return;
    }

    final success = await checkInProvider.submitCheckIn(
      userId: user.id,
      status: _selectedStatus!,
      reason: reason.isEmpty ? null : reason,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            checkInProvider.error ?? 'Impossible d’enregistrer le check-in.',
          ),
        ),
      );
      return;
    }

    final actionProvider = context.read<DailyActionProvider>();

    final removed = await actionProvider.removeCurrentAction(userId: user.id);
    if (!mounted) return;
    if (!removed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            actionProvider.error ?? 'Impossible de mettre à jour votre action.',
          ),
        ),
      );
      Navigator.pop(context);
      return;
    }

    final generated = await actionProvider.generateAction(
      userId: user.id,
      reason: reason,
    );
    if (!mounted) return;
    if (!generated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            actionProvider.error ??
                'Impossible de proposer une nouvelle action.',
          ),
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CheckInProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in du jour')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Un petit pas compte toujours 🌱',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Prenons quelques secondes pour faire le point sur votre journée.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMedium,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Avez-vous réalisé votre petite action ?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  CheckInOption(
                    title: 'Oui',
                    icon: Icons.check,
                    selected: _selectedStatus == CheckInStatus.yes,
                    onTap: () =>
                        setState(() => _selectedStatus = CheckInStatus.yes),
                  ),
                  const SizedBox(width: 8),
                  CheckInOption(
                    title: 'En partie',
                    icon: Icons.remove_circle_outline,
                    selected: _selectedStatus == CheckInStatus.partially,
                    onTap: () => setState(
                      () => _selectedStatus = CheckInStatus.partially,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CheckInOption(
                    title: 'Non',
                    icon: Icons.close,
                    selected: _selectedStatus == CheckInStatus.no,
                    onTap: () =>
                        setState(() => _selectedStatus = CheckInStatus.no),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              CustomTextField(
                label: 'Qu’est-ce qui vous a aidé ou bloqué ?',
                hint: 'Partagez en quelques mots...',
                controller: _reasonController,
                maxLines: 5,
                prefixIcon: Icons.chat_bubble_outline,
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: provider.isLoading
                    ? 'Enregistrement...'
                    : 'Valider mon check-in',
                icon: Icons.check,
                onPressed: provider.isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
