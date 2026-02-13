import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/theme/app_theme.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/services/update_service.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/widgets/app_buttons.dart';
import 'package:refundo/presentation/widgets/callback_password.dart';
import 'package:refundo/presentation/widgets/user_update_cardnumber.dart';
import 'package:refundo/presentation/widgets/user_update_email.dart';
import 'package:refundo/presentation/widgets/user_profile_card.dart';
import 'package:refundo/presentation/widgets/floating_login.dart';
import 'package:refundo/presentation/pages/debug/complete_debug_panel.dart';
import 'package:refundo/presentation/pages/help/help_and_feedback_page.dart';
import 'package:refundo/presentation/pages/legal/privacy_policy_page.dart';
import 'package:refundo/presentation/pages/legal/about_app_page.dart';
import 'package:refundo/presentation/pages/history/scan_history_page.dart';
import 'package:refundo/presentation/pages/profile/user_detail_page.dart';

/// 个人中心页面 - Material Design 3风格
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _showCustomBottomSheet(BuildContext context, int index) async {
    List<Widget> list = [EmailChangeSheet(), CardChangeSheet()];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => list[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = Provider.of<UserProvider>(context).isLogin;
    final userProvider = Provider.of<UserProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryLight.withOpacity(0.15),
              AppColors.secondaryLight.withOpacity(0.1),
              AppColors.background,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // 渐变AppBar - 标题固定在顶部，更紧凑
            SliverAppBar(
              expandedHeight: 60,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              title: Text(
                l10n.bottom_setting_page,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // 内容区域
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户信息卡片 - 可点击
                    GestureDetector(
                      onTap: () => _handleUserCardTap(context, isLogin),
                      child: _buildUserHeaderCard(context, userProvider, isLogin),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 应用设置
                    _buildSettingsGroup(
                      title: l10n.app_settings,
                      icon: Icons.settings_rounded,
                      color: AppColors.secondary,
                      children: [
                        _buildLanguageSettingTile(context, l10n),
                        _buildSettingTile(
                          icon: Icons.system_update_rounded,
                          iconColor: AppColors.primaryLight,
                          title: l10n.check_for_updates,
                          subtitle: l10n.check_update_subtitle,
                          onTap: () {
                            LogUtil.d("设置页", "检查更新");
                            UpdateService().checkUpdate(context);
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.history_rounded,
                          iconColor: AppColors.infoLight,
                          title: l10n.scan_history,
                          subtitle: l10n.view_scan_history,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScanHistoryPage(),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColors.infoLight,
                          title: l10n.help_and_feedback,
                          subtitle: l10n.faq,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpAndFeedbackPage(),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.privacy_tip_outlined,
                          iconColor: AppColors.primaryLight,
                          title: l10n.privacy_policy,
                          subtitle: l10n.view_app_privacy_terms,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyPage(),
                              ),
                            );
                          },
                        ),
                        _buildSettingTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.textSecondary,
                          title: l10n.about_app,
                          subtitle: l10n.version_info_and_help,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutAppPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 调试工具（仅调试模式）
                    _buildDebugSection(context),
                    const SizedBox(height: AppSpacing.lg),

                    // 退出/登录按钮
                    _buildAuthButton(context, isLogin, l10n),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理用户卡片点击
  void _handleUserCardTap(BuildContext context, bool isLogin) {
    if (isLogin) {
      // 已登录：跳转到个人详情页面（类似QQ）
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const UserDetailPage(),
        ),
      );
    } else {
      // 未登录：显示登录悬浮窗
      FloatingLogin.show(context: context);
    }
  }

  /// 用户信息头部卡片
  Widget _buildUserHeaderCard(BuildContext context, UserProvider userProvider, bool isLogin) {
    final l10n = AppLocalizations.of(context)!;
    final userName = userProvider.user?.username ?? l10n.guest_user;
    final userEmail = userProvider.user?.email ?? l10n.not_logged_in;
    final userBalance = userProvider.user?.balance ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: AppShadows.medium,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: isLogin
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.person_outline_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  userEmail,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isLogin) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${userBalance.toStringAsFixed(0)} FCFA',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 编辑/登录提示图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLogin ? Icons.edit_rounded : Icons.login_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// 设置分组
  Widget _buildSettingsGroup({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 分组标题
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // 设置卡片
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: AppShadows.card,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// 设置选项
  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 语言设置选项
  Widget _buildLanguageSettingTile(BuildContext context, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context);

    return _buildSettingTile(
      icon: Icons.language_rounded,
      iconColor: AppColors.secondary,
      title: l10n.language_settings,
      subtitle: _getLanguageDisplayName(locale),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryLight.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.secondaryLight),
        ),
        child: Text(
          _getLanguageDisplayName(locale),
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.secondaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () => _showLanguageDialog(context, l10n),
    );
  }

  Widget _buildDebugSection(BuildContext context) {
    // 检查是否为调试模式
    const isDebug = bool.fromEnvironment('dart.vm.product') == false;

    if (!isDebug) return const SizedBox.shrink();

    return _buildSettingsGroup(
      title: '开发工具',
      icon: Icons.bug_report_rounded,
      color: AppColors.errorLight,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompleteDebugPanelPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.errorLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      Icons.bug_report_rounded,
                      color: AppColors.errorLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '调试面板',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '打开完整调试面板',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textHint,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton(BuildContext context, bool isLogin, AppLocalizations l10n) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (isLogin) {
      return AppButtons.primaryLarge(
        text: l10n.exit_current_account,
        onPressed: () {
          userProvider.logOut(context);
        },
        icon: Icons.logout_rounded,
        width: double.infinity,
      );
    } else {
      return AppButtons.primaryLarge(
        text: l10n.login_your_account,
        onPressed: () {
          FloatingLogin.show(context: context);
        },
        icon: Icons.login_rounded,
        width: double.infinity,
      );
    }
  }

  String _getLanguageDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '中文';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return '中文';
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.select_language),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('中文', 'zh', Icons.translate_rounded, AppColors.errorLight),
              const SizedBox(height: AppSpacing.md),
              _buildLanguageOption('English', 'en', Icons.language_rounded, AppColors.primaryLight),
              const SizedBox(height: AppSpacing.md),
              _buildLanguageOption('Français', 'fr', Icons.language_rounded, AppColors.secondaryLight),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String name, String code, IconData icon, Color color) {
    final currentLocale = Localizations.localeOf(context);
    final isSelected = currentLocale.languageCode == code;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isSelected ? color : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final appProvider = Provider.of<AppProvider>(context, listen: false);
            appProvider.changeLocale(code);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.md),
                Text(
                  name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? color : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 用户信息编辑底部弹窗
/// 复用现有的UserProfileCard组件
class UserProfileEditSheet extends StatelessWidget {
  const UserProfileEditSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfileCard();
  }
}
