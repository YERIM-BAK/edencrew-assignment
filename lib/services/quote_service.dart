import 'dart:convert';
import 'package:edencrew_assignment_starter/models/quote.dart';
import 'package:edencrew_assignment_starter/services/naver_api_client.dart';

class QuoteService {
  final NaverApiClient _client = NaverApiClient();

  Future<Map<String, Quote>> fetchQuote(List<String> symbols) async {
    final queryString = 'SERVICE_ITEM:${symbols.join(',')}';
    final uri = Uri.https('polling.finance.naver.com', '/api/realtime', {
      'query': queryString,
    });
    final response = await _client.get(uri);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final datas = responseJson['result']['areas'][0]['datas'] as List;

    final Map<String, Quote> result = {};
    for (final item in datas) {
      final quote = Quote.fromJson(item as Map<String, dynamic>);
      result[quote.symbol] = quote;
    }
    return result;
  }
}
