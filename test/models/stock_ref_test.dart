import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:edencrew_assignment_starter/models/stock_ref.dart';

void main() {
  test('StockRef.fromMeta parses stock_meta.json', () {
    final raw = File('assets/mock/stock_meta.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final stock = StockRef.fromMeta(json);

    expect(stock.symbol, "005930");
    expect(stock.name, "삼성전자");
    expect(stock.market, "코스피");
  });

  test('StockRef.fromSearchItem parses search_autocomplete.json', () {
    final raw = File('assets/mock/search_autocomplete.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = json['items'] as List;
    final firstItem = items[0] as Map<String, dynamic>;
    final stock = StockRef.fromSearchItem(firstItem);

    expect(stock.symbol, "005930");
    expect(stock.name, "삼성전자");
    expect(stock.market, "코스피");
  });
}
