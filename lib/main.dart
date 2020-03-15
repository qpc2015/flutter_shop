import 'package:flutter/material.dart';
import './routers/router.dart';
import 'package:provider/provider.dart';
import './provider/CartProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
}
