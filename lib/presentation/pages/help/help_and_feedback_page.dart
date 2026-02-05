import 'package:flutter/material.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// 帮助与反馈页面
class HelpAndFeedbackPage extends StatelessWidget {
  const HelpAndFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.help_and_feedback),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 快速搜索帮助
            _buildSearchBar(context),
            const SizedBox(height: 24),

            // 常见问题
            _buildFAQSection(context),
            const SizedBox(height: 24),

            // 使用教程
            _buildTutorialSection(context),
            const SizedBox(height: 24),

            // 联系客服
            _buildContactSection(context),
            const SizedBox(height: 24),

            // 问题反馈
            _buildFeedbackSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Icon(
            Icons.search_rounded,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n!.search_help,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                // 搜索过滤功能（可选）
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: Colors.blue,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              l10n!.frequently_asked_questions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFAQItem(context, l10n!.faq1_question, l10n.faq1_answer),
        _buildFAQItem(context, l10n!.faq2_question, l10n!.faq2_answer),
        _buildFAQItem(context, l10n!.faq3_question, l10n!.faq3_answer),
        _buildFAQItem(context, l10n!.faq4_question, l10n!.faq4_answer),
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              l10n!.video_tutorials,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildTutorialCard(
          context,
          l10n!.tutorial1_title,
          l10n!.tutorial1_desc,
          Icons.qr_code_scanner_rounded,
          Colors.blue,
          () => _launchUrl('https://www.youtube.com/watch?v=example1'),
        ),
        _buildTutorialCard(
          context,
          l10n!.tutorial2_title,
          l10n!.tutorial2_desc,
          Icons.shopping_cart_rounded,
          Colors.orange,
          () => _launchUrl('https://www.youtube.com/watch?v=example2'),
        ),
      ],
    );
  }

  Widget _buildTutorialCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_outline_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.support_agent_rounded,
              color: Colors.purple,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              l10n!.contact_us,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildContactOption(
          context,
          l10n!.email_support,
          l10n!.email_support_address,
          Icons.email_rounded,
          Colors.red,
          () => _launchEmail('support@refundo.com'),
        ),
        _buildContactOption(
          context,
          l10n!.phone_support,
          l10n!.phone_support_number,
          Icons.phone_rounded,
          Colors.green,
          () => _launchPhone('+1234567890'),
        ),
        _buildContactOption(
          context,
          l10n!.whatsapp_support,
          l10n!.whatsapp_available,
          Icons.chat_rounded,
          Colors.green.shade700,
          () => _launchUrl('https://wa.me/1234567890'),
        ),
      ],
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    String title,
    String detail,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.feedback_rounded,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              l10n!.send_feedback,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n!.feedback_description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: l10n!.enter_your_feedback,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _submitFeedback(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n!.submit_feedback),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=RefundO Feedback',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _submitFeedback(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // 反馈提交功能 - 显示成功提示
    // 实际项目可连接后端 API 或第三方服务
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n!.feedback_submitted_successfully),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
}
