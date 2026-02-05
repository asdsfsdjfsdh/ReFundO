import 'package:decimal/decimal.dart';

class OrderModel {
  final int orderid;
  final String orderNumber;
  final String ProductId;
  final Decimal price;
  final Decimal refundAmount;
  final Decimal refundpercent;
  final String OrderTime;
  final bool isRefund;
  final bool refundState;
  final String refundTime;
  final String errorMessage;

  String get orderTime => OrderTime;

  OrderModel({
    required this.orderid,
    required this.orderNumber,
    required this.ProductId,
    required this.price,
    required this.refundAmount,
    required this.refundpercent,
    required this.OrderTime,
    this.isRefund = false,
    this.refundState = false,
    this.refundTime = '',
    this.errorMessage = '',
  });

  Map<String, dynamic> toJson() => {
    'scanId': orderid,
    'productId': ProductId,
    'originalPrice': price.toString(),
    'refundAmount': refundAmount.toString(),
    'refundPercent': refundpercent.toDouble(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // 辅助函数
    int getInt(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          if (value is int) return value;
          if (value is double) return value.toInt();
          if (value is String) return int.tryParse(value) ?? 0;
        }
      }
      return 0;
    }

    String getString(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
      return '';
    }

    Decimal getDecimal(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          try {
            return Decimal.parse(value.toString());
          } catch (e) {
            return Decimal.zero;
          }
        }
      }
      return Decimal.zero;
    }

    double getDouble(List<String> keys) {
      for (String key in keys) {
        final value = json[key];
        if (value != null) {
          if (value is double) return value;
          if (value is int) return value.toDouble();
          if (value is String) return double.tryParse(value) ?? 0.0;
        }
      }
      return 0.0;
    }

    int refundStatus = getInt(['refundStatus', 'RefundStatus', 'isRefund']);
    bool isRefundValue = refundStatus == 1;

    return OrderModel(
      orderid: getInt(['scanId', 'ScanId', 'orderid']),
      orderNumber: getString(['scanNumber', 'ScanNumber', 'orderNumber']),
      ProductId: getString(['productId', 'ProductId']),
      price: getDecimal(['originalPrice', 'OriginalPrice', 'price']),
      refundAmount: getDecimal(['value', 'Value', 'refundAmount']),
      refundpercent: Decimal.parse(getDouble(['refundRatio', 'RefundRatio']).toString()),
      OrderTime: getString(['scanTime', 'ScanTime', 'createTime']),
      isRefund: isRefundValue,
      refundState: json['refundState'] == true,
      refundTime: getString(['refundTime', 'updateTime']),
      errorMessage: getString(['errorMessage', 'message']),
    );
  }

  @override
  String toString() {
    return 'OrderModel{orderid: $orderid, orderNumber: $orderNumber, isRefund: $isRefund}';
  }
}
