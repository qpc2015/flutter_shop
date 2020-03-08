import 'package:flutter/material.dart';

class ShopCarPage extends StatefulWidget {
  ShopCarPage({Key key}) : super(key: key);

  @override
  _ShopCarPageState createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text("购物车"),
    );
  }
}