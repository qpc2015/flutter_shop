import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop/config/Config.dart';
import 'package:shop/model/MyOrderModel.dart';
import 'package:shop/services/ScreenAdaper.dart';
import 'package:shop/services/SignServices.dart';
import 'package:shop/services/UserService.dart';

class MyOrderPage extends StatefulWidget {
  MyOrderPage({Key key}) : super(key: key);

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {

  List _orderList = [];

  @override
  void initState() {
    super.initState();
    this._getListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的订单"),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, ScreenAdaper.height(80), 0, 0),
              padding: EdgeInsets.all(ScreenAdaper.width(16)),
              child: ListView(
                children: this._orderList.map((item){
                  return InkWell(
                    child:Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("订单编号: ${item.sId}",style: TextStyle(
                            color: Colors.black54
                          ),),
                        ),
                        Divider(),
                        Column(
                          children: this._orderItemWidget(item.orderItem),
                        ),
                        ListTile(
                          leading: Text("合计：￥345"),
                          trailing: FlatButton(
                            child: Text("申请售后"),
                            onPressed: () {},
                            color: Colors.grey[100],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/orderDetail');
                  },
                  );
                }).toList(),
              ),
            ),
            Positioned(
                top: 0,
                width: ScreenAdaper.width(750),
                height: ScreenAdaper.height(76),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("全部", textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text("待付款", textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text("待收货", textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text("已完成", textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text("已取消", textAlign: TextAlign.center),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }

  void _getListData() async{
    List userinfo = await UserService.getUserInfo();
    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};
    var sign = SignServices.getSign(tempJson);
      var api ='${Config.domain}api/orderList?uid=${userinfo[0]['_id']}&sign=$sign';
    var response = await Dio().get(api);
    var orderModel = new MyOrderModel.fromJson(response.data);
    setState(() {
      this._orderList = orderModel.result;
    });
    print(response);
  }

  List<Widget> _orderItemWidget(orderItems){
    List<Widget> tempList = [];
    for(var i=0;i<orderItems.length;i++){
      tempList.add(Column(
        children: <Widget>[
          SizedBox(height: 10,),
          ListTile(
            leading: Container(
              width: ScreenAdaper.width(120),
              height: ScreenAdaper.width(120),
              child: Image.network('${orderItems[i].productImg}',fit: BoxFit.cover,),
            ),
            title: Text("${orderItems[i].productTitle}"),
            trailing: Text('x${orderItems[i].productCount}'),
          ),
          SizedBox(height: 10)
        ],
      ));
    }
    return tempList;
  }
}
