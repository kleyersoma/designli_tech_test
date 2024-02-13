import 'package:designli_tech_test/entities/available_stock_symbol_model/available_stock_symbol_model.dart';

class StockAlertModel {
  StockAlertModel(
      {required this.availableStockSymbolModel, required this.priceAlert});

  final AvailableStockSymbolModel availableStockSymbolModel;
  final double priceAlert;
}
