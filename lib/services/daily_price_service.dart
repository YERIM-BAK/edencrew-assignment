import 'package:html/dom.dart' as dom;
import 'package:cp949_codec/cp949_codec.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/services/naver_api_client.dart';

String _extractChangeCell(dom.Element td) {
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

class DailyPricePage {
  final List<DailyPrice> prices;
  final int lastPage;

  DailyPricePage({required this.prices, required this.lastPage});
}

class DailyPriceService {
  final NaverApiClient _client = NaverApiClient();

  Future<DailyPricePage> fetchPage(String symbol, int page) async {
    final uri = Uri.https('finance.naver.com', '/item/sise_day.naver', {
      'code': symbol,
      'page': '$page',
    });
    final response = await _client.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    final bytes = response.bodyBytes;
    final decoded = cp949.decode(bytes);
    final document = html_parser.parse(decoded);

    final table = document.querySelector('table.type2');
    final rows = table?.querySelectorAll('tr[onMouseOver]') ?? [];

    final List<DailyPrice> prices = [];

    for (final row in rows) {
      final tds = row.querySelectorAll('td');
      final changeText = _extractChangeCell(tds[2]);

      final cells = [
        tds[0].text.trim(),
        tds[1].text.trim(),
        changeText,
        tds[3].text.trim(),
        tds[4].text.trim(),
        tds[5].text.trim(),
        tds[6].text.trim(),
      ];

      prices.add(DailyPrice.fromCells(cells));
    }

    final lastPageHref = document
        .querySelector('td.pgRR a')
        ?.attributes['href'];

    final lastPage = lastPageHref != null
        ? int.parse(RegExp(r'page=(\d+)').firstMatch(lastPageHref)!.group(1)!)
        : page;

    return DailyPricePage(prices: prices, lastPage: lastPage);
  }
}
