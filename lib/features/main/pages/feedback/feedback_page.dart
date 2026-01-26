import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/feedback/provider/feedback_provider.dart';
import 'package:refundo/features/main/pages/feedback/widgets/feedback_submit_tab.dart';
import 'package:refundo/features/main/pages/feedback/widgets/feedback_history_tab.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 反馈页面 - 包含提交反馈和历史记录两个Tab
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 页面加载时获取历史记录
    Future.microtask(() {
      if (mounted) {
        context.read<FeedbackProvider>().getFeedbacks(context);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedback_title),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          tabs: [
            Tab(text: l10n.feedback_tab_submit),
            Tab(text: l10n.feedback_tab_history),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FeedbackSubmitTab(),
          FeedbackHistoryTab(),
        ],
      ),
    );
  }
}
