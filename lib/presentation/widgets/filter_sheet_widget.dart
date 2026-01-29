import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 筛选底部弹窗
/// 用于订单和退款列表的多条件筛选
class FilterSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final Map<String, dynamic> initialFilters;

  const FilterSheetWidget({
    Key? key,
    required this.onApply,
    this.initialFilters = const {},
  }) : super(key: key);

  @override
  State<FilterSheetWidget> createState() => _FilterSheetWidgetState();
}

class _FilterSheetWidgetState extends State<FilterSheetWidget> {
  String _selectedDateRange = 'all';
  String _selectedStatus = 'all';
  String _selectedSort = 'date_desc';

  // 日期范围选项
  final List<Map<String, dynamic>> _dateRangeOptions = [
    {'value': 'all', 'label': '全部', 'icon': Icons.apps},
    {'value': 'today', 'label': '今天', 'icon': Icons.today},
    {'value': 'week', 'label': '本周', 'icon': Icons.date_range},
    {'value': 'month', 'label': '本月', 'icon': Icons.calendar_month},
    {'value': 'custom', 'label': '自定义', 'icon': Icons.edit_calendar},
  ];

  // 状态选项
  final List<Map<String, dynamic>> _statusOptions = [
    {'value': 'all', 'label': '全部状态', 'color': Colors.grey},
    {'value': 'pending', 'label': '待处理', 'color': Colors.orange},
    {'value': 'approved', 'label': '已批准', 'color': Colors.green},
    {'value': 'rejected', 'label': '已拒绝', 'color': Colors.red},
  ];

  // 排序选项
  final List<Map<String, dynamic>> _sortOptions = [
    {'value': 'date_desc', 'label': '最新优先'},
    {'value': 'date_asc', 'label': '最早优先'},
    {'value': 'amount_desc', 'label': '金额从高到低'},
    {'value': 'amount_asc', 'label': '金额从低到高'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          _buildHeader(context, l10n),
          const Divider(height: 1),

          // 筛选选项
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期范围选择
                  _buildSectionTitle(l10n!.date_range),
                  const SizedBox(height: 12),
                  _buildDateRangeChips(),
                  const SizedBox(height: 24),

                  // 状态筛选
                  _buildSectionTitle(l10n.status),
                  const SizedBox(height: 12),
                  _buildStatusChips(),
                  const SizedBox(height: 24),

                  // 排序方式
                  _buildSectionTitle(l10n.sort_by),
                  const SizedBox(height: 12),
                  _buildSortOptions(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 底部按钮
          _buildBottomButtons(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Text(
            l10n!.filter,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildDateRangeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _dateRangeOptions.map((option) {
        final isSelected = _selectedDateRange == option['value'];
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option['icon'],
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(option['label']),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedDateRange = option['value'];
            });
          },
          selectedColor: Colors.blue.shade600,
          checkmarkColor: Colors.white,
          backgroundColor: Colors.grey.shade100,
        );
      }).toList(),
    );
  }

  Widget _buildStatusChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _statusOptions.map((option) {
        final isSelected = _selectedStatus == option['value'];
        return FilterChip(
          label: Text(option['label']),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedStatus = option['value'];
            });
          },
          selectedColor: option['color'],
          checkmarkColor: Colors.white,
          backgroundColor: Colors.grey.shade100,
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: _sortOptions.map((option) {
        final isSelected = _selectedSort == option['value'];
        return RadioListTile<String>(
          title: Text(option['label']),
          value: option['value'],
          groupValue: _selectedSort,
          onChanged: (value) {
            setState(() {
              _selectedSort = value!;
            });
          },
          activeColor: Colors.blue.shade600,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons(BuildContext context, AppLocalizations? l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _resetFilters(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n!.reset),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => _applyFilters(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.apply),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedDateRange = 'all';
      _selectedStatus = 'all';
      _selectedSort = 'date_desc';
    });
  }

  void _applyFilters() {
    final filters = {
      'dateRange': _selectedDateRange,
      'status': _selectedStatus,
      'sort': _selectedSort,
    };
    widget.onApply(filters);
    Navigator.of(context).pop();
  }
}

/// 显示筛选底部弹窗
void showFilterSheet({
  required BuildContext context,
  required Function(Map<String, dynamic>) onApply,
  Map<String, dynamic> initialFilters = const {},
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterSheetWidget(
      onApply: onApply,
      initialFilters: initialFilters,
    ),
  );
}
