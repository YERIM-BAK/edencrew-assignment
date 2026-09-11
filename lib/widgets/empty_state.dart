import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class EmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final double? iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final double resolvedIconSize = iconSize ?? dimens.iconMd * 2;

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: resolvedIconSize,
              height: resolvedIconSize,
              child: FittedBox(
                fit: BoxFit.contain,
                child: IconTheme.merge(
                  data: IconThemeData(color: colors.textTertiary),
                  child: icon,
                ),
              ),
            ),
            SizedBox(height: dimens.space3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 19,
                fontWeight: AppTypography.bold,
                height: 22 / 19,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: dimens.space3),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textTertiary,
                fontSize: 11,
                fontWeight: AppTypography.regular,
                height: 14 / 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
