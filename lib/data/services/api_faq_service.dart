// FAQ API Service
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/models/faq_model.dart';
import 'package:refundo/models/faq_category_model.dart';

class ApiFaqService {
  // 获取所有FAQ
  Future<Map<String, dynamic>> getAllFaqs(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<Faq> faqs = [];

      Response response = await dioProvider.dio.get('/api/faq/all');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> faqList = responseData['data'];
        for (var i = 0; i < faqList.length; i++) {
          Map<String, dynamic> faqData = faqList[i];
          Faq faq = Faq.fromJson(faqData);
          faqs.add(faq);
        }
        return {'success': true, 'data': faqs, 'message': 'get_faqs_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_faqs_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print("Dio错误详情: ${e.message}");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': [], 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }

  // 根据分类获取FAQ
  Future<Map<String, dynamic>> getFaqsByCategory(
      BuildContext context, int categoryId) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<Faq> faqs = [];

      Response response =
          await dioProvider.dio.get('/api/faq/category/$categoryId');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> faqList = responseData['data'];
        for (var i = 0; i < faqList.length; i++) {
          Map<String, dynamic> faqData = faqList[i];
          Faq faq = Faq.fromJson(faqData);
          faqs.add(faq);
        }
        return {'success': true, 'data': faqs, 'message': 'get_faqs_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_faqs_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': [], 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }

  // 根据ID获取单个FAQ详情
  Future<Map<String, dynamic>> getFaqById(BuildContext context, int id) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );

      Response response = await dioProvider.dio.get('/api/faq/$id');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        Faq faq = Faq.fromJson(responseData['data']);
        return {'success': true, 'data': faq, 'message': 'get_faq_success'};
      } else {
        return {'success': false, 'data': null, 'message': message ?? 'get_faq_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': null, 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': null, 'message': 'unknown_error'};
    }
  }

  // 获取所有FAQ分类
  Future<Map<String, dynamic>> getAllCategories(BuildContext context) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<FaqCategory> categories = [];

      Response response =
          await dioProvider.dio.get('/api/faq-category/all');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      // 调试：打印原始响应数据
      print('=== FAQ分类原始响应 ===');
      print('Response: ${response.data}');
      print('Code: $code');
      print('Data: ${responseData['data']}');

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> categoryList = responseData['data'];
        print('分类数量: ${categoryList.length}');
        for (var i = 0; i < categoryList.length; i++) {
          Map<String, dynamic> categoryData = categoryList[i];
          print('分类[$i]原始数据: $categoryData');
          FaqCategory category = FaqCategory.fromJson(categoryData);
          print('分类[$i]解析后: id=${category.id}, name=${category.categoryName}');
          categories.add(category);
        }
        return {'success': true, 'data': categories, 'message': 'get_categories_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_categories_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      print('Dio错误: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': [], 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }

  // 根据ID获取分类详情
  Future<Map<String, dynamic>> getCategoryById(
      BuildContext context, int id) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );

      Response response = await dioProvider.dio.get('/api/faq-category/$id');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        FaqCategory category = FaqCategory.fromJson(responseData['data']);
        return {'success': true, 'data': category, 'message': 'get_category_success'};
      } else {
        return {'success': false, 'data': null, 'message': message ?? 'get_category_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': null, 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': null, 'message': 'unknown_error'};
    }
  }

  // 获取子分类
  Future<Map<String, dynamic>> getSubCategories(
      BuildContext context, int parentId) async {
    try {
      DioProvider dioProvider = Provider.of<DioProvider>(
        context,
        listen: false,
      );
      List<FaqCategory> categories = [];

      Response response =
          await dioProvider.dio.get('/api/faq-category/sub/$parentId');

      final Map<String, dynamic> responseData = response.data;
      int code = responseData['code'] as int? ?? 0;
      String? message = responseData['message'];

      if (code == 1 && responseData['data'] != null) {
        List<dynamic> categoryList = responseData['data'];
        for (var i = 0; i < categoryList.length; i++) {
          Map<String, dynamic> categoryData = categoryList[i];
          FaqCategory category = FaqCategory.fromJson(categoryData);
          categories.add(category);
        }
        return {'success': true, 'data': categories, 'message': 'get_categories_success'};
      } else {
        return {'success': false, 'data': [], 'message': message ?? 'get_categories_failed'};
      }
    } on DioException catch (e) {
      String message = 'network_error';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'network_timeout';
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          message = "server_error_404";
        } else if (statusCode == 500) {
          message = 'server_error_500';
        }
      }
      return {'success': false, 'data': [], 'message': message};
    } catch (e) {
      print('未知错误: $e');
      return {'success': false, 'data': [], 'message': 'unknown_error'};
    }
  }
}
