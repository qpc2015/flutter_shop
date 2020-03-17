import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/services/EventBus.dart';
import 'package:shop/services/ScreenAdaper.dart';
import 'package:shop/services/SignServices.dart';
import 'package:shop/services/UserService.dart';
import '../../config/Config.dart';

class AdressListPage extends StatefulWidget {
  AdressListPage({Key key}) : super(key: key);

  @override
  _AdressListPageState createState() => _AdressListPageState();
}

class _AdressListPageState extends State<AdressListPage> {
  List _addressList = [];
  var _addEvent;

  @override
  void initState() {
    super.initState();
    this._getAdressList();
    _addEvent = eventBus.on<AdressAddEvent>().listen((event) {
      print(event.str);
      this._getAdressList();
    });
  }

  @override
  void dispose() {
    _addEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("收货地址列表"),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: this._addressList.length ?? 0,
                itemBuilder: (context, index) {
                  Map item = this._addressList[index];
                  if (item["default_address"] == 1) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.check, color: Colors.red),
                          title: InkWell(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "${item["name"] ?? ''}  ${item["phone"]}"),
                                  SizedBox(height: 10),
                                  Text("${item["address"]}"),
                                ]),
                            onTap: () {
                              this._changeDefaultAdress(item["_id"]);
                            },
                          ),
                          trailing: Icon(Icons.edit, color: Colors.blue),
                        ),
                        Divider(height: 20),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        ListTile(
                          title: InkWell(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "${item["name"] ?? ''}  ${item["phone"]}"),
                                  SizedBox(height: 10),
                                  Text("${item["address"]}"),
                                ]),
                            onTap: () {
                              this._changeDefaultAdress(item["_id"]);
                            },
                          ),
                          trailing: Icon(Icons.edit, color: Colors.blue),
                        ),
                        Divider(height: 20),
                      ],
                    );
                  }
                }),
            Positioned(
                bottom: 0,
                width: ScreenAdaper.width(750),
                height: ScreenAdaper.height(88),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black26))),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text("增加收货地址", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/adressAdd');
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _getAdressList() async {
    List userinfo = await UserService.getUserInfo();
    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};
    var sign = SignServices.getSign(tempJson);
    var api =
        '${Config.domain}api/addressList?uid=${userinfo[0]['_id']}&sign=$sign';
    var response = await Dio().get(api);
    if (response.data["success"]) {
      setState(() {
        this._addressList = response.data["result"];
      });
    } else {
      Fluttertoast.showToast(
        msg: "网络连接错误",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
  }

  _changeDefaultAdress(id) async {
    List userinfo = await UserService.getUserInfo();
    var tempJson = {
      "uid": userinfo[0]['_id'],
      "id": id,
      "salt": userinfo[0]["salt"]
    };
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/changeDefaultAddress';
    var response = await Dio()
        .post(api, data: {"uid": userinfo[0]['_id'], "id": id, "sign": sign});

    if (response.data["success"]) {
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
