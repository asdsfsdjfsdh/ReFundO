import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/presentation/providers/app_provider.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/widgets/app_cards.dart';
import 'package:refundo/presentation/widgets/app_buttons.dart';
import 'package:refundo/presentation/widgets/callback_password.dart';
import 'package:refundo/presentation/widgets/user_profile_card.dart';
import 'package:refundo/presentation/widgets/user_update_cardnumber.dart';
import 'package:refundo/presentation/widgets/user_update_email.dart';
import 'package:refundo/presentation/pages/debug/complete_debug_panel.dart';

/// 个人中心页面
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
    final locale = Localizations.localeOf(context);
    final isLogin = Provider.of<UserProvider>(context).isLogin;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50.withOpacity(0.3),
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // 顶部应用栏
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  l10n.bottom_setting_page,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade600,
                        Colors.purple.shade600,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 内容区域
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户信息卡片
                    UserProfileCard(key: ValueKey(locale.languageCode)),
                    const SizedBox(height: 24),

                    // 账户设置（仅登录时显示）
                    if (isLogin) ...[
                      _buildSectionHeader(l10n.account_settings),
                      const SizedBox(height: 12),
                      _buildAccountSettings(context, l10n),
                      const SizedBox(height: 24),
                    ],

                    // 应用设置
                    _buildSectionHeader(l10n.app_settings),
                    const SizedBox(height: 12),
                    _buildAppSettings(context, l10n, isLogin),
                    const SizedBox(height: 24),

                    // 调试工具（仅调试模式）
                    _buildDebugSection(context),
                    const SizedBox(height: 24),

                    // 退出/登录按钮
                    _buildAuthButton(context, isLogin, l10n),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, AppLocalizations l10n) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      children: [
        _buildSettingCard(
          icon: Icons.email_outlined,
          iconColor: Colors.orange.shade600,
          title: l10n.email_address,
          subtitle: userProvider.user?.Email ?? '',
          onTap: () => _showCustomBottomSheet(context, 0),
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          icon: Icons.lock_outline_rounded,
          iconColor: Colors.blue.shade600,
          title: l10n.login_password,
          subtitle: '********',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CallbackPassword()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          icon: Icons.credit_card_rounded,
          iconColor: Colors.green.shade600,
          title: l10n.bank_card_number,
          subtitle: userProvider.user?.phoneNumber ?? '',
          onTap: () => _showCustomBottomSheet(context, 1),
        ),
      ],
    );
  }

  Widget _buildAppSettings(BuildContext context, AppLocalizations l10n, bool isLogin) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final locale = Localizations.localeOf(context);

    return Column(
      children: [
        // 语言设置
        _buildSettingCard(
          icon: Icons.language_rounded,
          iconColor: Colors.purple.shade600,
          title: l10n.language_settings,
          subtitle: _getLanguageDisplayName(locale),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Text(
              _getLanguageDisplayName(locale),
              style: TextStyle(
                fontSize: 13,
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () => _showLanguageDialog(context, l10n),
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          icon: Icons.info_outline_rounded,
          iconColor: Colors.grey.shade600,
          title: l10n.about_app,
          subtitle: l10n.version_info_and_help,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.about_page_under_development),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDebugSection(BuildContext context) {
    // 检查是否为调试模式
    const isDebug = bool.fromEnvironment('dart.vm.product') == false;

    if (!isDebug) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('开发工具'),
        const SizedBox(height: 12),
        AppCards.withHeader(
          title: '调试面板',
          leading: Icon(Icons.bug_report, color: Colors.red.shade700),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '打开完整调试面板',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                AppButtons.secondary(
                  text: '打开调试面板',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompleteDebugPanelPage(),
                      ),
                    );
                  },
                  icon: Icons.bug_report,
                ),
              ],
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.please_login_first),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: Icons.login_rounded,
        width: double.infinity,
      );
    }
  }

  Widget _buildSettingCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return AppCards.basic(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
        ],
      ),
    );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('中文', 'zh', Icons.translate_rounded, Colors.red.shade600),
              const SizedBox(height: 12),
              _buildLanguageOption('English', 'en', Icons.language_rounded, Colors.blue.shade600),
              const SizedBox(height: 12),
              _buildLanguageOption('Français', 'fr', Icons.language_rounded, Colors.purple.shade600),
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
            final appProvider = Provider.of<AppProvider>(context, listen: false);
            appProvider.changeLocale(code);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? color : Colors.black87,
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
