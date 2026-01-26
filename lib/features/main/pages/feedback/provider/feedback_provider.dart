import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refundo/data/services/api_feedback_service.dart';
import 'package:refundo/models/feedback_model.dart';

/// 反馈功能的状态管理
class FeedbackProvider with ChangeNotifier {
  final ApiFeedbackService _service = ApiFeedbackService();

  // ========== 提交表单状态 ==========
  int _selectedType = 0; // 默认选中"问题"
  late final TextEditingController _contentController;
  late final TextEditingController _contactController;
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;
  bool _isUploadingImage = false;
  String? _errorMessage;

  // ========== 历史记录状态 ==========
  List<FeedbackModel> _feedbacks = [];
  bool _isLoadingHistory = false;

  /// 构造函数 - 初始化控制器并添加监听器
  FeedbackProvider() {
    _contentController = TextEditingController()
      ..addListener(() {
        // 内容变化时通知 UI 更新
        notifyListeners();
      });
    _contactController = TextEditingController()
      ..addListener(() {
        // 内容变化时通知 UI 更新
        notifyListeners();
      });
  }

  // ========== Getters ==========
  int get selectedType => _selectedType;
  TextEditingController get contentController => _contentController;
  TextEditingController get contactController => _contactController;
  File? get selectedImage => _selectedImage;
  String? get uploadedImageUrl => _uploadedImageUrl;
  bool get isSubmitting => _isSubmitting;
  bool get isUploadingImage => _isUploadingImage;
  String? get errorMessage => _errorMessage;
  List<FeedbackModel> get feedbacks => _feedbacks;
  bool get isLoadingHistory => _isLoadingHistory;

  /// 是否可以提交（内容至少10个字符）
  bool get canSubmit {
    return _contentController.text.trim().length >= 10 && !_isSubmitting && !_isUploadingImage;
  }

  /// 获取当前选中的反馈类型
  FeedbackType get selectedFeedbackType => FeedbackType.fromCode(_selectedType);

  // ========== 反馈类型相关 ==========

  /// 选择反馈类型
  void selectType(int type) {
    _selectedType = type;
    _errorMessage = null;
    notifyListeners();
  }

  // ========== 图片相关 ==========

  /// 选择图片
  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      _uploadedImageUrl = null; // 重置已上传的URL

      // 验证文件大小 (5MB = 5 * 1024 * 1024)
      final fileSize = await _selectedImage!.length();
      if (fileSize > 5 * 1024 * 1024) {
        _errorMessage = 'error_feedback_file_too_large';
        _selectedImage = null;
        notifyListeners();
        _showErrorSnackBar(context, 'error_feedback_file_too_large');
        return;
      }

      // 验证文件格式
      final path = pickedFile.path.toLowerCase();
      if (!path.endsWith('.jpg') &&
          !path.endsWith('.jpeg') &&
          !path.endsWith('.png')) {
        _errorMessage = 'error_feedback_file_format';
        _selectedImage = null;
        notifyListeners();
        _showErrorSnackBar(context, 'error_feedback_file_format');
        return;
      }

      _errorMessage = null;
      notifyListeners();
    }
  }

  /// 移除图片
  void removeImage() {
    _selectedImage = null;
    _uploadedImageUrl = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ========== 提交反馈 ==========

  /// 提交反馈
  Future<Map<String, dynamic>> submitFeedback(BuildContext context) async {
    if (!canSubmit) {
      return {'success': false, 'message': 'error_feedback_content_length'};
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 先上传图片（如果有）
      String? attachmentUrl;
      if (_selectedImage != null && _uploadedImageUrl == null) {
        _isUploadingImage = true;
        notifyListeners();

        final uploadResult = await _service.uploadAttachment(_selectedImage!, context);

        _isUploadingImage = false;

        if (uploadResult['success'] && uploadResult['data'] != null) {
          _uploadedImageUrl = uploadResult['data'] as String;
          attachmentUrl = _uploadedImageUrl;
        } else {
          _errorMessage = uploadResult['message'] ?? 'error_upload_failed';
          _isSubmitting = false;
          notifyListeners();
          _showErrorSnackBar(context, _errorMessage!);
          return {'success': false, 'message': _errorMessage};
        }
      } else if (_uploadedImageUrl != null) {
        attachmentUrl = _uploadedImageUrl;
      }

      // 提交反馈
      final result = await _service.submitFeedback(
        content: _contentController.text.trim(),
        feedbackType: _selectedType,
        contactInfo: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        attachmentUrl: attachmentUrl,
        context: context,
      );

      if (result['success']) {
        _resetForm();
        await getFeedbacks(context);
        _isSubmitting = false;
        notifyListeners();
        return {'success': true, 'message': result['message']};
      } else {
        _errorMessage = result['message'];
        _isSubmitting = false;
        notifyListeners();
        _showErrorSnackBar(context, _errorMessage!);
        return {'success': false, 'message': _errorMessage};
      }
    } catch (e) {
      print('提交反馈错误: $e');
      _errorMessage = 'unknown_error';
      _isSubmitting = false;
      _isUploadingImage = false;
      notifyListeners();
      _showErrorSnackBar(context, _errorMessage!);
      return {'success': false, 'message': _errorMessage};
    }
  }

  // ========== 历史记录相关 ==========

  /// 获取反馈列表
  Future<void> getFeedbacks(BuildContext context) async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      final result = await _service.getMyFeedbacks(context);
      if (result['success']) {
        // 按创建时间倒序排列
        _feedbacks = result['data'] as List<FeedbackModel>;
        _feedbacks.sort((a, b) => b.createTime.compareTo(a.createTime));
      } else {
        _feedbacks = [];
        _showErrorSnackBar(context, result['message'] ?? 'unknown_error');
      }
    } catch (e) {
      print('获取反馈列表错误: $e');
      _feedbacks = [];
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  /// 撤回反馈
  Future<bool> withdrawFeedback(int feedbackId, BuildContext context) async {
    final result = await _service.withdrawFeedback(feedbackId, context);

    if (result['success']) {
      // 刷新列表
      await getFeedbacks(context);
      return true;
    } else {
      _showErrorSnackBar(context, result['message'] ?? 'feedback_withdraw_failed');
      return false;
    }
  }

  // ========== 私有方法 ==========

  /// 重置表单
  void _resetForm() {
    _selectedType = 0;
    _contentController.clear();
    _contactController.clear();
    _selectedImage = null;
    _uploadedImageUrl = null;
    _errorMessage = null;
  }

  /// 显示错误提示
  void _showErrorSnackBar(BuildContext context, String messageKey) {
    if (context.mounted) {
      // 这里可以调用国际化获取实际文本，暂时使用key
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messageKey),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
