import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CoachTipCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CoachTipCard({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.spa_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: const BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.textMedium,
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