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

final stockQuoteProvider = FutureProvider.family<Quote?, String>((
  ref,
  symbol,
) async {
  final existingQuotes = ref.read(quotesProvider).value;
  if (existingQuotes != null && existingQuotes.containsKey(symbol)) {
    return existingQuotes[symbol]; // 관심종목이면 재사용
  }

  final quotes = await QuoteService().fetchQuote([symbol]);
  return quotes[symbol]; // 없으면 이 종목만 새로 조회
});
