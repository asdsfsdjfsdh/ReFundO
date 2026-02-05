import 'package:flutter/material.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/l10n/app_localizations.dart';

/// 隐私政策页面 - Material Design 3风格
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.privacy_policy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 最后更新时间
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.infoLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.infoLight, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    l10n.last_updated_date('2025-01'),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.infoLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 政策内容
            _buildPolicySection(
              context,
              title: l10n.info_collection,
              icon: Icons.collections_rounded,
              color: AppColors.primary,
              content: [
                l10n.info_collection_1,
                l10n.info_collection_2,
                l10n.info_collection_3,
                l10n.info_collection_4,
                l10n.info_collection_5,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.info_usage,
              icon: Icons.settings_rounded,
              color: AppColors.secondary,
              content: [
                l10n.info_usage_1,
                l10n.info_usage_2,
                l10n.info_usage_3,
                l10n.info_usage_4,
                l10n.info_usage_5,
                l10n.info_usage_6,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.info_sharing,
              icon: Icons.share_rounded,
              color: AppColors.warning,
              content: [
                l10n.info_sharing_1,
                l10n.info_sharing_2,
                l10n.info_sharing_3,
                l10n.info_sharing_4,
                l10n.info_sharing_5,
                l10n.info_sharing_6,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.data_security,
              icon: Icons.security_rounded,
              color: AppColors.success,
              content: [
                l10n.data_security_1,
                l10n.data_security_2,
                l10n.data_security_3,
                l10n.data_security_4,
                l10n.data_security_5,
                l10n.data_security_6,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.your_rights,
              icon: Icons.verified_user_rounded,
              color: AppColors.info,
              content: [
                l10n.your_rights_1,
                l10n.your_rights_2,
                l10n.your_rights_3,
                l10n.your_rights_4,
                l10n.your_rights_5,
                l10n.your_rights_6,
                l10n.your_rights_7,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.cookie_policy,
              icon: Icons.cookie_rounded,
              color: AppColors.textSecondary,
              content: [
                l10n.cookie_policy_1,
                l10n.cookie_policy_2,
                l10n.cookie_policy_3,
                l10n.cookie_policy_4,
                l10n.cookie_policy_5,
                l10n.cookie_policy_6,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.child_privacy,
              icon: Icons.child_care_rounded,
              color: AppColors.errorLight,
              content: [
                l10n.child_privacy_1,
                l10n.child_privacy_2,
                l10n.child_privacy_3,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.policy_changes,
              icon: Icons.update_rounded,
              color: AppColors.primaryDark,
              content: [
                l10n.policy_changes_1,
                l10n.policy_changes_2,
                l10n.policy_changes_3,
                l10n.policy_changes_4,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            _buildPolicySection(
              context,
              title: l10n.contact_us_section,
              icon: Icons.contact_mail_rounded,
              color: AppColors.secondaryDark,
              content: [
                l10n.contact_us_1,
                l10n.contact_us_2,
                l10n.contact_us_3,
                l10n.contact_us_4,
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<String> content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // 内容
            ...content.map((text) => Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    bottom: AppSpacing.xs,
                  ),
                  child: Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
