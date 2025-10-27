import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/core/widgets/callback_password.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_profile_card.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_update_cardnumber.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_update_email.dart';
import 'package:refundo/l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  // 创建自定义 BottomSheet
  Future<void> _showCustomBottomSheet(BuildContext context, int index) async {
    List<Widget> list = [EmailChangeSheet(), CardChangeSheet()];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 透明背景
      builder: (BuildContext context) {
        return list[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = Provider.of<UserProvider>(context).isLogin;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bottom_setting_page),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(),
            SizedBox(height: 24),
            Container(
              child: Column(
                children: [
                  isLogin
                      ? Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  print("修改资料--邮箱");
                                  _showCustomBottomSheet(context, 0);
                                },
                                splashColor: Colors.grey,
                                highlightColor: Colors.grey,
                                child: ListTile(
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Colors.red[700],
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    '邮箱',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  minLeadingWidth: 20,
                                ),
                              ),
                            ),

                            Divider(height: 1, color: Colors.grey[300]),
                            SizedBox(height: 4),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  print("修改资料--密码");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallbackPassword(),
                                    ),
                                  );
                                },
                                splashColor: Colors.grey,
                                highlightColor: Colors.grey,
                                child: ListTile(
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.red[700],
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    '密码',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  minLeadingWidth: 20,
                                ),
                              ),
                            ),

                            Divider(height: 1, color: Colors.grey[300]),
                            SizedBox(height: 4),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  print("修改资料--银行卡");
                                  _showCustomBottomSheet(context, 1);
                                },
                                splashColor: Colors.grey,
                                highlightColor: Colors.grey,
                                child: ListTile(
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.credit_card,
                                      color: Colors.red[700],
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    '银行卡号',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  minLeadingWidth: 20,
                                ),
                              ),
                            ),

                            Divider(height: 1, color: Colors.grey[300]),
                            SizedBox(height: 4),
                          ],
                        )
                      : SizedBox(),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        if (Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).isLogin) {
                          LogUtil.d("账号", "注销");
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).logOut(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('请先登入'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      splashColor: Colors.grey,
                      highlightColor: Colors.grey,
                      child: ListTile(
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.login,
                            color: Colors.red[700],
                            size: 20,
                          ),
                        ),
                        title: Text('注销账号', style: TextStyle(fontSize: 16)),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        minLeadingWidth: 20,
                      ),
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
}
