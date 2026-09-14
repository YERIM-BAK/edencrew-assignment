import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

/// 특정 상태(정렬 기준 등)에 종속되지 않도록, 선택 로직은 호출부에서
/// [onSelect] 콜백으로 넘겨받습니다. 이 위젯 자체는 provider를 모릅니다.
class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T selected;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onSelect;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceOverlay,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dimens.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: dimens.space2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dimens.space6,
                  vertical: dimens.space5,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 19,
                    fontWeight: AppTypography.bold,
                    height: 22 / 19,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              ...options.map((T option) {
                final bool isSelected = option == selected;

                return SizedBox(
                  height: dimens.rowMinHeight,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: dimens.space6,
                    ),
                    title: Text(
                      labelBuilder(option),
                      style: TextStyle(
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textSecondary,
                        fontSize: 15,
                        fontWeight: AppTypography.medium,
                        height: 20 / 15,
                        letterSpacing: -0.1,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: colors.selectedForeground)
                        : null,
                    onTap: () {
                      onSelect(option);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
