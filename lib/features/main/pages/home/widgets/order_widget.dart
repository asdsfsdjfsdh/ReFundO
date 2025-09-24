// 构建订单列表
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refundo/models/order_model.dart';

Widget orderWidget(List<OrderModel> models) {
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
          title: Text('订单号: ${order.id}'),
          subtitle: Text('时间: ${order.timestamp}'),
          trailing: Text(
            order.refundAmount.toString(),
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