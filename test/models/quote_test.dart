import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:edencrew_assignment_starter/models/quote.dart';

void main() {
  test('.Quote.fromJson parses realtime_quote.json', () {
    final raw = File('assets/mock/realtime_quote.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final result = json['result'] as Map<String, dynamic>;
    final areas = result['areas'] as List;
    final firstArea = areas[0] as Map<String, dynamic>;
    final datas = firstArea['datas'] as List;

    final samsungData = datas[0] as Map<String, dynamic>;
    final quote = Quote.fromJson(samsungData);

    expect(quote.currentPrice, 269000); // nv
    expect(quote.previousClose, 269500); // pcv
    expect(quote.open, 269000); // ov
    expect(quote.high, 270500); // hv
    expect(quote.low, 263500); // lv
    expect(quote.volume, 21010910); // aq
    expect(quote.symbol, "005930"); // cd
    expect(quote.listedShares, 5846278608); // countOfListedStock
  });
}
