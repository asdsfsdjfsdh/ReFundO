import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/home/provider/faq_provider.dart';
import 'package:refundo/features/main/pages/faq/widgets/faq_category_chip.dart';
import 'package:refundo/features/main/pages/faq/widgets/faq_expansion_item.dart';
import 'package:refundo/features/main/pages/faq/widgets/faq_search_bar.dart';
import 'package:refundo/features/main/pages/faq/widgets/faq_empty_state.dart';
import 'package:refundo/models/faq_model.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// FAQ页面 - 帮助中心
class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // 页面加载时获取FAQ和分类数据
    Future.microtask(() {
      if (mounted) {
        context.read<FaqProvider>().getAllCategories(context);
        context.read<FaqProvider>().getAllFaqs(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<FaqProvider>().searchFaqs(query);
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      if (_selectedCategoryId == categoryId) {
        _selectedCategoryId = null;
        context.read<FaqProvider>().clearSelectedCategory();
      } else {
        _selectedCategoryId = categoryId;
        if (categoryId == null) {
          context.read<FaqProvider>().clearSelectedCategory();
        } else {
          context.read<FaqProvider>().getFaqsByCategory(context, categoryId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(l10n.faq_title),
        backgroundColor: const Color(0xFFF5F7FA),
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<FaqProvider>(
        builder: (context, faqProvider, child) {
          if (faqProvider.isLoading && faqProvider.faqs == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            );
          }

          return Column(
            children: [
              // 搜索栏区域
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: FaqSearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
              ),

              // 分类区域
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildCategorySection(faqProvider, l10n),
              ),

              const Divider(height: 1, color: Color(0xFFE5E7EB)),

              // FAQ列表
              Expanded(
                child: _buildFaqList(faqProvider, l10n),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(FaqProvider faqProvider, AppLocalizations l10n) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (faqProvider.categories?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // "全部"选项
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FaqCategoryChip(
                label: l10n.faq_all,
                isSelected: _selectedCategoryId == null,
                onTap: () => _onCategorySelected(null),
              ),
            );
          }

          final category = faqProvider.categories![index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FaqCategoryChip(
              label: category.categoryName ?? 'Unknown',
              isSelected: _selectedCategoryId == category.id,
              onTap: () => _onCategorySelected(category.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqList(FaqProvider faqProvider, AppLocalizations l10n) {
    final faqs = faqProvider.filteredFaqs ?? [];

    if (faqs.isEmpty) {
      return FaqEmptyState(
        onContactSupport: () {
          Navigator.pushNamed(context, '/feedback');
        },
      );
    }

    // 分离置顶和普通FAQ
    final pinnedFaqs = faqs.where((faq) => faq.isPinned).toList();
    final regularFaqs = faqs.where((faq) => !faq.isPinned).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: pinnedFaqs.length + regularFaqs.length,
      itemBuilder: (context, index) {
        final Faq faq;

        if (index < pinnedFaqs.length) {
          faq = pinnedFaqs[index];
        } else {
          faq = regularFaqs[index - pinnedFaqs.length];
        }

        // 获取分类名称
        final categoryName = _getCategoryName(faqProvider, faq.categoryId);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FaqExpansionItem(
            faq: faq,
            categoryName: categoryName,
            isExpanded: faqProvider.isFaqExpanded(faq.id ?? 0),
            onToggle: () {
              faqProvider.toggleFaqExpanded(faq.id ?? 0);
              faqProvider.incrementViewCount(faq.id ?? 0);
            },
          ),
        );
      },
    );
  }

  String _getCategoryName(FaqProvider faqProvider, int? categoryId) {
    if (categoryId == null) return '';
    if (faqProvider.categories == null || faqProvider.categories!.isEmpty) {
      return '';
    }
    try {
      final category = faqProvider.categories!.firstWhere(
        (cat) => cat.id == categoryId,
      );
      return category.categoryName ?? '';
    } catch (e) {
      // 找不到匹配的分类
      return '';
    }
  }
}
