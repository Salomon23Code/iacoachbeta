import 'package:flutter/material.dart';

import '../providers/weigtn_provider.dart';
import '../theme/app_theme.dart';

class WeightPeriodSelector extends StatelessWidget {
  final WeightPeriod selected;
  final ValueChanged<WeightPeriod> onChanged;

  const WeightPeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: WeightPeriod.values.map(
              (period) {
            final isSelected =
                period == selected;

            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(period),

                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 200,
                  ),

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.white
                        : Colors.transparent,

                    borderRadius:
                    BorderRadius.circular(9),
                  ),

                  child: Text(
                    _label(period),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textMedium,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  String _label(WeightPeriod period) {
    switch (period) {
      case WeightPeriod.month:
        return '1 mois';

      case WeightPeriod.threeMonths:
        return '3 mois';

      case WeightPeriod.sixMonths:
        return '6 mois';

      case WeightPeriod.all:
        return 'Tout';
    }
  }
}