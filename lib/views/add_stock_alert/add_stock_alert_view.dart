import 'package:designli_tech_test/api/api_key.default.dart';
import 'package:designli_tech_test/api/finnhub_api.dart';
import 'package:designli_tech_test/entities/available_stock_symbol_model/available_stock_symbol_model.dart';
import 'package:designli_tech_test/providers/stock_watchlist_provider.dart';
import 'package:designli_tech_test/repositories/finnhub_repository.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AddStockAlertView extends StatelessWidget {
  const AddStockAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock Alert'),
      ),
      body: const Center(
        child: FormStockAlert(),
      ),
    );
  }
}

class FormStockAlert extends StatefulWidget {
  const FormStockAlert({super.key});

  @override
  State<FormStockAlert> createState() => _FormStockAlertState();
}

class _FormStockAlertState extends State<FormStockAlert> {
  late Future<List<AvailableStockSymbolModel>> futureAvailableStockList;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureAvailableStockList =
        FinnHubRepository(api: FinnHubAPI(APIKeys.finnHubAPIKey))
            .listAvailableStocks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AvailableStockSymbolModel>>(
      future: futureAvailableStockList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: 200,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _CustomDropdownButtonAvailableStocks(
                    availableStockList: snapshot.requireData,
                  ),
                  const _TextFormFieldPriceAlert(),
                  const Gap(12),
                  _TextButtonAddStockAlert(formKey: _formKey)
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class _TextButtonAddStockAlert extends StatefulWidget {
  const _TextButtonAddStockAlert({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  State<_TextButtonAddStockAlert> createState() =>
      _TextButtonAddStockAlertState();
}

class _TextButtonAddStockAlertState extends State<_TextButtonAddStockAlert> {
  @override
  Widget build(BuildContext context) {
    final stockWatchListProvider =
        Provider.of<StockWatchListProvider>(context, listen: false);
    return TextButton.icon(
        onPressed: () async {
          if (widget._formKey.currentState!.validate()) {
            // Add Stock Alert
            widget._formKey.currentState!.save();
            await stockWatchListProvider.addStockToWatchList();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Price alert has been added"),
                behavior: SnackBarBehavior.floating,
              ));
              Navigator.pop(context);
            }
          }
        },
        icon: const Icon(Icons.add_alert),
        label: const Text('Add Alert'));
  }
}

class _TextFormFieldPriceAlert extends StatelessWidget {
  const _TextFormFieldPriceAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stockWatchListProvider =
        Provider.of<StockWatchListProvider>(context, listen: false);
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
        }
        return null;
      },
      onSaved: (newValue) {
        stockWatchListProvider.priceAlert = double.parse(newValue!);
      },
      decoration: const InputDecoration(
        prefixText: '\$',
        labelText: 'Price Alert',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class _CustomDropdownButtonAvailableStocks extends StatelessWidget {
  const _CustomDropdownButtonAvailableStocks(
      {super.key, required this.availableStockList});
  final List<AvailableStockSymbolModel> availableStockList;

  Widget build(BuildContext context) {
    final StockWatchListProvider stockWatchListProvider =
        Provider.of<StockWatchListProvider>(context, listen: false);
    return FormField<AvailableStockSymbolModel>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (newValue) =>
          stockWatchListProvider.availableStockSymbolModel = newValue!,
      validator: (value) {
        if (value == null) {
          return 'Please select a Stock Symbol';
        }
        return null;
      },
      builder: (field) => InkWell(
        onTap: () => showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              scrollable: false,
              content: SizedBox(
                height: 256,
                width: 256,
                child: ListView.builder(
                  itemCount: availableStockList.length,
                  cacheExtent: 256,
                  itemExtent: 32,
                  itemBuilder: (context, index) {
                    final availableStock = availableStockList.elementAt(index);
                    return InkWell(
                        onTap: () {
                          field.didChange(availableStock);
                          Navigator.pop(context);
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(availableStock.symbol!)));
                  },
                ),
              ),
            );
          },
        ),
        child: SizedBox(
          height: 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    field.value?.symbol ?? 'Choose a Stock',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
              const Gap(4),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade800),
                )
            ],
          ),
        ),
      ),
    );
  }
}
