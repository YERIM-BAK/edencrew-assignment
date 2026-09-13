import 'dart:convert';

import 'package:edencrew_assignment_starter/main.dart';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends Notifier<Map<String, StockRef>> {
  static const _key = 'favorites';

  @override
  Map<String, StockRef> build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_key);
    if (raw == null) return {};

    final List<dynamic> savedList = jsonDecode(raw) as List<dynamic>;
    final Map<String, StockRef> restored = {};

    for (final dynamic savedItem in savedList) {
      final Map<String, dynamic> json = savedItem as Map<String, dynamic>;
      final StockRef stock = StockRef(
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        market: json['market'] as String,
      );
      restored[stock.canonicalId] = stock;
    }

    return restored;
  }

  void toggle(StockRef stock) {
    if (state.containsKey(stock.canonicalId)) {
      remove(stock);
    } else {
      state = {...state, stock.canonicalId: stock};
      _persist();
    }
  }

  void remove(StockRef stock) {
    final next = Map<String, StockRef>.from(state)..remove(stock.canonicalId);
    state = next;
    _persist();
  }

  void _persist() {
    final list = state.values
        .map((s) => {'symbol': s.symbol, 'name': s.name, 'market': s.market})
        .toList();
    ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(list));
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Map<String, StockRef>>(
      FavoritesNotifier.new,
    );
