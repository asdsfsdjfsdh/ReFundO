import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/widgets/callback_password.dart';
import 'package:refundo/features/main/pages/setting/provider/app_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/main/pages/setting/widgets/audit_page.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_profile_card.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_update_cardnumber.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_update_email.dart';
import 'package:refundo/l10n/app_localizations.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _showCustomBottomSheet(BuildContext context, int index) async {
    List<Widget> list = [EmailChangeSheet(), CardChangeSheet()];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return list[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 关键修改：监听Localizations.localeOf(context)的变化来触发重建
    final locale = Localizations.localeOf(context);
    final isLogin = Provider.of<UserProvider>(context).isLogin;

    // 使用Key强制重建当语言改变时
    return Scaffold(
      key: ValueKey(locale.languageCode), // 语言改变时重建整个Scaffold
      appBar: _buildAppBar(context),
      body: _buildBody(context, isLogin),
    );
  }

  // 构建应用栏 - 使用国际化文本
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.bottom_setting_page,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.purple.shade700,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  // 构建主体内容 - 使用国际化文本
  Widget _buildBody(BuildContext context, bool isLogin) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade50.withOpacity(0.3),
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 用户信息卡片
            UserProfileCard(key: ValueKey(Localizations.localeOf(context).languageCode)),
            const SizedBox(height: 24),

            // 2. 账户设置分区标题
            _buildSectionHeader(AppLocalizations.of(context)!.account_settings),
            const SizedBox(height: 12),

            // 3. 账户信息卡片组
            _buildAccountInfoCards(context, isLogin),
            const SizedBox(height: 24),

            // 4. 应用设置部分
            _buildAppSettings(context, isLogin),
          ],
        ),
      ),
    );
  }

  // 构建分区标题
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // 构建账户信息卡片组 - 使用国际化文本
  Widget _buildAccountInfoCards(BuildContext context, bool isLogin) {
    if (!isLogin) {
      return _buildLoginPromptCard(context);
    }

    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        // 邮箱设置卡片
        _buildInfoCard(
          context: context,
          title: l10n!.email_address,
          subtitle: 'project_test@qq.com',
          icon: Icons.email_outlined,
          iconColor: Colors.orange.shade600,
          actionText: l10n.modify_login_email,
          onTap: () {
            LogUtil.d("设置页", "修改资料--邮箱");
            _showCustomBottomSheet(context, 0);
          },
        ),
        const SizedBox(height: 12),

        // 登录密码卡片
        _buildInfoCard(
          context: context,
          title: l10n.login_password,
          subtitle: '********',
          icon: Icons.lock_outline_rounded,
          iconColor: Colors.blue.shade600,
          actionText: l10n.modify_account_password,
          onTap: () {
            LogUtil.d("设置页", "修改资料--密码");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CallbackPassword(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // 银行卡号卡片
        _buildInfoCard(
          context: context,
          title: l10n.bank_card_number,
          subtitle: l10n.bank_card_tail_number,
          icon: Icons.credit_card_rounded,
          iconColor: Colors.green.shade600,
          actionText: l10n.manage_payment_info,
          onTap: () {
            LogUtil.d("设置页", "修改资料--银行卡");
            _showCustomBottomSheet(context, 1);
          },
        ),
      ],
    );
  }

  // 构建信息卡片
  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 左侧图标区域
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // 中间信息区域
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧操作区域
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade400,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建登录提示卡片 - 使用国际化文本
  Widget _buildLoginPromptCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              l10n!.please_login_to_view_account_info,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建应用设置部分 - 使用国际化文本
  Widget _buildAppSettings(BuildContext context, bool isLogin) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n!.app_settings),
        const SizedBox(height: 12),

        // 语言设置卡片
        _buildLanguageSettingCard(context),
        const SizedBox(height: 8),

        _buildAppSettingCard(
          context: context,
          title: isLogin ? l10n.logout_account : l10n.login_account,
          subtitle: isLogin ? l10n.exit_current_account : l10n.login_your_account,
          icon: isLogin ? Icons.logout_rounded : Icons.login_rounded,
          iconColor: isLogin ? Colors.red.shade600 : Colors.blue.shade600,
          isDestructive: isLogin,
          onTap: () {
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );
            if (userProvider.isLogin) {
              LogUtil.d("账号", "注销");
              userProvider.logOut(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.please_login_first),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue.shade600,
                ),
              );
            }
          },
        ),
        const SizedBox(height: 8),
        _buildAppSettingCard(
          context: context,
          title: l10n.audit,
          subtitle: l10n.audit,
          icon: Icons.manage_accounts_outlined,
          iconColor: Colors.yellow.shade600,
          onTap: () {
            if(Provider.of<UserProvider>(context, listen: false).isLogin && Provider.of<UserProvider>(context, listen: false).isManager){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AuditPage(),
                ),
              );
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.not_manager),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 8),

        _buildAppSettingCard(
          context: context,
          title: l10n.privacy_policy,
          subtitle: l10n.view_app_privacy_terms,
          icon: Icons.privacy_tip_outlined,
          iconColor: Colors.purple.shade600,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.privacy_policy_page_under_development),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        _buildAppSettingCard(
          context: context,
          title: l10n.about_app,
          subtitle: l10n.version_info_and_help,
          icon: Icons.info_outline_rounded,
          iconColor: Colors.grey.shade600,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.about_page_under_development),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),

      ],
    );
  }

  // 构建语言设置卡片 - 使用国际化文本
  Widget _buildLanguageSettingCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showLanguageSelectionDialog(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标容器
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade600.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: Colors.purple.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // 文本内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n!.language_settings,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.select_app_language,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 当前语言显示
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.purple.shade200,
                    ),
                  ),
                  child: Text(
                    _getCurrentLanguageDisplayName(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 右侧箭头
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 获取当前语言显示名称
  String _getCurrentLanguageDisplayName(BuildContext context) {
    final locale = Localizations.localeOf(context);
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

  // 显示语言选择对话框 - 使用国际化文本
  void _showLanguageSelectionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            l10n!.select_language,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                '中文',
                'zh',
                Icons.translate_rounded,
                Colors.red.shade600,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                'English',
                'en',
                Icons.language_rounded,
                Colors.blue.shade600,
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context,
                'Français',
                'fr',
                Icons.language_rounded,
                Colors.purple.shade600,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  // 构建语言选项
  Widget _buildLanguageOption(
      BuildContext context,
      String languageName,
      String languageCode,
      IconData icon,
      Color color,
      ) {
    final currentLocale = Localizations.localeOf(context);
    final isSelected = currentLocale.languageCode == languageCode;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _changeLanguage(context, languageCode);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  languageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? color : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: color,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 更改语言
  void _changeLanguage(BuildContext context, String languageCode) {
    // 这里需要根据您的应用架构实现语言切换逻辑
    // 通常是通过Provider或直接调用MaterialApp的locale

    String languageName = '';
    switch (languageCode) {
      case 'zh':
        languageName = '中文';
        break;
      case 'en':
        languageName = 'English';
        break;
      case 'fr':
        languageName = 'Français';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.language_switched_to}: $languageName'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.green.shade600,
      ),
    );

    LogUtil.d("设置页", "语言切换至: $languageCode");

    // 实际的语言切换逻辑需要在这里实现
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.changeLocale(languageCode);
  }

  // 构建应用设置卡片
  Widget _buildAppSettingCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 图标容器
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),

                // 文本内容
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDestructive ? Colors.red.shade700 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 右侧箭头
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}