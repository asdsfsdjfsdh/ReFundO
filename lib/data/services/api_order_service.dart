// 访问后端订单扫描数据
import 'package:dio/dio.dart';
import 'package:refundo/data/services/api_user_logic_service.dart';
import 'package:refundo/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrderService {
  Dio _dio = Dio();
  bool _isInitialized = false;

  List<OrderModel> _orders = [];

  ApiOrderService() {
    _initDio();
  }

  // // 初始化 dio 实例
  // void _initDio() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('access_token') ?? '';
  //   if (token != '') {
  //    try{
  //      Dio tempDio = await ApiUserLogicService().getDioInstance();
  //      if(_dio.options.baseUrl.isEmpty){
  //        _dio = tempDio;
  //      }
  //    }catch(e){
  //      print(e);
  //      _dio = Dio();
  //     _dio.options.baseUrl = 'http://10.0.2.2:4040';
  //     _dio.options.contentType = Headers.jsonContentType;
  //    }
  //   } else {
  //     _dio = Dio();
  //     _dio.options.baseUrl = 'http://10.0.2.2:4040';
  //     _dio.options.contentType = Headers.jsonContentType;
  //   }
  // }

  Future<void> _initDio() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('access_token') ?? '';
      if (token.isNotEmpty) {
        Dio tempDio = await ApiUserLogicService().getDioInstance();
        if (tempDio.options.baseUrl.isNotEmpty) {
          _dio = tempDio;
        } else {
          _dio.options.baseUrl = 'http://10.0.2.2:4040';
          _dio.options.contentType = Headers.jsonContentType;
        }
      } else {
        _dio.options.baseUrl = 'http://10.0.2.2:4040';
        _dio.options.contentType = Headers.jsonContentType;
      }
    } catch (e) {
      _dio.options.baseUrl = 'http://10.0.2.2:4040';
      _dio.options.contentType = Headers.jsonContentType;
      print('异步初始化失败: $e');
    } finally {
      _isInitialized = true;
    }
  }

  // 获取订单数
  Future<List<OrderModel>> getOrders() async {
    if (!_isInitialized) {
      await _initDio();
    }
    _orders = [];

    print(555);
    Response response = await _dio.post('/api/orders/init');
    // print(response);
    String message = response.data['message'];
    List<dynamic> ordersRequest = response.data['result'];
    for (var i = 0; i < ordersRequest.length; i++) {
      Map<String, dynamic> ordersresult = ordersRequest[i];
      OrderModel order = OrderModel.fromJson(ordersresult);
      _orders.add(order);
    }
    print(_orders);

    // for (var order in ordersRequest) {
    //   OrderModel.fromJson(order)
    // }

    // 暂时占位
    // List<OrderModel> orders = [
    //   OrderModel(
    //     ProductId: "1",
    //     price: 10,
    //     refundAmount: 3,
    //     OrderTime: DateTime.timestamp(),
    //     isRefund: false,
    //   ),
    //   OrderModel(
    //     ProductId: "2",
    //     price: 20,
    //     refundAmount: 3,
    //     OrderTime: DateTime.timestamp(),
    //     isRefund: false,
    //   ),
    //   OrderModel(
    //     ProductId: "3",
    //     price: 30,
    //     refundAmount: 3,
    //     OrderTime: DateTime.timestamp(),
    //     isRefund: true,
    //   ),
    //   OrderModel(
    //     ProductId: "4",
    //     price: 40,
    //     refundAmount: 3,
    //     OrderTime: DateTime.timestamp(),
    //     isRefund: true,
    //   ),
    // ];
    return _orders;
  }
}
