import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/Widget/QText.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/EventBus.dart';
import 'package:shop/services/ScreenAdaper.dart';
import 'package:shop/services/SignServices.dart';
import 'package:shop/services/UserService.dart';

class AdressEditPage extends StatefulWidget {
  Map arguments;
  AdressEditPage({Key key, this.arguments}) : super(key: key);

  @override
  _AdressEditPageState createState() => _AdressEditPageState();
}

class _AdressEditPageState extends State<AdressEditPage> {
  String area = '';
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.arguments);
    nameController.text = widget.arguments["name"];
    phoneController.text = widget.arguments["phone"];
    addressController.text = widget.arguments["address"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改收货地址"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            QText(
              contorller: nameController,
              onChanged: (value) {
                // this.name = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            QText(
              contorller: phoneController,
              onChanged: (value) {
                // this.phone = value;
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
                          '${result.provinceName}/${result.cityName}/${result.areaName}';
                    });
                  },
                )),
            SizedBox(
              height: 10,
            ),
            QText(
              contorller: addressController,
              height: 200,
              maxLines: 4,
              onChanged: (value) {
                // this.address = value;
              },
            ),
            SizedBox(
              height: 50,
            ),
            QButton(
              text: "修改",
              color: Colors.red,
              cb: _editAddress,
            )
          ],
        ),
      ),
    );
  }

  _editAddress() async {
    List userinfo = await UserService.getUserInfo();
    var tempJson = {
      "uid": userinfo[0]["_id"],
      "id": widget.arguments["id"],
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "salt": userinfo[0]["salt"]
    };
    var sign = SignServices.getSign(tempJson);
    // print(sign);

    var api = '${Config.domain}api/editAddress';
    var response = await Dio().post(api, data: {
      "uid": userinfo[0]["_id"],
      "id": widget.arguments["id"],
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "sign": sign
    });
    print(response);
    if (response.data["success"]) {
      eventBus.fire(new AdressEditEvent("修改地址"));
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: "网络连接错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
  }
}
