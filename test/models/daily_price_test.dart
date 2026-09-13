import 'dart:io';
import 'package:cp949_codec/cp949_codec.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_test/flutter_test.dart';
import 'package:edencrew_assignment_starter/models/daily_price.dart';

String extractChangeCell(dom.Element td) {
  final directionClass = td.querySelector('em')!.className;
  final numberText = td.querySelector('span.tah')!.text.trim();

  if (directionClass.contains('bu_pdn')) {
    return '-$numberText';
  }
  if (directionClass.contains('bu_pup')) {
    return '+$numberText';
  }
  return numberText;
}

void main() {
  test('.DailyPrice.fromCells parses sise_day.html', () {
    final bytes = File('assets/mock/sise_day.html').readAsBytesSync();
    final decoded = cp949.decode(bytes);

    final document = html_parser.parse(decoded);
    final table = document.querySelector('table.type2');

    final rows = table!.querySelectorAll('tr[onMouseOver]');

    final firstRow = rows[0];
    final tds = firstRow.querySelectorAll('td');
    final cells = [
      tds[0].text.trim(),
      tds[1].text.trim(),
      extractChangeCell(tds[2]),
      tds[3].text.trim(),
      tds[4].text.trim(),
      tds[5].text.trim(),
      tds[6].text.trim(),
    ];

    final dailyPrice = DailyPrice.fromCells(cells);

    expect(dailyPrice.close, 269000);
    expect(dailyPrice.changeAmount, -500);
    expect(dailyPrice.open, 269000);
    expect(dailyPrice.high, 270500);
    expect(dailyPrice.low, 263500);
    expect(dailyPrice.volume, 21010910);
    expect(dailyPrice.date, DateTime(2026, 9, 10));
  });
}
