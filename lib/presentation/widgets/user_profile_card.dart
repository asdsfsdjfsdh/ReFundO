import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:refundo/presentation/widgets/floating_login.dart';
import 'package:refundo/presentation/providers/user_provider.dart';
import 'package:refundo/presentation/widgets/user_update_newname.dart';
import 'package:refundo/l10n/app_localizations.dart'; // 添加多语言支持

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _PremiumUserProfileCardState();
}

class _PremiumUserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade50,
                Colors.white,
                Colors.grey.shade100,
              ],
            ),
          ),
          child: provider.isLogin ? _buildLoggedInUI(context, provider) : _buildLoggedOutUI(context, provider),
        );
      },
    );
  }

  Widget _buildLoggedInUI(BuildContext context, UserProvider provider) {
    return Column(
      children: [
        // 用户信息主卡片
        _buildUserInfoCard(context, provider),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUserInfoCard(BuildContext context, UserProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade600.withOpacity(0.9),
            Colors.purple.shade800,
            Colors.indigo.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 高级头像组件
            _buildPremiumAvatar(context, provider),
            const SizedBox(width: 16),

            // 用户信息区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUsernameSection(context, provider),
                  const SizedBox(height: 8),
                  _buildUidSection(context, provider),
                ],
              ),
            ),

            // 修改按钮
            _buildEditButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumAvatar(BuildContext context, UserProvider provider) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 36,
        backgroundColor: Colors.white.withOpacity(0.1),
        child: provider.user!.avatarUrl != null && provider.user!.avatarUrl!.isNotEmpty
            ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: provider.user!.avatarUrl!,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildAvatarPlaceholder(context, provider),
            errorWidget: (context, url, error) => _buildAvatarPlaceholder(context, provider),
          ),
        )
            : _buildAvatarPlaceholder(context, provider),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, UserProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          provider.user!.username.isNotEmpty ? provider.user!.username[0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameSection(BuildContext context, UserProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _handleEditUsername(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Text(
              provider.user!.username,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUidSection(BuildContext context, UserProvider provider) {
    final l10n = AppLocalizations.of(context);

    return Text(
      '${l10n!.uid_label}:${provider.user!.userAccount}',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        onPressed: () => _handleEditUsername(context),
        icon: Icon(
          Icons.edit_rounded,
          color: Colors.white.withOpacity(0.9),
          size: 20,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLoggedOutUI(BuildContext context, UserProvider provider) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 默认头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade400,
                    Colors.grey.shade600,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      FloatingLogin.show(context: context);
                    },
                    child: Text(
                      l10n!.not_logged_in,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.please_login_to_view_profile,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditUsername(BuildContext context) {
    print("修改用户名");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameChangeSheet(),
      ),
    );
  }

  void _handleEditEmail() {
    print('修改邮箱');
    // 这里可以添加邮箱修改逻辑
  }
}