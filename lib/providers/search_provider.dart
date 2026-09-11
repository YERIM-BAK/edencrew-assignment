import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/services/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchNotifier extends AsyncNotifier<List<StockRef>> {
  @override
  Future<List<StockRef>> build() async {
    final query = ref.watch(searchQueryProvider);

    if (query.isEmpty) {
      return [];
    }

    return SearchService().fetchSearch(
      query,
      'stock,ipo,index,marketindicator',
    );
  }
}

final searchResultsProvider =
    AsyncNotifierProvider<SearchNotifier, List<StockRef>>(SearchNotifier.new);
