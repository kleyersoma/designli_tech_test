import 'package:json_annotation/json_annotation.dart';

part 'quote_stock_model.g.dart';

@JsonSerializable()
class QuoteStockModel {
  final double? c;
  final double? dp;

  const QuoteStockModel({
    this.c,
    this.dp,
  });

  factory QuoteStockModel.fromJson(Map<String, dynamic> json) {
    return _$QuoteStockModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$QuoteStockModelToJson(this);
}
