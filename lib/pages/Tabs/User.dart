import 'package:flutter/material.dart';
import 'package:shop/Widget/QButton.dart';
import 'package:shop/services/ScreenAdaper.dart';
import '../../services/UserService.dart';
import '../../services/EventBus.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  List userInfo = [];
  var userinfoEvent;

  @override
  void initState(){
    super.initState();
    this._refreshUserInfo();

    userinfoEvent = eventBus.on<UserEvent>().listen((event){
      print(event.str);
      this._refreshUserInfo();
    });
  }

  @override
  void dispose() {
    userinfoEvent.cancel();
    super.dispose();
  }

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
                this.isLogin
                    ? Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "用户名: ${this.userInfo[0]['username']}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenAdaper.fontSize(32)),
                            ),
                            Text("普通会员",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenAdaper.fontSize(24))),
                          ],
                        ))
                    : Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Text("登录/注册",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
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
            onTap: (){
              Navigator.pushNamed(context, "/myOrder");
            },
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
          Divider(),
          this.isLogin
            ? Container(
                padding: EdgeInsets.all(20),
                child: QButton(
                  color: Colors.red,
                  text: "退出登录",
                  cb: () {
                     UserService.loginOut();
                    this._refreshUserInfo();
                  },
                ),
              )
            : Text("")
        ],
      ),
    );
  }

  _refreshUserInfo() async{
    var islogin = await UserService.getUserLoginState() ;
    var userinfo = await UserService.getUserInfo();
    setState(() {
      this.isLogin = islogin;
      this.userInfo = userinfo;
    });
  }

}
