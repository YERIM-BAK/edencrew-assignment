import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const SummaryCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9, // 토큰 없음, Figma 값 그대로
        horizontal: 10, // 토큰 없음, Figma 값 그대로
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(dimens.radiusMd), // 8
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontWeight: AppTypography.regular,
              fontSize: 11,
              height: 14 / 11,
            ),
          ),
          const SizedBox(height: 3), // 토큰 없음, Figma 값 그대로
          Text(
            value,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: AppTypography.medium,
              fontSize: 15,
              height: 20 / 15,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
