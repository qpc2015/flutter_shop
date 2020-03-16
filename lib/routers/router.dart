import 'dart:js';

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

//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/shopcart': (context) => ShopCarPage(),
  '/login': (context) => LoginPage(),
  '/order': (context) => OrderPage(),
  '/registerFirst': (context) => RegisterFirstPage(),
  '/registerSecond': (context, {arguments}) => RegisterSecondPage(
        arguments: arguments,
      ),
  '/registerThird': (context, {arguments}) => RegisterThirdPage(
        arguments: arguments,
      ),
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
