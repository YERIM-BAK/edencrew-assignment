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
