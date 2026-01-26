import 'package:decimal/decimal.dart';

class ProductModel{
  final int ProductId;
  final Decimal Value;
  final Decimal OriginalPrice;
  final String Hash;
  final Decimal RefundRatio;
  final String errorMessage;
  final String successMessageKey;

  ProductModel({
    required this.ProductId,
    required this.Value,
    required this.OriginalPrice,
    required this.Hash,
    required this.RefundRatio,
    this.errorMessage = '',
    this.successMessageKey = '',
  });

  Map<String, dynamic> toJson() => {
    'ProductId': ProductId,
    'Value': Value,
    'RefundRatio': RefundRatio,
    'Hash': Hash,
    'OriginalPrice': OriginalPrice,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json, {String errorMessage = '', String successMessageKey = ''}) => ProductModel(
    ProductId: json['ProductId'] as int ? ?? 0,
    OriginalPrice: Decimal.parse(json['price']?.toString() ?? '0') ,
    Value: Decimal.parse(json['RefundAmount']?.toString() ?? '0'),
    Hash: json['Hash'] as String ? ?? '',
    RefundRatio: Decimal.parse(json['RefundPercent']?.toString() ?? '0'),
    errorMessage: errorMessage,
    successMessageKey: successMessageKey,
  );

 @override
  String toString() {
    return 'ProductModel{ProductId: $ProductId, Value: $Value, OriginalPrice: $OriginalPrice, Hash: $Hash, RefundRatio: $RefundRatio}';
  }

}