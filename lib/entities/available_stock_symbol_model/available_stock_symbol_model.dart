import 'package:json_annotation/json_annotation.dart';

part 'available_stock_symbol_model.g.dart';

@JsonSerializable()
class AvailableStockSymbolModel {
  String? description;
  String? symbol;

  AvailableStockSymbolModel({
    this.description,
    this.symbol,
  });

  factory AvailableStockSymbolModel.fromJson(Map<String, dynamic> json) {
    return _$AvailableStockSymbolModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AvailableStockSymbolModelToJson(this);
}
