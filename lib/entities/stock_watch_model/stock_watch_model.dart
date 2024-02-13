class StockWatchModel {
  StockWatchModel(
      {required this.stockName,
      required this.value,
      required this.marginalChange});

  final String stockName;
  final double value;
  final double marginalChange;
}
