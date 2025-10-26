// 构建提现记录列表
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refundo/models/order_model.dart';
import 'package:refundo/models/refund_model.dart';

Widget refundWidget(List<OrderModel> models) {
  return ListView.builder(
    itemCount: models.length,
    itemBuilder: (context, index) {
      final order = models[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt, color: Colors.blue[700]),
          ),
          title: Text('返还金额: ${order.refundAmount}'),
          subtitle: Text('时间: ${order.OrderTime}'),
          trailing: Text(
            order.refundState.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ),
      );
    },
  );
}