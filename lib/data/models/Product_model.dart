import 'package:decimal/decimal.dart';

class ProductModel{
  final int ProductId;
  final Decimal price;
  final Decimal RefundAmount;
  final String Hash;
  final double RefundPercent;

  ProductModel({
    required this.ProductId,
    required this.price,
    required this.RefundAmount,
    required this.Hash,
    required this.RefundPercent,
  });

  Map<String, dynamic> toJson() => {
    'ProductId': ProductId,
    'price': price,
    'RefundAmount': RefundAmount,
    'Hash': Hash,
    'RefundPercent': RefundPercent,
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    ProductId: json['ProductId'] as int ? ?? 0,
    price: Decimal.parse(json['price']?.toString() ?? '0') ,
    RefundAmount: Decimal.parse(json['RefundAmount']?.toString() ?? '0'),
    Hash: json['Hash'] as String ? ?? '',
    RefundPercent: json['RefundPercent'] as double ? ?? -1.0,
  );

 @override
  String toString() {
    return 'ProductModel{ProductId: $ProductId, price: $price, RefundAmount: $RefundAmount, Hash: $Hash, RefundPercent: $RefundPercent}';
  }

}