import 'dart:convert';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/services/naver_api_client.dart';

class SearchService {
  final NaverApiClient _client = NaverApiClient();

  Future<List<StockRef>> fetchSearch(String query, String target) async {
    final uri = Uri.https('ac.stock.naver.com', '/ac', {
      'q': query,
      'target': target,
    });
    final response = await _client.get(uri);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final items = responseJson['items'];

    final List<StockRef> result = [];
    for (final item in items) {
      final stockJson = item as Map<String, dynamic>;
      final korea = stockJson['nationCode'] == "KOR";
      final code = stockJson['code'] as String;
      final isSixDigit = RegExp(r'^\d{6}$').hasMatch(code);
      if (korea && isSixDigit) {
        result.add(StockRef.fromSearchItem(stockJson));
      }
    }
    return result;
  }
}
