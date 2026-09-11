class Quote {
  final String symbol;
  final int currentPrice; // nv
  final int previousClose; // pcv
  final int open; // ov
  final int high; // hv
  final int low; // lv
  final int volume; // aq
  final int listedShares; // countOfListedStock

  Quote({
    required this.symbol,
    required this.currentPrice,
    required this.previousClose,
    required this.open,
    required this.high,
    required this.low,
    required this.volume,
    required this.listedShares,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      symbol: json['cd'] as String,
      currentPrice: json['nv'] as int,
      previousClose: json['pcv'] as int,
      open: json['ov'] as int,
      high: json['hv'] as int,
      low: json['lv'] as int,
      volume: json['aq'] as int,
      listedShares: json['countOfListedStock'] as int,
    );
  }

  int get changeAmount => currentPrice - previousClose;
  double get changeRate => (currentPrice - previousClose) / previousClose;
  int get marketCap => currentPrice * listedShares;
}
