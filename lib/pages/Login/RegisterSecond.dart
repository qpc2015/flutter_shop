import 'dart:async';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/Widget/QText.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/ScreenAdaper.dart';

class RegisterSecondPage extends StatefulWidget {
  Map arguments;
  RegisterSecondPage({Key key, this.arguments}) : super(key: key);

  @override
  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  String tel;
  bool sendCodeBtn = false;
  int _seconds = 60;
  String code;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    this.tel = widget.arguments['tel'];
    this._showTimer();
  }

  @override
  void dispose(){
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  _showTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        this._seconds--;
      });
      if (this._seconds == 0) {
        timer.cancel();
        setState(() {
          this.sendCodeBtn = true;
        });
      }
    });
  }

  void sendCode() async {
    setState(() {
      this.sendCodeBtn = false;
      this._seconds = 60;
      this._showTimer();
    });

    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": this.tel});
    if (response.data['success']) {
      print(response);
    } else {
      Fluttertoast.showToast(
          msg: "${response.data["message"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  _validateCode() async {
    var api = '${Config.domain}api/validateCode';
    var response =
        await Dio().post(api, data: {"tel": this.tel, "code": this.code});
    if (response.data["success"]) {
      Navigator.pushNamed(context, '/registerThird',arguments: {
        'tel':this.tel,
        'code':this.code
      });
    } else {
      Fluttertoast.showToast(
        msg: '${response.data["message"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第二步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("请输入${this.tel}手机收到的验证码,请输入xxx手机收到的验证码"),
            ),
            SizedBox(
              height: 40,
            ),
            Stack(
              children: <Widget>[
                Container(
                  child: QText(
                  text: "请输入验证码",
                  onChanged: (value) {
                    this.code = value;
                  },
                ),
                height: ScreenAdaper.height(100),
                ),
                Positioned(
                  child: this.sendCodeBtn
                      ? RaisedButton(
                          onPressed: this.sendCode,
                          child: Text("重新发送"),
                        )
                      : RaisedButton(
                          child: Text("${this._seconds}秒后重发"), onPressed: null),
                  right: 0,
                  top: 0,
                )
              ],
            ),
            SizedBox(height: 20),
            QButton(
              text: '下一步',
              color: Colors.red,
              height: 74,
              cb: () {
                this._validateCode();
              },
            )
          ],
        ),
      ),
    );
  }
}
