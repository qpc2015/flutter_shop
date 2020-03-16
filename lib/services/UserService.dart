

import 'dart:convert';
import 'package:shop/services/Storage.dart';

class UserService{

  static getUserInfo() async{
     List userinfo;
     try {
      List userInfoData = json.decode(await Storage.getString('userInfo') ?? '');
      userinfo = userInfoData;
    } catch (e) {
     userinfo = [];
    }
    return userinfo;  
  }

  static getUserLoginState() async{
    var userInfo = await UserService.getUserInfo();
    if(userInfo.length > 0 && userInfo[0]["usename"] != ""){
      return true;
    }
    return false;
  }

  static loginOut(){
    Storage.remove("userInfo");
  }

}