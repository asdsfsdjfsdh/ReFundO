import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/feedback/provider/feedback_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/models/feedback_model.dart';

/// 反馈历史记录Tab
class FeedbackHistoryTab extends StatelessWidget {
  const FeedbackHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<FeedbackProvider>();

    if (provider.isLoadingHistory) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3D8A5A),
        ),
      );
    }

    if (provider.feedbacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.feedback_no_records,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.getFeedbacks(context),
      color: const Color(0xFF3D8A5A),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: provider.feedbacks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final feedback = provider.feedbacks[index];
          return _buildFeedbackCard(context, feedback, l10n);
        },
      ),
    );
  }

  /// 构建反馈卡片
  Widget _buildFeedbackCard(
      BuildContext context, FeedbackModel feedback, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showFeedbackDetail(context, feedback, l10n),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：类型、状态和操作按钮
              Row(
                children: [
                  Flexible(
                    child: _buildTypeChip(feedback.type),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _buildStatusChip(feedback.status),
                  ),
                  const SizedBox(width: 8),
                  if (feedback.canWithdraw)
                    _buildWithdrawButton(context, feedback, l10n),
                ],
              ),
              const SizedBox(height: 12),
              // 内容预览
              Text(
                feedback.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1918),
                ),
              ),
              const SizedBox(height: 8),
              // 时间和附件指示
              Row(
                children: [
                  Text(
                    _formatDate(feedback.createTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (feedback.attachmentUrl != null) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.attach_file,
                      size: 14,
                      color: Color(0xFF3D8A5A),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建类型标签
  Widget _buildTypeChip(FeedbackType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type.icon,
            size: 14,
            color: _getTypeColor(type),
          ),
          const SizedBox(width: 4),
          Text(
            type.zhName,
            style: TextStyle(
              fontSize: 12,
              color: _getTypeColor(type),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建状态标签
  Widget _buildStatusChip(FeedbackStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.zhName,
        style: TextStyle(
          fontSize: 12,
          color: status.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建撤回按钮
  Widget _buildWithdrawButton(
      BuildContext context, FeedbackModel feedback, AppLocalizations l10n) {
    return TextButton(
      onPressed: () => _confirmWithdraw(context, feedback, l10n),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.grey.shade600,
      ),
      child: Text(
        l10n.feedback_withdraw,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  /// 获取类型对应的颜色
  Color _getTypeColor(FeedbackType type) {
    switch (type) {
      case FeedbackType.issue:
        return Colors.red;
      case FeedbackType.suggestion:
        return Colors.blue;
      case FeedbackType.complaint:
        return Colors.orange;
      case FeedbackType.other:
        return Colors.grey;
    }
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  /// 显示反馈详情对话框
  void _showFeedbackDetail(
      BuildContext context, FeedbackModel feedback, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.feedback_detail_title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.feedback_type_label, feedback.type.zhName),
              _buildDetailRow(
                  l10n.feedback_status_label, feedback.status.zhName),
              _buildDetailRow(
                  l10n.feedback_time_label, _formatDate(feedback.createTime)),
              if (feedback.contactInfo != null && feedback.contactInfo!.isNotEmpty)
                _buildDetailRow(l10n.feedback_contact_label, feedback.contactInfo!),
              const SizedBox(height: 12),
              Text(
                l10n.feedback_content_label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(feedback.content),
              if (feedback.attachmentUrl != null) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.feedback_attachment,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    feedback.attachmentUrl!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  /// 构建详情行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// 确认撤回
  Future<void> _confirmWithdraw(
      BuildContext context, FeedbackModel feedback, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.feedback_withdraw_confirm_title),
        content: Text(l10n.feedback_withdraw_confirm_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context
          .read<FeedbackProvider>()
          .withdrawFeedback(feedback.feedbackId, context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                success ? l10n.feedback_withdraw_success : l10n.feedback_withdraw_failed),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
