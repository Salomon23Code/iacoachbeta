import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CheckInOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CheckInOption({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),

          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary
                : AppTheme.white,

            borderRadius: BorderRadius.circular(14),

            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : AppTheme.border,
            ),
          ),

          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? AppTheme.white
                    : AppTheme.textMedium,
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppTheme.white
                      : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}