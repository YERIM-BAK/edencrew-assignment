import 'dart:math';
import 'package:flutter/material.dart';
import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class CandleChart extends StatelessWidget {
  final List<DailyPrice> prices;

  const CandleChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    if (prices.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: _CandleChartPainter(
          prices: prices.reversed.toList(),
          upColor: colors.chartLineUp,
          downColor: colors.chartLineDown,
          wickColor: colors.chartBaseline,
        ),
      ),
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  final List<DailyPrice> prices;
  final Color upColor;
  final Color downColor;
  final Color wickColor;

  _CandleChartPainter({
    required this.prices,
    required this.upColor,
    required this.downColor,
    required this.wickColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final int maxPrice = prices.map((p) => p.high).reduce(max);
    final int minPrice = prices.map((p) => p.low).reduce(min);
    final double priceRange = (maxPrice - minPrice) == 0
        ? 1
        : (maxPrice - minPrice).toDouble();

    final double slotWidth = size.width / prices.length;
    final double candleWidth = slotWidth * 0.6;

    double yFor(int price) {
      final double ratio = (price - minPrice) / priceRange;
      return size.height - (ratio * size.height);
    }

    final Paint wickPaint = Paint()
      ..color = wickColor
      ..strokeWidth = 1;

    for (int i = 0; i < prices.length; i++) {
      final DailyPrice price = prices[i];
      final double centerX = slotWidth * i + slotWidth / 2;
      final bool isUp = price.close >= price.open;

      // 꼬리 (고가 ~ 저가) — chartBaseline 고정 색
      canvas.drawLine(
        Offset(centerX, yFor(price.high)),
        Offset(centerX, yFor(price.low)),
        wickPaint,
      );

      // 몸통 (시가 ~ 종가) — 상승/하락 색
      final Paint bodyPaint = Paint()..color = isUp ? upColor : downColor;
      final double top = yFor(max(price.open, price.close));
      final double bottom = yFor(min(price.open, price.close));
      canvas.drawRect(
        Rect.fromLTRB(
          centerX - candleWidth / 2,
          top,
          centerX + candleWidth / 2,
          bottom == top ? top + 1 : bottom,
        ),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) {
    return oldDelegate.prices != prices;
  }
}
