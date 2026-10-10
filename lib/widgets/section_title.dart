import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 5),

                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMedium,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (trailing != null) trailing!,
      ],
    );
  }
}