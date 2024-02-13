
import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'package:designli_tech_test/api/api_key.default.dart';
import 'package:designli_tech_test/api/finnhub_api.dart';
import 'package:designli_tech_test/entities/available_stock_symbol_model/available_stock_symbol_model.dart';
import 'package:designli_tech_test/entities/chart_data/chart_data.dart';
import 'package:designli_tech_test/entities/quote_stock_model/quote_stock_model.dart';
import 'package:designli_tech_test/entities/stock_alert_model/stock_alert_model.dart';
import 'package:designli_tech_test/entities/stock_watch_model/stock_watch_model.dart';
import 'package:designli_tech_test/repositories/finnhub_repository.dart';

class StockWatchListProvider extends ChangeNotifier {
  final List<StockAlertModel> _stockAlertWatchList = [];
  final List<StockWatchModel> _stockWatchModelList = [];

  late AvailableStockSymbolModel _availableStockSymbolModel;
  late double _priceAlert;

  List<StockAlertModel> get stockAlertModelList => _stockAlertWatchList;
  List<StockWatchModel> get stockWatchModelList => _stockWatchModelList;

  AvailableStockSymbolModel get availableStockSymbolModel =>
      _availableStockSymbolModel;

  double get priceAlert => _priceAlert;

  set availableStockSymbolModel(AvailableStockSymbolModel value) {
    _availableStockSymbolModel = value;
    notifyListeners();
  }

  set priceAlert(double value) {
    _priceAlert = value;
    notifyListeners();
  }

  Future<void> addStockToWatchList() async {
    final stockAlertModel = StockAlertModel(
        availableStockSymbolModel: availableStockSymbolModel,
        priceAlert: priceAlert);
    _stockAlertWatchList.add(stockAlertModel);
    notifyListeners();
  }

  Future<List<StockWatchModel>> quoteStockWatchList() async {
    final FutureGroup<QuoteStockModel> futureGroup =
        FutureGroup<QuoteStockModel>();
    final finnHubRepository =
        FinnHubRepository(api: FinnHubAPI(APIKeys.finnHubAPIKey));

    for (var element in _stockAlertWatchList) {
      futureGroup.add(finnHubRepository.quoteStock(
          symbol: element.availableStockSymbolModel.symbol!));
    }
    futureGroup.close();

    final List<QuoteStockModel> quoteStockList = await futureGroup.future;

    if (_stockWatchModelList.isNotEmpty) {
      _stockWatchModelList.clear();
    }

    for (var i = 0; i < _stockAlertWatchList.length; i++) {
      final stockAlertModel = _stockAlertWatchList.elementAt(i);
      final quoteStockModel = quoteStockList.elementAt(i);
      final stockWatchModel = StockWatchModel(
          stockName: stockAlertModel.availableStockSymbolModel.description!,
          value: quoteStockModel.c!,
          marginalChange: quoteStockModel.dp ?? 0);

      _stockWatchModelList.add(stockWatchModel);
    }
    // notifyListeners();
    return _stockWatchModelList;
  }

  List<ChartData> getChartData() {
    final List<ChartData> chartData = [];
    for (var element in _stockWatchModelList) {
      chartData.add(ChartData(
          stockName: element.stockName,
          value: element.value,
          text: '\$${element.value}'));
    }
    return chartData;
  }

  double calculateWatchListValue() {
    double watchListValue = 0.0;
    for (var element in _stockWatchModelList) {
      watchListValue += element.value;
    }
    return watchListValue;
  }
}
