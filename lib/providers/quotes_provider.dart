import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/providers/favorites_provider.dart';
import 'package:edencrew_assignment_starter/services/quote_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuotesNotifier extends AsyncNotifier<Map<String, Quote>> {
  @override
  Future<Map<String, Quote>> build() async {
    final favorites = ref.watch(favoritesProvider);
    final symbols = favorites.values.map((stock) => stock.symbol).toList();

    if (symbols.isEmpty) {
      return {};
    }

    return QuoteService().fetchQuote(symbols);
  }
}

final quotesProvider =
    AsyncNotifierProvider<QuotesNotifier, Map<String, Quote>>(
      QuotesNotifier.new,
    );
