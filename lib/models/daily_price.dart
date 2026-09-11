class DailyPrice {
  final DateTime date;
  final int open;
  final int high;
  final int low;
  final int close;
  final int volume;
  final int changeAmount;

  DailyPrice({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.changeAmount,
  });

  factory DailyPrice.fromCells(List<String> cells) {
    final dateParts = cells[0].split(".");
    final date = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );

    int parseNum(String numText) => int.parse(numText.replaceAll(',', ''));

    return DailyPrice(
      date: date,
      close: parseNum(cells[1]),
      changeAmount: parseNum(cells[2]),
      open: parseNum(cells[3]),
      high: parseNum(cells[4]),
      low: parseNum(cells[5]),
      volume: parseNum(cells[6]),
    );
  }
}
