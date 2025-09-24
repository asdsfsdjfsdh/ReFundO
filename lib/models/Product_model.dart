class ProductModel{
  final String ProductId;
  final double price;
  final double RefundAmount;
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
    ProductId: json['ProductId'],
    price: json['price'],
    RefundAmount: json['RefundAmount'],
    Hash: json['Hash'],
    RefundPercent: json['RefundPercent'],
  );

 @override
  String toString() {
    return 'ProductModel{ProductId: $ProductId, price: $price, RefundAmount: $RefundAmount, Hash: $Hash, RefundPercent: $RefundPercent}';
  }

}