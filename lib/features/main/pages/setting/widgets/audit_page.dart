// audit/audit_page.dart
import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  List<Map<String, dynamic>> _auditRecords = [];
  List<Map<String, dynamic>> _filteredRecords = [];
  bool _isLoading = false;

  // 筛选条件
  String _selectedTimeFilter = 'all'; // all, 1day, 1week, 1month
  String _selectedStatusFilter = 'all'; // all, pending, approved, rejected

  // 筛选选项
  late final Map<String, String> _timeFilters = {
    'all': AppLocalizations.of(context)!.all,
    '1day': AppLocalizations.of(context)!.one_day,
    '1week': AppLocalizations.of(context)!.one_week,
    '1month': AppLocalizations.of(context)!.one_month,
  };

  late final Map<String, String> _statusFilters = {
    'all': AppLocalizations.of(context)!.approved,
    'pending': AppLocalizations.of(context)!.pending,
    'approved': AppLocalizations.of(context)!.approve,
    'rejected': AppLocalizations.of(context)!.rejected,
  };

  @override
  void initState() {
    super.initState();
    _loadAuditRecords();
  }

  Future<void> _loadAuditRecords() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _auditRecords = [
        {
          'recordId': '1',
          'orderNumber': 'ORD20231215001',
          'refundTime': DateTime.now().subtract(const Duration(hours: 2)),
          'refundMethod': '银行转账',
          'refundAmount': 25.50,
          'userId': 'USER001',
          'nickname': '张三',
          'email': 'zhangsan@email.com',
          'status': 'pending',
        },
        {
          'recordId': '2',
          'orderNumber': 'ORD20231215002',
          'refundTime': DateTime.now().subtract(const Duration(hours: 5)),
          'refundMethod': '支付宝',
          'refundAmount': 18.75,
          'userId': 'USER002',
          'nickname': '李四',
          'email': 'lisi@email.com',
          'status': 'pending',
        },
        {
          'recordId': '3',
          'orderNumber': 'ORD20231215003',
          'refundTime': DateTime.now().subtract(const Duration(days: 3)),
          'refundMethod': '微信支付',
          'refundAmount': 42.30,
          'userId': 'USER003',
          'nickname': '王五',
          'email': 'wangwu@email.com',
          'status': 'approved',
        },
        {
          'recordId': '4',
          'orderNumber': 'ORD20231210001',
          'refundTime': DateTime.now().subtract(const Duration(days: 10)),
          'refundMethod': '银行转账',
          'refundAmount': 15.20,
          'userId': 'USER004',
          'nickname': '赵六',
          'email': 'zhaoliu@email.com',
          'status': 'rejected',
        },
        {
          'recordId': '5',
          'orderNumber': 'ORD20231120001',
          'refundTime': DateTime.now().subtract(const Duration(days: 25)),
          'refundMethod': '支付宝',
          'refundAmount': 33.80,
          'userId': 'USER005',
          'nickname': '钱七',
          'email': 'qianqi@email.com',
          'status': 'approved',
        },
      ];
      _applyFilters();
      _isLoading = false;
    });
  }

  // 应用筛选条件
  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_auditRecords);

    // 时间筛选
    if (_selectedTimeFilter != 'all') {
      DateTime now = DateTime.now();
      DateTime filterDate;

      switch (_selectedTimeFilter) {
        case '1day':
          filterDate = now.subtract(const Duration(days: 1));
          break;
        case '1week':
          filterDate = now.subtract(const Duration(days: 7));
          break;
        case '1month':
          filterDate = now.subtract(const Duration(days: 30));
          break;
        default:
          filterDate = now;
      }

      filtered = filtered.where((record) {
        return record['refundTime'].isAfter(filterDate);
      }).toList();
    }

    // 状态筛选
    if (_selectedStatusFilter != 'all') {
      filtered = filtered.where((record) {
        return record['status'] == _selectedStatusFilter;
      }).toList();
    }

    setState(() {
      _filteredRecords = filtered;
    });
  }

  // 重置筛选条件
  void _resetFilters() {
    setState(() {
      _selectedTimeFilter = 'all';
      _selectedStatusFilter = 'all';
      _applyFilters();
    });
  }

  Future<void> _approveRefund(String recordId) async {
    // TODO: 实现审批通过的实际API调用
    print('审批通过: $recordId');

    setState(() {
      final index = _auditRecords.indexWhere((record) => record['recordId'] == recordId);
      if (index != -1) {
        _auditRecords[index]['status'] = 'approved';
        _applyFilters(); // 重新应用筛选
      }
    });
  }

  Future<void> _rejectRefund(String recordId) async {
    // TODO: 实现拒绝审批的实际API调用
    print('拒绝审批: $recordId');

    setState(() {
      final index = _auditRecords.indexWhere((record) => record['recordId'] == recordId);
      if (index != -1) {
        _auditRecords[index]['status'] = 'rejected';
        _applyFilters(); // 重新应用筛选
      }
    });
  }

  // 显示详细信息悬浮窗
  void _showDetailDialog(BuildContext context, Map<String, dynamic> record) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题和关闭按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n!.detail_info,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 20),

                // 详细信息内容
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(l10n.user_id, record['userId']),
                        _buildDetailItem(l10n.nickname, record['nickname']),
                        _buildDetailItem(l10n.email, record['email']),
                        _buildDetailItem(l10n.order_number, record['orderNumber']),
                        _buildDetailItem(l10n.refund_time, _formatDateTime(record['refundTime'])),
                        _buildDetailItem(l10n.refund_method, record['refundMethod']),
                        _buildDetailItem(
                          l10n.refund_amount,
                          '\$${record['refundAmount'].toStringAsFixed(2)}',
                          isAmount: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // 操作按钮（仅待审批记录显示）
                if (record['status'] == 'pending')
                  _buildActionButtons(context, record)
                else
                  Center(
                    child: Text(
                      record['status'] == 'approved' ? l10n.already_approved : l10n.already_rejected,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: record['status'] == 'approved' ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
                fontSize: isAmount ? 18 : 16,
                color: isAmount ? Colors.green.shade700 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> record) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleApprove(context, record),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n!.approve,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _handleReject(context, record),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade600,
              side: BorderSide(color: Colors.red.shade600, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.reject,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleApprove(BuildContext context, Map<String, dynamic> record) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _approveRefund(record['recordId']);
      Navigator.of(context).pop(); // 关闭对话框
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n!.approve_success),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n!.approve_failed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleReject(BuildContext context, Map<String, dynamic> record) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _rejectRefund(record['recordId']);
      Navigator.of(context).pop(); // 关闭对话框
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n!.reject_success),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n!.reject_failed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      title: Text(
        l10n!.audit_page,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.purple.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 筛选工具栏
          _buildFilterToolbar(context),
          const SizedBox(height: 16),


          // 审核记录列表
          Expanded(
            child: _filteredRecords.isEmpty
                ? _buildEmptyState(context)
                : _buildAuditList(context),
          ),
        ],
      ),
    );
  }

  // 构建筛选工具栏
  Widget _buildFilterToolbar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_alt_rounded, color: Colors.purple.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n!.filter_conditions,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // 时间筛选
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n!.time_range,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTimeFilter,
                            isExpanded: true,
                            items: _timeFilters.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(entry.value),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTimeFilter = newValue!;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 状态筛选
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n!.approval_status,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatusFilter,
                            isExpanded: true,
                            items: _statusFilters.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.key,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(entry.value),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStatusFilter = newValue!;
                                _applyFilters();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 重置按钮
                Column(
                  children: [
                    const SizedBox(height: 20), // 用于对齐
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: _resetFilters,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(l10n!.reset),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 筛选结果统计
            Text(
              '${_filteredRecords.length} ${AppLocalizations.of(context)!.items}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            l10n!.no_records_found,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n!.adjust_filters,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n!.reset),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditList(BuildContext context) {
    return ListView.separated(
      itemCount: _filteredRecords.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = _filteredRecords[index];
        return _buildAuditListItem(context, record);
      },
    );
  }

  Widget _buildAuditListItem(BuildContext context, Map<String, dynamic> record) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _buildStatusIcon(record['status']),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              record['orderNumber'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            _buildStatusBadge(record['status']),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    record['nickname'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.email, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    record['email'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(record['refundTime']),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.payment, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    record['refundMethod'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.refund_amount,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  Text(
                    '\$${record['refundAmount'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showDetailDialog(context, record),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'approved':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'rejected':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.pending;
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusBadge(String status) {
    final l10n = AppLocalizations.of(context);
    String text;
    Color color;

    switch (status) {
      case 'approved':
        text = l10n!.approved;
        color = Colors.green;
        break;
      case 'rejected':
        text = l10n!.rejected;
        color = Colors.red;
        break;
      default:
        text = l10n!.pending;
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}