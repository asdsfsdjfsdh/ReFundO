import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 搜索栏组件
/// 用于订单和退款列表的搜索功能
class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final bool enabled;

  const SearchBarWidget({
    Key? key,
    required this.onSearch,
    required this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_isSearching) {
      widget.onSearch(_controller.text);
    }
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              onChanged: (value) {
                setState(() {
                  _isSearching = value.isNotEmpty;
                });
                // 实时搜索（可选）
                // widget.onSearch(value);
              },
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (_isSearching)
            IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: _clearSearch,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
