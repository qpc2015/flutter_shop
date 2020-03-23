

import 'package:flutter/material.dart';
import '../pages/Tabs/Tabs.dart';
import '../pages/Search.dart';
import '../pages/ProductList.dart';
import '../pages/ProContent.dart';
import '../pages/Tabs/ShopCar.dart';
import '../pages/Login/Login.dart';
import '../pages/Login/RegisterFirst.dart';
import '../pages/Login/RegisterSecond.dart';
import '../pages/Login/RegisterThird.dart';
import '../pages/Order.dart';
import '../pages/Adress/AddressList.dart';
import '../pages/Adress/AdressAdd.dart';
import '../pages/Adress/AdressEdit.dart';
import '../pages/Pay.dart';
import '../pages/MyOrder.dart';
import '../pages/OrderDetail.dart';
import '../pages/Login/Register.dart';

//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/shopcart': (context) => ShopCarPage(),
  '/login': (context) => LoginPage(),
  '/register':  (context) => RegisterPage(),
  '/registerFirst': (context) => RegisterFirstPage(),
  '/adressList': (context) => AdressListPage(),
  '/adressAdd': (context) => AdressAddPage(),
  '/pay': (context) => PayPage(),
  '/myOrder': (context) => MyOrderPage(),
  '/orderDetail': (context) =>  OrderDetailPage(),
  '/adressEdit': (context,{arguments}) => AdressEditPage(arguments: arguments,),
  '/registerSecond': (context, {arguments}) => RegisterSecondPage(arguments: arguments,),
  '/registerThird': (context, {arguments}) => RegisterThirdPage(arguments: arguments,),
  '/order': (context,{arguments}) => OrderPage(arguments: arguments),
  '/productList': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/productContent': (context, {arguments}) =>
      ProContentPage(arguments: arguments),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
