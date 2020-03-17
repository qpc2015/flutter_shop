import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/services/ScreenAdaper.dart';
import 'package:shop/services/SignServices.dart';
import 'package:shop/services/UserService.dart';

class OrderPage extends StatefulWidget {
  Map arguments;
  OrderPage({Key key,this.arguments}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  List _dataList = [];
  Map _adressData;

  @override
  void initState() { 
    super.initState();
    this._dataList = widget.arguments["checkList"];
    this._getDefaultAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("结算"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                   this._adressData != null ? ListTile(
                     title: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                                             Text("${this._adressData["name"]}  ${this._adressData["phone"]}"),
                          SizedBox(height: 10),
                          Text("${this._adressData["address"]}"),
                       ],
                     ),
                     trailing: Icon(Icons.navigate_next),
                     onTap: (){
                       Navigator.pushNamed(context, "/adressList");
                     },
                   ) :  ListTile(
                      leading: Icon(Icons.add_location),
                      title: Center(
                        child: Text("请添加收货地址"),
                      ),
                      trailing: Icon(Icons.navigate_next),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Column(
                  children: this._dataList.map((value){
                    return Column(
                      children: <Widget>[
                        _checkOutItem(value),
                        Divider()
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("商品总金额:￥100"),
                    Divider(),
                    Text("立减:￥5"),
                    Divider(),
                    Text("运费:￥0"),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdaper.width(750),
            height: ScreenAdaper.height(100),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black26
                  )
                )
              ),
              child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text("总价:￥140", style: TextStyle(color: Colors.red)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    child: RaisedButton(
                      child:
                          Text('立即下单', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
            ),
          )
        ],
      ),
    );
  }

  Widget _checkOutItem(value) {
    return Row(
      children: <Widget>[
        Container(
          width: ScreenAdaper.width(160),
          child: Image.network(
            "${value['pic']}",
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${value['title']}",
                    maxLines: 2,
                  ),
                  Text("${value['selectedAttr']}", maxLines: 2),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("￥${value['price']}", style: TextStyle(color: Colors.red)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("x${value['count']}"),
                      )
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }

  _getDefaultAddress() async{
      List userinfo = await UserService.getUserInfo();
    // print('1234');
    var tempJson = {
      "uid": userinfo[0]["_id"],     
      "salt": userinfo[0]["salt"]
    };
    var sign = SignServices.getSign(tempJson);
    var api = '${Config.domain}api/oneAddressList?uid=${userinfo[0]["_id"]}&sign=$sign';
    var response = await Dio().get(api);
    print(response);
    setState(() {
      this._adressData = response.data["result"][0];
    });
  }
}
