import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/widgets/avatar_widget.dart';
import 'package:refundo/core/widgets/floating_login.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_update_newname.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.isLogin) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 头像
                avatarWidget('', provider.user!.username, 20, false),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户名
                      Text(
                        provider.user!.username,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "UID:${provider.user!.userAccount}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5.0),
                TextButton(
                  onPressed: () {
                    print("修改用户名");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NameChangeSheet(),
                      ),
                    );
                  },
                  child: Text(
                    '修改用户名',
                    style: TextStyle(fontSize: 20.0, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 5.0),
                // 头像
                avatarWidget('', 'U', 40, false),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      FloatingLogin.show(context: context);
                    },
                    child: Text(
                      '点击登入',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
