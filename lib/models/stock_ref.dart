class StockRef {
  final String symbol;
  final String name;
  final String market;

  StockRef({required this.symbol, required this.name, required this.market});

  factory StockRef.fromMeta(Map<String, dynamic> json) {
    return StockRef(
      symbol: json["symbolCode"] as String,
      name: json["stockName"] as String,
      market: json["stockExchangeNameKor"] as String,
    );
  }

  factory StockRef.fromSearchItem(Map<String, dynamic> json) {
    return StockRef(
      symbol: json["code"] as String,
      name: json["name"] as String,
      market: json["typeName"] as String,
    );
  }

  String get canonicalId => 'domestic:$symbol';
}
