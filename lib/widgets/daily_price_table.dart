import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/utils/formatters.dart';

class DailyPriceTable extends StatelessWidget {
  final List<DailyPrice> prices;

  const DailyPriceTable({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '일별 시세',
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: AppTypography.bold,
              fontSize: 13,
              height: 18 / 13,
            ),
          ),
          SizedBox(height: dimens.space1), // 4
          _DailyPriceRow(
            dateText: '날짜',
            closeText: '종가',
            changeText: '등락',
            volumeText: '거래량',
            colors: colors,
            dimens: dimens,
            showTopBorder: false,
          ),
          for (final DailyPrice price in prices)
            _DailyPriceRow(
              dateText: formatMonthDay(price.date),
              closeText: formatWithComma(price.close),
              changeText: formatSignedComma(price.changeAmount),
              volumeText: formatWithComma(price.volume),
              closeColor: colors.textPrimary,
              changeColor: price.changeAmount > 0
                  ? colors.priceUpText
                  : price.changeAmount < 0
                  ? colors.priceDownText
                  : colors.priceFlatText,
              colors: colors,
              dimens: dimens,
              showTopBorder: true,
            ),
        ],
      ),
    );
  }
}

class _DailyPriceRow extends StatelessWidget {
  final String dateText;
  final String closeText;
  final String changeText;
  final String volumeText;
  final Color? closeColor;
  final Color? changeColor;
  final AppColors colors;
  final AppDimens dimens;
  final bool showTopBorder;

  const _DailyPriceRow({
    required this.dateText,
    required this.closeText,
    required this.changeText,
    required this.volumeText,
    this.closeColor,
    this.changeColor,
    required this.colors,
    required this.dimens,
    required this.showTopBorder,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = TextStyle(
      color: colors.textSecondary,
      fontWeight: AppTypography.regular,
      fontSize: 11,
      height: 14 / 11,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: dimens.space2),
      decoration: showTopBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.borderSubtle,
                  width: dimens.borderHairline,
                ),
              ),
            )
          : null,
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text(dateText, style: baseStyle)),
          SizedBox(width: dimens.space2),
          Expanded(
            flex: 3,
            child: Text(
              closeText,
              textAlign: TextAlign.right,
              style: baseStyle.copyWith(color: closeColor),
            ),
          ),
          SizedBox(width: dimens.space2),
          Expanded(
            flex: 3,
            child: Text(
              changeText,
              textAlign: TextAlign.right,
              style: baseStyle.copyWith(color: changeColor),
            ),
          ),
          SizedBox(width: dimens.space2),
          Expanded(
            flex: 4,
            child: Text(
              volumeText,
              textAlign: TextAlign.right,
              style: baseStyle,
            ),
          ),
        ],
      ),
    );
  }
}
