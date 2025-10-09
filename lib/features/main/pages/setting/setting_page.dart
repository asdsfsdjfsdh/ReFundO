import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/core/utils/log_util.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/features/main/pages/setting/widgets/user_profile_card.dart';
import 'package:refundo/l10n/app_localizations.dart';

class SettingPage extends StatelessWidget{
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 24,),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow:[
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ]
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if(Provider.of<UserProvider>(context,listen: false).isLogin){
                        LogUtil.d("账号", "注销");
                        Provider.of<UserProvider>(context,listen: false).logOut(context);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('请先登入'),
                            duration: Duration(seconds: 1),
                          )
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
                        child: Icon(Icons.login, color: Colors.red[700], size: 20),
                      ),
                      title: Text('注销账号', style: TextStyle(fontSize: 16)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      minLeadingWidth: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}