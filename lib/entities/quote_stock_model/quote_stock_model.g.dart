// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteStockModel _$QuoteStockModelFromJson(Map<String, dynamic> json) =>
    QuoteStockModel(
      c: (json['c'] as num?)?.toDouble(),
      dp: (json['dp'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$QuoteStockModelToJson(QuoteStockModel instance) =>
    <String, dynamic>{
      'c': instance.c,
      'dp': instance.dp,
    };
