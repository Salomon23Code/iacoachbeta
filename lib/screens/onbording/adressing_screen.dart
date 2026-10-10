import 'package:flutter/material.dart';
import 'package:iacoachbeta/screens/onbording/personnal_info_screen.dart';
import 'package:provider/provider.dart';

import '../../models/coaching_profile.dart';
import '../../providers/coaching_profile.dart';

import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/progress_indicator.dart';


class AddressingScreen extends StatelessWidget {
  const AddressingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 4,
              ),

              const SizedBox(height: 35),

              const Text(
                'Comment souhaitez-vous\nque votre Coach vous parle ?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Choisissez la façon dont vous souhaitez être accompagné.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.textMedium,
                ),
              ),

              const SizedBox(height: 30),

              Consumer<CoachingProfileProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      _AddressingOption(
                        title: 'Tu',
                        description:
                        'Une relation simple, directe et chaleureuse.',
                        icon: Icons.favorite_outline,
                        selected:
                        provider.addressingStyle ==
                            AddressingStyle.tu,
                        onTap: () {
                          provider.setAddressingStyle(
                            AddressingStyle.tu,
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      _AddressingOption(
                        title: 'Vous',
                        description:
                        'Une relation respectueuse et professionnelle.',
                        icon: Icons.handshake_outlined,
                        selected:
                        provider.addressingStyle ==
                            AddressingStyle.vous,
                        onTap: () {
                          provider.setAddressingStyle(
                            AddressingStyle.vous,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),


              const Spacer(),

              PrimaryButton(
                text: 'Continuer',
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const PersonalInfoScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressingOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AddressingOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.lightGreen
              : AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppTheme.primary
                : AppTheme.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : AppTheme.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected
                    ? Colors.white
                    : AppTheme.textMedium,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}