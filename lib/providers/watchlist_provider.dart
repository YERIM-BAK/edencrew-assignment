import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/providers/favorites_provider.dart';
import 'package:edencrew_assignment_starter/providers/quotes_provider.dart';
import 'package:edencrew_assignment_starter/providers/sort_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistItem {
  final StockRef stock;
  final Quote? quote;

  WatchlistItem({required this.stock, this.quote});
}

final watchlistProvider = Provider<List<WatchlistItem>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  final quotesAsync = ref.watch(quotesProvider);
  final sortOption = ref.watch(sortOptionProvider);

  final quotes = quotesAsync.value ?? {};

  final items = favorites.values.map((stock) {
    return WatchlistItem(stock: stock, quote: quotes[stock.symbol]);
  }).toList();

  items.sort((itemA, itemB) {
    switch (sortOption) {
      case SortOption.currentPrice:
        if (itemA.quote == null && itemB.quote == null) return 0;
        if (itemA.quote == null) return 1;
        if (itemB.quote == null) return -1;
        return itemB.quote!.currentPrice.compareTo(itemA.quote!.currentPrice);
      case SortOption.changeRate:
        if (itemA.quote == null && itemB.quote == null) return 0;
        if (itemA.quote == null) return 1;
        if (itemB.quote == null) return -1;
        return itemB.quote!.changeRate.compareTo(itemA.quote!.changeRate);
      case SortOption.alphabetical:
        return itemA.stock.name.compareTo(itemB.stock.name);
    }
  });

  return items;
});
