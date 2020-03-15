import 'package:flutter/material.dart';
import 'package:shop/services/ScreenAdaper.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: ScreenAdaper.height(220),
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/user_bg.jpg"),
                    fit: BoxFit.cover)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ClipOval(
                    child: Image.asset(
                      'images/user.png',
                      fit: BoxFit.cover,
                      width: ScreenAdaper.width(100),
                      height: ScreenAdaper.width(100),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Text("登录/注册", style: TextStyle(color: Colors.white)),
                    onTap:(){
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.assessment,
              color: Colors.red,
            ),
            title: Text("全部订单"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.green),
            title: Text("待付款"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_car_wash, color: Colors.orange),
            title: Text("待收货"),
          ),
          Container(
              width: double.infinity,
              height: 10,
              color: Color.fromRGBO(242, 242, 242, 0.9)),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.lightGreen),
            title: Text("我的收藏"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text("在线客服"),
          ),
          Divider()
        ],
      ),
    );
  }
}
