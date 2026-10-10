import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final double? progress;
  final String? progressLabel;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.directions_walk_outlined,
    this.onTap,
    this.progress,
    this.progressLabel,
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

              child: Icon(
                icon,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 3),

                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMedium,
                      ),
                    ),
                  ],

                  if (progress != null) ...[
                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor:
                        AppTheme.border,
                        valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                          AppTheme.primary,
                        ),
                      ),
                    ),

                    if (progressLabel != null) ...[
                      const SizedBox(height: 5),

                      Text(
                        progressLabel!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMedium,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

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