import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends Notifier<Map<String, StockRef>> {
  @override
  Map<String, StockRef> build() {
    return {};
  }

  void toggle(StockRef stock) {
    if (state.containsKey(stock.canonicalId)) {
      final next = Map<String, StockRef>.from(state);
      next.remove(stock.canonicalId);
      state = next;
    } else {
      state = {...state, stock.canonicalId: stock};
    }
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Map<String, StockRef>>(
      FavoritesNotifier.new,
    );
