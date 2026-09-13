import 'package:flutter_riverpod/legacy.dart';

enum ChartPeriod { oneMonth, threeMonths, sixMonths, oneYear }

String periodLabel(ChartPeriod period) {
  switch (period) {
    case ChartPeriod.oneMonth:
      return '1개월';
    case ChartPeriod.threeMonths:
      return '3개월';
    case ChartPeriod.sixMonths:
      return '6개월';
    case ChartPeriod.oneYear:
      return '1년';
  }
}

int pagesForPeriod(ChartPeriod period) {
  switch (period) {
    case ChartPeriod.oneMonth:
      return 2;
    case ChartPeriod.threeMonths:
      return 6;
    case ChartPeriod.sixMonths:
      return 12;
    case ChartPeriod.oneYear:
      return 25;
  }
}

final chartPeriodProvider = StateProvider<ChartPeriod>(
  (ref) => ChartPeriod.oneMonth,
);
