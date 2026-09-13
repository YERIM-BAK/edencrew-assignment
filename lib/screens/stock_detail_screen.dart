import 'package:edencrew_assignment_starter/widgets/app_toast.dart';
import 'package:edencrew_assignment_starter/widgets/daily_price_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/providers/daily_price_provider.dart';
import 'package:edencrew_assignment_starter/providers/favorites_provider.dart';
import 'package:edencrew_assignment_starter/providers/period_provider.dart';
import 'package:edencrew_assignment_starter/providers/quotes_provider.dart';
import 'package:edencrew_assignment_starter/providers/meta_provider.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/utils/formatters.dart';
import 'package:edencrew_assignment_starter/widgets/candle_chart.dart';
import 'package:edencrew_assignment_starter/widgets/period_tab_bar.dart';
import 'package:edencrew_assignment_starter/widgets/summary_card.dart';

class StockDetailScreen extends ConsumerWidget {
  final StockRef stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final AsyncValue<StockRef> metaAsync = ref.watch(
      stockMetaProvider(stock.symbol),
    );
    final String displayName = metaAsync.value?.name ?? stock.name;
    final String displayMarket = metaAsync.value?.market ?? stock.market;

    final ChartPeriod period = ref.watch(chartPeriodProvider);
    final AsyncValue<List<DailyPrice>> dailyPricesAsync = ref.watch(
      dailyPriceProvider(stock.symbol),
    );
    final AsyncValue<Quote?> quoteAsync = ref.watch(
      stockQuoteProvider(stock.symbol),
    );
    final Map<String, StockRef> favorites = ref.watch(favoritesProvider);
    final bool isFavorite = favorites.containsKey(stock.canonicalId);

    return Scaffold(
      body: ColoredBox(
        color: colors.surfaceBase,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // 헤더
              Container(
                width: double.infinity,
                height: 55, // 토큰 없음, Figma 값 그대로
                padding: EdgeInsets.symmetric(
                  vertical: 10, // 토큰 없음, Figma 값 그대로
                  horizontal: dimens.space4, // 16
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
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/icons/ico_back.svg',
                        width: dimens.iconMd,
                        height: dimens.iconMd,
                        colorFilter: ColorFilter.mode(
                          colors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: dimens.space3), // 12
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            displayName,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: AppTypography.medium,
                              fontSize: 15,
                              height: 20 / 15,
                              letterSpacing: -0.1,
                            ),
                          ),
                          Text(
                            '${stock.symbol} · $displayMarket',
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
                    SizedBox(width: dimens.space3), // 12
                    GestureDetector(
                      onTap: () {
                        final bool nowFavorite = !isFavorite;
                        ref.read(favoritesProvider.notifier).toggle(stock);
                        AppToast.show(
                          context,
                          icon: nowFavorite ? Icons.star : Icons.star_border,
                          iconColor: nowFavorite
                              ? colors.favoriteActive
                              : colors.textSecondary,
                          message: nowFavorite ? '관심이 등록되었습니다' : '관심이 해제되었습니다',
                        );
                      },
                      child: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite
                            ? colors.favoriteActive
                            : colors.favoriteInactive,
                      ),
                    ),
                  ],
                ),
              ),
              // 현재가 + 등락
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 14, // 토큰 없음, Figma 값 그대로
                    left: dimens.space4, // 16
                    right: dimens.space4, // 16
                    bottom: 22, // 토큰 없음, Figma 값 그대로
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      quoteAsync.when(
                        loading: () => const SizedBox(
                          height: 48,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (Object error, StackTrace stackTrace) =>
                            Text('오류가 발생했습니다: $error'),
                        data: (Quote? quote) {
                          if (quote == null) {
                            return const SizedBox(height: 48);
                          }
                          final Color changeColor = quote.changeAmount > 0
                              ? colors.priceUpText
                              : quote.changeAmount < 0
                              ? colors.priceDownText
                              : colors.priceFlatText;
                          final String arrow = quote.changeAmount > 0
                              ? '▲'
                              : quote.changeAmount < 0
                              ? '▼'
                              : '';

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                formatWithComma(quote.currentPrice),
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontWeight: AppTypography.bold,
                                  fontSize: 30,
                                  height: 36 / 30,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(width: dimens.space2), // 8
                              Text(
                                '$arrow ${formatChangeText(quote)}',
                                style: TextStyle(
                                  color: changeColor,
                                  fontWeight: AppTypography.medium,
                                  fontSize: 15,
                                  height: 20 / 15,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: dimens.space4), // 16, 가격-탭 간격
                      PeriodTabBar(
                        selected: period,
                        onSelect: (ChartPeriod newPeriod) {
                          ref.read(chartPeriodProvider.notifier).state =
                              newPeriod;
                        },
                      ),
                      dailyPricesAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (Object error, StackTrace stackTrace) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: Text('오류가 발생했습니다: $error')),
                        ),
                        data: (List<DailyPrice> prices) {
                          if (prices.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(child: Text('데이터가 없습니다')),
                            );
                          }
                          final Quote? quote = quoteAsync.value;

                          return Column(
                            children: <Widget>[
                              SizedBox(height: dimens.space4), // 16, 탭-차트 위 간격
                              CandleChart(prices: prices),
                              SizedBox(height: dimens.space4), // 16, 차트 아래 간격
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SummaryCard(
                                      label: '시가',
                                      value: formatWithComma(prices.first.open),
                                    ),
                                  ),
                                  SizedBox(width: dimens.space2),
                                  Expanded(
                                    child: SummaryCard(
                                      label: '고가',
                                      value: formatWithComma(prices.first.high),
                                    ),
                                  ),
                                  SizedBox(width: dimens.space2),
                                  Expanded(
                                    child: SummaryCard(
                                      label: '저가',
                                      value: formatWithComma(prices.first.low),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: dimens.space2),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SummaryCard(
                                      label: '거래량',
                                      value: quote == null
                                          ? '-'
                                          : formatVolumeAbbreviated(
                                              quote.volume,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: dimens.space2),
                                  Expanded(
                                    child: SummaryCard(
                                      label: '시가총액',
                                      value: quote == null
                                          ? '-'
                                          : formatMarketCapAbbreviated(
                                              quote.marketCap,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: dimens.space6), // 24, 카드-표 간격
                              DailyPriceTable(prices: prices),
                            ],
                          );
                        },
                      ),
                    ],
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
