import 'package:designli_tech_test/entities/chart_data/chart_data.dart';
import 'package:designli_tech_test/providers/stock_watchlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockGraphView extends StatelessWidget {
  const StockGraphView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final stockWatchListProvider =
        Provider.of<StockWatchListProvider>(context, listen: false);
    final double watchListValue =
        stockWatchListProvider.calculateWatchListValue();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock WatchList Value'),
      ),
      body: SingleChildScrollView(
        child: SfCircularChart(
          title: ChartTitle(text: 'WatchList Value  \$$watchListValue'),
          legend: const Legend(
              shouldAlwaysShowScrollbar: true,
              position: LegendPosition.bottom,
              title: LegendTitle(text: 'Companies under WatchList'),
              isVisible: true,
              isResponsive: true,
              overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior:
              TooltipBehavior(enable: true, format: 'point.x: \$point.y'),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: stockWatchListProvider.getChartData(),
              xValueMapper: (datum, index) => datum.stockName,
              yValueMapper: (datum, index) => datum.value,
              dataLabelMapper: (datum, index) => datum.text,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
              innerRadius: '65%',
            )
          ],
        ),
      ),
    );
  }
}
