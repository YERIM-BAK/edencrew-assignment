import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/providers/period_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class PeriodTabBar extends StatelessWidget {
  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onSelect;

  const PeriodTabBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final AppDimens dimens = context.dimens;

    return Row(
      spacing: dimens.space1,
      children: <Widget>[
        for (final ChartPeriod period in ChartPeriod.values)
          Expanded(
            child: _PeriodChip(
              period: period,
              isSelected: period == selected,
              onTap: () => onSelect(period),
            ),
          ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final ChartPeriod period;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: dimens.space3),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentBg : null,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Text(
          periodLabel(period),
          style: TextStyle(
            color: isSelected ? colors.accentDefault : colors.textSecondary,
            fontWeight: AppTypography.medium,
            fontSize: 13,
            height: 18 / 13,
          ),
        ),
      ),
    );
  }
}
