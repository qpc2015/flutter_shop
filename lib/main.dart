import 'package:flutter/material.dart';
import './routers/router.dart';
import 'package:provider/provider.dart';
import './provider/CartProvider.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() { 
    super.initState();
    this.initJpush();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
          theme: ThemeData(primaryColor: Colors.white),
        );
      }),
    );
  }

  initJpush() async {
    JPush jpush = new JPush();
    jpush.getRegistrationID().then((jid) {
      print("获取注册的id:$jid"); //可用户指定用户发送
    });

    jpush.setup(
        appKey: "a8c4078c88e63d152ed3f3cb",
        channel: "theChannel",
        production: false,
        debug: false);

    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      //监听消息通知
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } catch (e) {
      print('极光sdk配置异常');
    }

    jpush.setBadge(0);
  }
}
