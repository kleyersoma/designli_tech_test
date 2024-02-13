import 'package:designli_tech_test/entities/stock_alert_model/stock_alert_model.dart';
import 'package:designli_tech_test/views/stock_watchlist_graph/stock_watchlist_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'package:designli_tech_test/entities/stock_watch_model/stock_watch_model.dart';
import 'package:designli_tech_test/providers/stock_watchlist_provider.dart';
import 'package:designli_tech_test/views/add_stock_alert/add_stock_alert_view.dart';

class StockWatchListView extends StatelessWidget {
  const StockWatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock WatchList'),
      ),
      body: Center(
        child: Selector<StockWatchListProvider, List<StockAlertModel>>(
          selector: (context, stockWatchListProvider) =>
              stockWatchListProvider.stockAlertModelList,
          shouldRebuild: (previous, next) => true,
          builder: (context, stockAlertModelList, child) {
            return stockAlertModelList.isEmpty
                ? const _EmptyStockWatchList()
                : const _StockWatchListBody();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStockAlertView(),
            )),
        tooltip: 'Add Stock Alert',
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}

class _StockWatchListBody extends StatelessWidget {
  const _StockWatchListBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 192,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          OutlinedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockGraphView(),
                  )),
              icon: const Icon(Icons.data_usage),
              label: const Text('See WatchList Value')),
          const Gap(12),
          const Expanded(child: _StockWatchList())
        ]),
      ),
    );
  }
}

class _EmptyStockWatchList extends StatelessWidget {
  const _EmptyStockWatchList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('No stocks under watch list!');
  }
}

class _StockWatchList extends StatelessWidget {
  const _StockWatchList({super.key});

  @override
  Widget build(BuildContext context) {
    final stockWatchListProvider = Provider.of<StockWatchListProvider>(
      context,
    );
    return FutureBuilder<List<StockWatchModel>>(
      future: stockWatchListProvider.quoteStockWatchList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stockWatchModelList =
              stockWatchListProvider.stockWatchModelList;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stockWatchModelList.length,
            itemBuilder: (context, index) => _StockCard(
                stockWatchModel: stockWatchModelList.elementAt(index)),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const UnconstrainedBox(
            child: SizedBox.square(
                dimension: 32, child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({
    Key? key,
    required this.stockWatchModel,
  }) : super(key: key);
  final StockWatchModel stockWatchModel;
  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          height: 128,
          width: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$${stockWatchModel.value}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _MarginDifference(dp: stockWatchModel.marginalChange),
              Text(
                stockWatchModel.stockName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarginDifference extends StatelessWidget {
  const _MarginDifference({
    Key? key,
    required this.dp,
  }) : super(key: key);
  final double dp;
  @override
  Widget build(BuildContext context) {
    final IconData icon;
    if (dp == 0) {
      return Text('$dp %');
    } else if (dp > 0) {
      icon = Icons.arrow_drop_up;
    } else {
      icon = Icons.arrow_drop_down;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon), const Gap(2), Text('$dp %')],
    );
  }
}
