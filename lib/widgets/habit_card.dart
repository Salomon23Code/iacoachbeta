import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HabitStreakCard extends StatelessWidget {
  final int streak;
  final VoidCallback? onTap;

  const HabitStreakCard({
    super.key,
    required this.streak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(14),
              ),

              child: const Icon(
                Icons.calendar_month_outlined,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Série d’habitudes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$streak jours',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: AppTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }
}