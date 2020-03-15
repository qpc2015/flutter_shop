import 'package:flutter/material.dart';
import 'package:shop/Widget/QButton.dart';
import '../../Widget/QText.dart';
import 'package:shop/services/ScreenAdaper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: () {}),
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
                print(value);
              },
            ),
            SizedBox(height: 10),
            QText(
              text: "请输入密码",
              password: true,
              onChanged: (value) {
                print(value);
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
                        Navigator.pushNamed(context, '/registerFirst');
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
              cb: () {},
            )
          ],
        ),
      ),
    );
  }
}
