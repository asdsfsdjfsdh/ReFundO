import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/feedback/provider/feedback_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/models/feedback_model.dart';

/// 提交反馈Tab
class FeedbackSubmitTab extends StatelessWidget {
  const FeedbackSubmitTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<FeedbackProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 副标题
          Center(
            child: Text(
              l10n.feedback_subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 反馈类型选择
          Text(
            l10n.feedback_type_label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1918),
            ),
          ),
          const SizedBox(height: 12),
          _buildTypeSelector(context, provider),
          const SizedBox(height: 20),

          // 反馈内容
          Text(
            l10n.feedback_content_label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1918),
            ),
          ),
          const SizedBox(height: 8),
          _buildContentInput(context, provider, l10n),
          const SizedBox(height: 20),

          // 联系方式
          Text(
            l10n.feedback_contact_label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1918),
            ),
          ),
          const SizedBox(height: 8),
          _buildContactInput(context, provider, l10n),
          const SizedBox(height: 20),

          // 图片上传
          Text(
            l10n.feedback_upload_label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1918),
            ),
          ),
          const SizedBox(height: 8),
          _buildImageUpload(context, provider, l10n),
          const SizedBox(height: 24),

          // 提交按钮
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: provider.canSubmit && !provider.isSubmitting
                  ? () => _submitFeedback(context, provider)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D8A5A),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: provider.isSubmitting || provider.isUploadingImage
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      l10n.feedback_submit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建反馈类型选择器
  Widget _buildTypeSelector(BuildContext context, FeedbackProvider provider) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.8,
      children: FeedbackType.values.map((type) {
        final isSelected = provider.selectedType == type.code;
        final locale = Localizations.localeOf(context);

        return InkWell(
          onTap: () => provider.selectType(type.code),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF3D8A5A) : const Color(0xFFE5E4E1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1918).withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFC8F0D8)
                        : const Color(0xFFFAFAF8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    type.icon,
                    color: isSelected ? const Color(0xFF3D8A5A) : const Color(0xFF6D6C6A),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    locale.languageCode == 'zh' ? type.zhName : type.enName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF3D8A5A) : const Color(0xFF1A1918),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建内容输入框
  Widget _buildContentInput(
      BuildContext context, FeedbackProvider provider, AppLocalizations l10n) {
    final contentLength = provider.contentController.text.trim().length;
    final isValid = contentLength >= 10;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E4E1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1918).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: provider.contentController,
            maxLines: 5,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: l10n.feedback_content_hint,
              hintStyle: const TextStyle(color: Color(0xFF9C9B99)),
              border: InputBorder.none,
              counterText: '',
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1918),
              height: 1.5,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              l10n.feedback_content_min_chars,
              style: TextStyle(
                fontSize: 12,
                color: isValid ? const Color(0xFF3D8A5A) : const Color(0xFFA8A7A5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建联系方式输入框
  Widget _buildContactInput(
      BuildContext context, FeedbackProvider provider, AppLocalizations l10n) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E4E1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1918).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            Icons.mail_outline,
            size: 18,
            color: provider.contactController.text.isNotEmpty
                ? const Color(0xFF1A1918)
                : const Color(0xFF9C9B99),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: provider.contactController,
              decoration: InputDecoration(
                hintText: l10n.feedback_contact_hint,
                hintStyle: const TextStyle(color: Color(0xFF9C9B99)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1918),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图片上传区域
  Widget _buildImageUpload(
      BuildContext context, FeedbackProvider provider, AppLocalizations l10n) {
    if (provider.selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              provider.selectedImage!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: provider.removeImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () => provider.pickImage(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E4E1), width: 2),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.upload,
              size: 32,
              color: Color(0xFF3D8A5A),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.feedback_upload_hint,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3D8A5A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.feedback_upload_format_hint,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA8A7A5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 提交反馈
  Future<void> _submitFeedback(BuildContext context, FeedbackProvider provider) async {
    final result = await provider.submitFeedback(context);

    if (context.mounted && result['success']) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.feedback_submit_success),
          backgroundColor: const Color(0xFF3D8A5A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
