import 'package:flutter/material.dart';
import 'package:refundo/models/faq_model.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// FAQ展开项 - 支持展开/收起的FAQ项
class FaqExpansionItem extends StatelessWidget {
  final Faq faq;
  final String categoryName;
  final bool isExpanded;
  final VoidCallback onToggle;

  const FaqExpansionItem({
    super.key,
    required this.faq,
    required this.categoryName,
    required this.isExpanded,
    required this.onToggle,
  });

  Color _getCategoryColor() {
    // 根据categoryId返回不同颜色
    switch (faq.categoryId) {
      case 1:
        return const Color(0xFFEFF6FF); // 蓝色背景
      case 2:
        return const Color(0xFFF0FDF4); // 绿色背景
      case 3:
        return const Color(0xFFFEF3C7); // 黄色背景
      default:
        return const Color(0xFFF3F4F6); // 灰色背景
    }
  }

  Color _getCategoryBorderColor() {
    switch (faq.categoryId) {
      case 1:
        return const Color(0xFFBFDBFE);
      case 2:
        return const Color(0xFFBBF7D0);
      case 3:
        return const Color(0xFFFDE68A);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color _getCategoryTextColor() {
    switch (faq.categoryId) {
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
        return const Color(0xFF22C55E);
      case 3:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 标题部分
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (faq.isPinned) ...[
                    const Icon(
                      Icons.push_pin,
                      color: Color(0xFFEF4444),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFFECACA),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        l10n.faq_pinned,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      faq.question ?? '',
                      style: TextStyle(
                        fontSize: faq.isPinned ? 15 : 15,
                        fontWeight: faq.isPinned ? FontWeight.w600 : FontWeight.w500,
                        color: const Color(0xFF111827),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF6B7280),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // 展开的答案部分
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  faq.answer ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],

          // 底部元数据
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                if (categoryName.isNotEmpty && !faq.isPinned) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _getCategoryBorderColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCategoryTextColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                // 浏览量
                if (faq.viewCount != null) ...[
                  const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xFF9CA3AF),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${faq.viewCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
