import 'package:designli_tech_test/entities/available_stock_symbol_model/available_stock_symbol_model.dart';
import 'package:designli_tech_test/entities/quote_stock_model/quote_stock_model.dart';

abstract class AbstractFinnHubRepository {
  Future<List<AvailableStockSymbolModel>> listAvailableStocks();
  Future<QuoteStockModel> quoteStock({required String symbol});
}
