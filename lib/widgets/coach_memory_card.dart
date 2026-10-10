import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CoachMemoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback? onEdit;

  const CoachMemoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.onEdit, required IconButton trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 20,
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
                  content,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppTheme.textMedium,
                  ),
                ),
              ],
            ),
          ),

          if (onEdit != null)
            TextButton(
              onPressed: onEdit,
              child: const Text(
                'Modifier',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}