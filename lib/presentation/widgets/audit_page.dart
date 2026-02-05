// audit/audit_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/showToast.dart';
// import 'package:refundo/presentation/providers/approval_provider.dart';
import 'package:refundo/presentation/providers/refund_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/data/models/refund_model.dart';

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  List<RefundModel>? _refunds = [];
  List<RefundModel> _filteredRecords = [];
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
    'all': AppLocalizations.of(context)!.all,
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
      _refunds = Provider.of<RefundProvider>(context, listen: false).refunds ?? [];
      _applyFilters();
      _isLoading = false;
    });
  }

  // 应用筛选条件
  void _applyFilters() {
    List<RefundModel> filtered = List.from(_refunds ?? []);

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

      filtered = filtered.where((refund) {
        try {
          DateTime refundTime = DateTime.parse(refund.timestamp);
          return refundTime.isAfter(filterDate);
        } catch (e) {
          return false;
        }
      }).toList();
    }

    // 状态筛选
    if (_selectedStatusFilter != 'all') {
      filtered = filtered.where((refund) {
        String statusString = _getStatusString(refund.refundState);
        return statusString == _selectedStatusFilter;
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

  Future<void> _approveRefund(RefundModel? refund_approval ) async {
    // 审批功能已迁移至 ruoyi 后台管理系统
    ShowToast.showCenterToast(context, "Approval feature moved to admin panel");
  }

  Future<void> _rejectRefund(RefundModel refund_approval) async {
    // 审批功能已迁移至 ruoyi 后台管理系统
    ShowToast.showCenterToast(context, "Approval feature moved to admin panel");
  }

  // 显示详细信息悬浮窗
  void _showDetailDialog(BuildContext context, RefundModel refund) {
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
                        _buildDetailItem(l10n.user_id, refund.userId.toString()),
                        _buildDetailItem(l10n.nickname, refund.nickName),
                        _buildDetailItem(l10n.email, refund.email),
                        _buildDetailItem(l10n.order_number, refund.orderNumber),
                        _buildDetailItem(l10n.refund_time, refund.timestamp),
                        _buildDetailItem(l10n.refund_method, refund.get_refundMethod(context)),
                        _buildDetailItem(
                          l10n.refund_amount,
                          '${refund.refundAmount.toStringAsFixed(2)} FCFA',
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
                if (refund.refundState == RefundStates.padding)
                  _buildActionButtons(context, refund)
                else
                  Center(
                    child: Text(
                      refund.refundState == RefundStates.success ? l10n.already_approved : l10n.already_rejected,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: refund.refundState == RefundStates.success ? Colors.green : Colors.red,
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

  Widget _buildActionButtons(BuildContext context, RefundModel refund) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleApprove(context, refund),
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
            onPressed: () => _handleReject(context, refund),
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

  Future<void> _handleApprove(BuildContext context, RefundModel refund) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _approveRefund(refund);
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

  Future<void> _handleReject(BuildContext context, RefundModel refund) async {
    final l10n = AppLocalizations.of(context);

    try {
      await _rejectRefund(refund);
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
        final refund = _filteredRecords[index];
        return _buildAuditListItem(context, refund);
      },
    );
  }

  Widget _buildAuditListItem(BuildContext context, RefundModel refund) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: _buildStatusIcon(_getStatusString(refund.refundState)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              refund.orderId.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            _buildStatusBadge(_getStatusString(refund.refundState)),
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
                    refund.nickName,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    refund.email,
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
                    refund.timestamp,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.payment, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    refund.refundMethod.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    refund.get_refundMethod(context),
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  Text(
                    '${refund.refundAmount.toStringAsFixed(2)} FCFA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showDetailDialog(context, refund),
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

  String _getStatusString(RefundStates state) {
    switch (state) {
      case RefundStates.success:
        return 'approved';
      case RefundStates.approval:
        return 'rejected';
      default: // RefundStates.padding
        return 'pending';
    }
  }
}