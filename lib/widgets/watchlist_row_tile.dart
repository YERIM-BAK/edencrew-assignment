import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/utils/formatters.dart';

/// 시세(quote) 데이터 들어오기 전까지 가격/등락 영역만 스켈레톤으로 표시
class WatchlistRowTile extends StatelessWidget {
  final WatchlistItem item;

  const WatchlistRowTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;
    final Quote? quote = item.quote;

    return Container(
      constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.borderSubtle,
            width: dimens.borderHairline,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.stock.name,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: AppTypography.medium,
                    fontSize: 15,
                    height: 20 / 15,
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: dimens.space1),
                Text(
                  '${item.stock.symbol} · ${item.stock.market}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontWeight: AppTypography.regular,
                    fontSize: 11,
                    height: 14 / 11,
                  ),
                ),
              ],
            ),
          ),
          if (quote == null)
            _SkeletonPrice(colors: colors, dimens: dimens)
          else
            _PriceColumn(quote: quote, colors: colors, dimens: dimens),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final Quote quote;
  final AppColors colors;
  final AppDimens dimens;

  const _PriceColumn({
    required this.quote,
    required this.colors,
    required this.dimens,
  });

  @override
  Widget build(BuildContext context) {
    final Color changeColor = quote.changeAmount > 0
        ? colors.priceUpText
        : quote.changeAmount < 0
        ? colors.priceDownText
        : colors.priceFlatText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          formatWithComma(quote.currentPrice),
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: AppTypography.medium,
            fontSize: 15,
            height: 20 / 15,
            letterSpacing: -0.1,
          ),
        ),
        SizedBox(height: dimens.space1),
        Text(
          formatChangeText(quote),
          style: TextStyle(
            color: changeColor,
            fontWeight: AppTypography.regular,
            fontSize: 11,
            height: 14 / 11,
          ),
        ),
      ],
    );
  }
}

class _SkeletonPrice extends StatelessWidget {
  final AppColors colors;
  final AppDimens dimens;

  const _SkeletonPrice({required this.colors, required this.dimens});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _bar(width: 56),
        SizedBox(height: dimens.space1),
        _bar(width: 44),
      ],
    );
  }

  Widget _bar({required double width}) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: colors.feedbackSkeleton,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
