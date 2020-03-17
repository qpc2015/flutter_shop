import 'package:flutter/material.dart';
import 'package:shop/services/ScreenAdaper.dart';

class MyOrderPage extends StatefulWidget {
  MyOrderPage({Key key}) : super(key: key);

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
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
                children: <Widget>[
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            width: ScreenAdaper.width(120),
                            height: ScreenAdaper.height(120),
                            child: Image.network(
                              'https://www.itying.com/images/flutter/list2.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text("TypeScript入门实战视频教"),
                          trailing: Text('x1'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Container(
                            width: ScreenAdaper.width(120),
                            height: ScreenAdaper.height(120),
                            child: Image.network(
                              'https://www.itying.com/images/flutter/list2.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text("TypeScript入门实战视频教"),
                          trailing: Text('x1'),
                          onTap: (){
                            Navigator.pushNamed(context, '/orderDetail');
                          },
                        ),
                        SizedBox(
                          height: 10,
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
                    
                  )
                ],
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
}
