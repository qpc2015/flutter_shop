import 'package:flutter/material.dart';
import 'package:shop/services/ScreenAdaper.dart';

class ShopCarPage extends StatefulWidget {
  ShopCarPage({Key key}) : super(key: key);

  @override
  _ShopCarPageState createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.launch), onPressed: null)
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Text('$index');
            },
          ),
          Positioned(
            bottom: 0,
            width: ScreenAdaper.width(750),
            height: ScreenAdaper.height(78),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 1, color: Colors.black12)),
                  color: Colors.white),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            child: Checkbox(
                                value: true,
                                activeColor: Colors.pink,
                                onChanged: (val) {})),
                                Text("全选")
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(child: Text("结算"),
                    color:Colors.red,
                    onPressed:(){

                    }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
