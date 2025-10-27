// 构建订单列表
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/refund_provider.dart';
import 'package:refundo/models/order_model.dart';

class OrderWidget extends StatefulWidget {
  final List<OrderModel> models;
  bool isrefunding;
  OrderWidget({super.key, required this.models, required this.isrefunding});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Map<int, bool> isSelected = {};
  bool get isAllSelected => isSelected.values.every((selected) => selected);

  // 清除当前订单选择
  @override
  void didUpdateWidget(covariant OrderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    var refundProvider = Provider.of<RefundProvider>(context, listen: false);
    if (oldWidget.isrefunding != widget.isrefunding) {
      isSelected.clear();
      for (var element in widget.models) {
        isSelected[element.orderid] = false;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var element in widget.models) {
          refundProvider.removeOrder(element.orderid);
        }
      });
    }
  }

  @override
  void dispose() {
    isSelected.clear();
    super.dispose();
  }

  // 订单全选控制方法
  void _toggleSelectAll() {
    setState(() {
      final shouldSelectAll = !isAllSelected;
      isSelected.updateAll((key, value) => shouldSelectAll);
    });
    if (isAllSelected) {
      for (var element in widget.models) {
        Provider.of<RefundProvider>(context, listen: false).addOrder(element);
      }
    } else {
      for (var element in widget.models) {
        Provider.of<RefundProvider>(
          context,
          listen: false,
        ).removeOrder(element.orderid);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    print(widget.models.length);
    return Column(
      children: [
        if (widget.isrefunding)
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isAllSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isAllSelected ? Colors.green[300] : Colors.grey[300],
                  ),
                  onPressed: _toggleSelectAll,
                ),
                Text('全选'),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.models.length,
            itemBuilder: (context, index) {
              final order = widget.models[index];
              return Stack(
                children: [
                  Row(
                    children: [
                      widget.isrefunding
                          ? Expanded(
                              flex: 1,
                              child: Container(
                                height: 40,
                                color: Colors.white,
                                child: !(isSelected[order.orderid] ?? false)
                                    ? IconButton(
                                        icon: Icon(Icons.circle_outlined),
                                        color: Colors.grey[300],
                                        onPressed: () {
                                          setState(() {
                                            isSelected[order.orderid] = true;
                                          });
                                          final refundProvider =
                                              Provider.of<RefundProvider>(
                                                context,
                                                listen: false,
                                              );

                                          refundProvider.addOrder(order);
                                          print('删除订单');
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.check_circle),
                                        color: Colors.green[300],
                                        onPressed: () {
                                          setState(() {
                                            isSelected[order.orderid] = false;
                                          });
                                          final refundProvider =
                                              Provider.of<RefundProvider>(
                                                context,
                                                listen: false,
                                              );
                                          refundProvider.removeOrder(
                                            order.orderid,
                                          );

                                          print('删除订单');
                                        },
                                      ),
                              ),
                            )
                          : SizedBox(),
                      Expanded(
                        flex: 9,
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.receipt,
                                color: Colors.blue[700],
                              ),
                            ),
                            title: Text('订单号: ${order.orderid}'),
                            subtitle: Text('时间: ${order.OrderTime}'),
                            trailing: Text(
                              order.refundAmount.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
