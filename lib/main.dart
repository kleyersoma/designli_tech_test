import 'package:designli_tech_test/providers/stock_watchlist_provider.dart';
import 'package:designli_tech_test/views/stock_watchlist/stock_watchlist_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<StockWatchListProvider>(
      create: (context) => StockWatchListProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DESIGNLI Flutter Tech Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StockWatchListView(),
    );
  }
}
