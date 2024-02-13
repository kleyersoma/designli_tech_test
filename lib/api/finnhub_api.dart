class FinnHubAPI {
  FinnHubAPI(this.apiKey);

  final String apiKey;
  static const String _apiBaseUrl = 'finnhub.io';

  Uri listAvailableStocks() => Uri(
      scheme: 'https',
      host: _apiBaseUrl,
      path: '/api/v1/stock/symbol',
      queryParameters: {'exchange': 'US', 'token': apiKey});

  Uri quoteStock({required String symbol}) => Uri(
      scheme: 'https',
      host: _apiBaseUrl,
      path: '/api/v1/quote',
      queryParameters: {'symbol': symbol, 'token': apiKey});
}
