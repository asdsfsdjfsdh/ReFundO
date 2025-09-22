// 头像widget
import 'package:flutter/material.dart';

Widget avatarWidget(String userImageUrl,String username,double radius, bool useLocalImage){
  if(userImageUrl.isNotEmpty){
    return CircleAvatar(
        radius: radius,
        backgroundImage: useLocalImage
            ? AssetImage(userImageUrl) as ImageProvider
            : NetworkImage(userImageUrl)
    );
  }
  // 没有头像就用用户名首字母
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.blue[500],
    child: Text(
      username.isNotEmpty? username[0]:'U',
      style: TextStyle(
          fontSize: radius*0.8,
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
    ),
  );
}