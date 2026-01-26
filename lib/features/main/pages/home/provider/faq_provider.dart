import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refundo/data/services/api_faq_service.dart';
import 'package:refundo/models/faq_model.dart';
import 'package:refundo/models/faq_category_model.dart';

// FAQ的provider方法
class FaqProvider with ChangeNotifier {
  List<Faq>? _faqs;
  List<FaqCategory>? _categories;
  List<Faq>? _filteredFaqs;
  Faq? _selectedFaq;
  int? _selectedCategoryId;
  bool _isLoading = false;
  String? _errorMessage;
  final Set<int> _expandedFaqIds = {};

  ApiFaqService _faqService = ApiFaqService();

  List<Faq>? get faqs => _faqs;
  List<FaqCategory>? get categories => _categories;
  List<Faq>? get filteredFaqs => _filteredFaqs;
  Faq? get selectedFaq => _selectedFaq;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 检查FAQ是否展开
  bool isFaqExpanded(int faqId) => _expandedFaqIds.contains(faqId);

  // 获取所有FAQ
  Future<void> getAllFaqs(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _faqService.getAllFaqs(context);
      if (result['success'] == true) {
        _faqs = result['data'] as List<Faq>;
        _filteredFaqs = _faqs;
      } else {
        _faqs = [];
        _filteredFaqs = [];
        _errorMessage = result['message'] as String?;
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取FAQ失败: $e");
      }
      _faqs = [];
      _filteredFaqs = [];
      _errorMessage = 'unknown_error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 根据分类获取FAQ
  Future<void> getFaqsByCategory(BuildContext context, int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedCategoryId = categoryId;
    notifyListeners();

    try {
      final result = await _faqService.getFaqsByCategory(context, categoryId);
      if (result['success'] == true) {
        _faqs = result['data'] as List<Faq>;
        _filteredFaqs = _faqs;
      } else {
        _faqs = [];
        _filteredFaqs = [];
        _errorMessage = result['message'] as String?;
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取分类FAQ失败: $e");
      }
      _faqs = [];
      _filteredFaqs = [];
      _errorMessage = 'unknown_error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 获取单个FAQ详情
  Future<void> getFaqById(BuildContext context, int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _faqService.getFaqById(context, id);
      if (result['success'] == true) {
        _selectedFaq = result['data'] as Faq;
      } else {
        _selectedFaq = null;
        _errorMessage = result['message'] as String?;
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取FAQ详情失败: $e");
      }
      _selectedFaq = null;
      _errorMessage = 'unknown_error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 获取所有FAQ分类
  Future<void> getAllCategories(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _faqService.getAllCategories(context);
      if (result['success'] == true) {
        _categories = result['data'] as List<FaqCategory>;
      } else {
        _categories = [];
        _errorMessage = result['message'] as String?;
      }
    } catch (e) {
      if (kDebugMode) {
        print("获取FAQ分类失败: $e");
      }
      _categories = [];
      _errorMessage = 'unknown_error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 搜索FAQ
  void searchFaqs(String query) {
    if (query.isEmpty) {
      _filteredFaqs = _faqs;
    } else {
      _filteredFaqs = _faqs?.where((faq) {
        final question = faq.question?.toLowerCase() ?? '';
        final answer = faq.answer?.toLowerCase() ?? '';
        return question.contains(query.toLowerCase()) ||
            answer.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // 清除选择的分类
  void clearSelectedCategory() {
    _selectedCategoryId = null;
    _filteredFaqs = _faqs;
    notifyListeners();
  }

  // 清除FAQ数据
  void clearFaqs() {
    _faqs = [];
    _filteredFaqs = [];
    _categories = [];
    _selectedFaq = null;
    _selectedCategoryId = null;
    _errorMessage = null;
    notifyListeners();
  }

  // 增加FAQ浏览量
  void incrementViewCount(int faqId) {
    final faqIndex = _faqs?.indexWhere((f) => f.id == faqId);
    if (faqIndex != null && faqIndex >= 0) {
      final currentCount = _faqs![faqIndex].viewCount ?? 0;
      _faqs![faqIndex] = Faq(
        id: _faqs![faqIndex].id,
        categoryId: _faqs![faqIndex].categoryId,
        question: _faqs![faqIndex].question,
        answer: _faqs![faqIndex].answer,
        viewCount: currentCount + 1,
        isTop: _faqs![faqIndex].isTop,
        status: _faqs![faqIndex].status,
        createTime: _faqs![faqIndex].createTime,
        updateTime: _faqs![faqIndex].updateTime,
      );
      notifyListeners();
    }
  }

  // 获取置顶FAQ
  List<Faq> get pinnedFaqs {
    return _faqs?.where((faq) => faq.isPinned).toList() ?? [];
  }

  // 获取热门FAQ (按浏览量排序)
  List<Faq> get popularFaqs {
    final sorted = List<Faq>.from(_faqs ?? []);
    sorted.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
    return sorted.take(5).toList();
  }

  // 切换FAQ展开/收起状态
  void toggleFaqExpanded(int faqId) {
    if (_expandedFaqIds.contains(faqId)) {
      _expandedFaqIds.remove(faqId);
    } else {
      _expandedFaqIds.add(faqId);
    }
    notifyListeners();
  }

  // 展开指定FAQ
  void expandFaq(int faqId) {
    _expandedFaqIds.add(faqId);
    notifyListeners();
  }

  // 收起指定FAQ
  void collapseFaq(int faqId) {
    _expandedFaqIds.remove(faqId);
    notifyListeners();
  }

  // 收起所有FAQ
  void collapseAll() {
    _expandedFaqIds.clear();
    notifyListeners();
  }
}
