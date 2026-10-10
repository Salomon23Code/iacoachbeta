import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
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
      borderRadius: BorderRadius.circular(14),

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),

        padding: const EdgeInsets.all(13),

        decoration: BoxDecoration(
          color: selected
              ? AppTheme.veryLightGreen
              : AppTheme.white,

          borderRadius: BorderRadius.circular(14),

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
              width: 38,
              height: 38,

              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.lightGreen
                    : AppTheme.background,
                borderRadius: BorderRadius.circular(11),
              ),

              child: Icon(
                icon,
                size: 21,
                color: AppTheme.textDark,
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

                  const SizedBox(height: 3),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),

              width: 23,
              height: 23,

              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary
                    : Colors.transparent,

                shape: BoxShape.circle,

                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.border,
                ),
              ),

              child: selected
                  ? const Icon(
                Icons.check,
                size: 15,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}