import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppTheme.primary,
              size: 21,
            ),

            const SizedBox(height: 10),

            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textMedium,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),

            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textLight,
                ),
              ),
          ],
        ),
      ),
    );
  }
}