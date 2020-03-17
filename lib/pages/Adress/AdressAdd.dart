import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/Widget/QText.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/EventBus.dart';
import 'package:shop/services/ScreenAdaper.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:shop/services/SignServices.dart';
import 'package:shop/services/UserService.dart';

class AdressAddPage extends StatefulWidget {
  AdressAddPage({Key key}) : super(key: key);

  @override
  _AdressAddPageState createState() => _AdressAddPageState();
}

class _AdressAddPageState extends State<AdressAddPage> {
  String area = '';
  String name = '';
  String phone = '';
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("增加收货地址"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            QText(
              text: "收货人姓名",
              onChanged: (value) {
                this.name = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            QText(
              text: "收货人号码",
              onChanged: (value) {
                this.phone = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(left: 5),
                height: ScreenAdaper.height(68),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_location),
                      this.area.length > 0
                          ? Text('${this.area}',
                              style: TextStyle(color: Colors.black54))
                          : Text('省/市/区',
                              style: TextStyle(color: Colors.black54))
                    ],
                  ),
                  onTap: () async {
                    Result result = await CityPickers.showCityPicker(
                        context: context,
                        height: ScreenAdaper.height(400),
                        cancelWidget:
                            Text("取消", style: TextStyle(color: Colors.blue)),
                        confirmWidget:
                            Text("确定", style: TextStyle(color: Colors.blue)));
                    setState(() {
                      this.area =
                          "${result.provinceName}/${result.cityName}/${result.areaName}";
                    });
                  },
                )),
            SizedBox(
              height: 10,
            ),
            QText(
              text: "详细地址",
              height: 200,
              maxLines: 4,
              onChanged: (value) {
                this.address = value;
              },
            ),
            SizedBox(
              height: 50,
            ),
            QButton(
              text: "增加",
              color: Colors.red,
              cb: _postAddAddress,
            )
          ],
        ),
      ),
    );
  }

  _postAddAddress() async {
    var userinfo = await UserService.getUserInfo();
    print(userinfo);
    var tempJson = {
      "uid": userinfo[0]["_id"],
      "name": this.name,
      "phone": this.phone,
      "address": this.address,
      "salt": userinfo[0]["salt"]
    };

    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/addAddress';
    var result = await Dio().post(api, data: {
      "uid": userinfo[0]["_id"],
      "name": this.name,
      "phone": this.phone,
      "address": this.address,
      "sign": sign
    });
    if (result.data["success"]) {
      Navigator.pop(context);
      eventBus.fire(new AdressAddEvent("添加地址成功"));
    }
  }
}
