import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/providers/period_provider.dart';
import 'package:edencrew_assignment_starter/services/daily_price_service.dart';

class DailyPriceNotifier extends AsyncNotifier<List<DailyPrice>> {
  DailyPriceNotifier(this.symbol);

  final String symbol;

  final Map<int, List<DailyPrice>> _pageCache = {};
  int? _lastPage;

  @override
  Future<List<DailyPrice>> build() async {
    final ChartPeriod period = ref.watch(chartPeriodProvider);
    return _loadUpTo(pagesForPeriod(period));
  }

  Future<List<DailyPrice>> _loadUpTo(int neededPages) async {
    final int upperBound = _lastPage == null
        ? neededPages
        : neededPages.clamp(0, _lastPage!);
    for (int page = 1; page <= upperBound; page++) {
      if (_pageCache.containsKey(page)) continue;
      final result = await DailyPriceService().fetchPage(symbol, page);
      _pageCache[page] = result.prices;
      _lastPage ??= result.lastPage;
      if (page >= _lastPage!) break;
    }

    return [
      for (int page = 1; page <= upperBound; page++) ...?_pageCache[page],
    ];
  }
}

final dailyPriceProvider =
    AsyncNotifierProvider.family<DailyPriceNotifier, List<DailyPrice>, String>(
      DailyPriceNotifier.new,
    );
