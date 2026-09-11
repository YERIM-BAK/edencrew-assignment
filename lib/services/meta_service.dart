import 'dart:convert';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';
import 'package:edencrew_assignment_starter/services/naver_api_client.dart';

class MetaService {
  final NaverApiClient _client = NaverApiClient();

  Future<StockRef> fetchMeta(String symbol) async {
    final String urlString =
        'https://stock.naver.com/api/securityFe/api/fchart/domestic/stock/$symbol';
    final uri = Uri.parse(urlString);
    final response = await _client.get(uri);
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return StockRef.fromMeta(responseJson);
  }
}
