import 'package:edencrew_assignment_starter/models/quote.dart';

/// 정수에 천 단위 콤마 (예: 71200 -> "71,200")
String formatWithComma(int value) {
  final bool isNegative = value < 0;
  final String digits = value.abs().toString();
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return (isNegative ? '-' : '') + buffer.toString();
}

/// 등락액/등락률을 "부호 + 콤마 + 괄호 등락률" 형태 (예: "-400 (-0.22%)")
String formatChangeText(Quote quote) {
  final int amount = quote.changeAmount;
  final double ratePercent = quote.changeRate * 100;
  final String amountText = formatWithComma(amount.abs());
  final String rateText = ratePercent.abs().toStringAsFixed(2);

  if (amount > 0) {
    return '+$amountText (+$rateText%)';
  } else if (amount < 0) {
    return '-$amountText (-$rateText%)';
  } else {
    return '0 (0.00%)';
  }
}

/// 거래량을 천 단위로 축약 (예: 29113466 -> "29,113천")
String formatVolumeAbbreviated(int volume) {
  return '${formatWithComma(volume ~/ 1000)}천';
}

/// 시가총액을 조/억 단위로 축약 (1조 이상 -> "1,063조", 미만 -> "3,201억")
String formatMarketCapAbbreviated(int marketCap) {
  const int jo = 1000000000000; // 조
  const int eok = 100000000; // 억

  if (marketCap >= jo) {
    return '${formatWithComma(marketCap ~/ jo)}조';
  }
  return '${formatWithComma(marketCap ~/ eok)}억';
}

/// 날짜를 MM.DD 형태로 표시 (예: 2026-03-27 -> "03.27")
String formatMonthDay(DateTime date) {
  final String month = date.month.toString().padLeft(2, '0');
  final String day = date.day.toString().padLeft(2, '0');
  return '$month.$day';
}

/// 등락액에 부호를 붙여 콤마 포맷 (예: 1200 -> "+1,200", -400 -> "-400", 0 -> "0")
String formatSignedComma(int value) {
  if (value > 0) return '+${formatWithComma(value)}';
  return formatWithComma(value); // 음수는 formatWithComma가 이미 '-' 붙여줌
}
