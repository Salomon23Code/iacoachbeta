import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppTheme.border,
              valueColor:
              const AlwaysStoppedAnimation<Color>(
                AppTheme.primary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Text(
          '$currentStep sur $totalSteps',
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}