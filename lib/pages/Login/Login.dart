import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/Storage.dart';
import '../../Widget/QText.dart';
import 'package:shop/services/ScreenAdaper.dart';
import '../../services/EventBus.dart';
import 'package:apifm/apifm.dart' as Apifm;
import '../../config/Config.dart';
import 'package:device_info/device_info.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          FlatButton(onPressed: () {}, child: Text("客服")),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: ScreenAdaper.width(160),
                width: ScreenAdaper.width(160),
                child: Icon(
                  Icons.collections_bookmark,
                  color: Colors.lightBlue,
                ),
              ),
            ),
            SizedBox(height: 30),
            QText(
              text: "请输入用户名",
              onChanged: (value) {
                this.username = value;
              },
            ),
            SizedBox(height: 10),
            QText(
              text: "请输入密码",
              password: true,
              onChanged: (value) {
                this.password = value;
              },
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(ScreenAdaper.width(20)),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('忘记密码'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('新用户注册'),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            QButton(
              text: "登录",
              color: Colors.red,
              height: 74,
              cb: _postLogin,
            )
          ],
        ),
      ),
    );
  }

  _postLogin() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (!reg.hasMatch(this.username)) {
      Fluttertoast.showToast(
        msg: '手机号格式不对',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (this.password.length < 6) {
      Fluttertoast.showToast(
        msg: '密码不正确',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      String deviceId, deviceName;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        deviceName = iosInfo.name;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceName = androidInfo.display;
      }
      var res = await Apifm.loginMobile(
          this.username, this.password, deviceId, deviceName);
      if (res['code'] == 0) {
        Storage.setString('userInfo', json.encode(res["data"]));
        eventBus.fire(new UserEvent("登录成功"));
        Navigator.pop(context);
        // processLoginSuccess (res['data']['token'], res['data']['uid']);
      } else {
        Fluttertoast.showToast(
            msg: res['msg'], gravity: ToastGravity.CENTER, fontSize: 14);
      }
      // var api = '${Config.domain}api/doLogin';
      // var response = await Dio().post(api,
      //     data: {"username": this.username, "password": this.password});
      // print(response.data);
      // if (response.data["success"]) {
      //   Storage.setString('userInfo', json.encode(response.data["userinfo"]));
      //   eventBus.fire(new UserEvent("登录成功"));
      //   Navigator.pop(context);
      // } else {
      //   Fluttertoast.showToast(
      //     msg: '${response.data["message"]}',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //   );
      // }
    }
  }
}
