import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/Widget/QText.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/ScreenAdaper.dart';

class RegisterFirstPage extends StatefulWidget {
  RegisterFirstPage({Key key}) : super(key: key);

  @override
  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  String _tel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册第一步'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            QText(
              text: "请输入手机号",
              onChanged: (value) {
                this._tel = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            QButton(
              text: "下一步",
              color: Colors.red,
              height: 74,
              cb: sendCode,
            )
          ],
        ),
      ),
    );
  }

  sendCode() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (reg.hasMatch(this._tel)) {
      var api = '${Config.domain}api/sendCode';
      var response = await Dio().post(api, data: {"tel": this._tel});
      if (response.data['success']) {
        print(response);
        Navigator.pushNamed(context, '/registerSecond',
            arguments: {"tel": this._tel});
      } else {
        Fluttertoast.showToast(
            msg: "${response.data["message"]}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "手机号码格式不对",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }
}
