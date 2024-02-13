import 'dart:convert';
import 'dart:io';

import 'package:designli_tech_test/api/finnhub_api.dart';
import 'package:designli_tech_test/entities/available_stock_symbol_model/available_stock_symbol_model.dart';
import 'package:designli_tech_test/entities/quote_stock_model/quote_stock_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FinnHubRepository {
  FinnHubRepository({required this.api});

  final FinnHubAPI api;

  Future<List<AvailableStockSymbolModel>> listAvailableStocks() async {
    try {
      final response = await http.get(api.listAvailableStocks());

      if (response.statusCode == HttpStatus.ok) {
        return compute(_parseAvailableStock, response.body);
      } else {
        throw Exception('Failed to obtain list of available stocks');
      }
    } catch (e) {
      throw Exception(
          'Failed to obtain list of available stocks: ${e.toString()}');
    }
  }

  Future<QuoteStockModel> quoteStock({required String symbol}) async {
    try {
      final response = await http.get(api.quoteStock(symbol: symbol));
      if (response.statusCode == HttpStatus.ok) {
        return QuoteStockModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to obtain stock quote: $symbol');
      }
    } catch (e) {
      throw Exception('Failed to obtain stock quote: $symbol ${e.toString()}');
    }
  }

  List<AvailableStockSymbolModel> _parseAvailableStock(String responseBody) {
    final List<dynamic> parsedListJson = jsonDecode(responseBody);
    final List<AvailableStockSymbolModel> listAvailableStock =
        List<AvailableStockSymbolModel>.from(
            parsedListJson.map<AvailableStockSymbolModel>(
                (dynamic json) => AvailableStockSymbolModel.fromJson(json)));
    return listAvailableStock;
  }
}
