import 'package:flutter/material.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? iconColor,
  }) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.space4, // 16
              vertical: 14, // Figma 값, 재사용 빈도 낮아 토큰화 안 함
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: BorderRadius.circular(dimens.radiusMd),
              border: Border.all(
                color: colors.borderSubtle,
                width: dimens.borderHairline,
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x8C000000),
                  offset: Offset(0, 8),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(
                    icon,
                    size: 18, // Figma 값, 토큰화 안 함
                    color: iconColor ?? colors.textSecondary,
                  ),
                  SizedBox(width: dimens.space2),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontWeight: AppTypography.bold,
                      fontSize: 13,
                      height: 18 / 13,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
