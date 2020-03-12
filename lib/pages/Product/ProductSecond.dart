import 'package:flutter/material.dart';
import '../../model/ProductContentMode.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ProductSecondPage extends StatefulWidget {
  final ProductContentItem _item;
  ProductSecondPage(this._item, {Key key}) : super(key: key);

  @override
  _ProductSecondPageState createState() => _ProductSecondPageState();
}

class _ProductSecondPageState extends State<ProductSecondPage> {
  @override
  Widget build(BuildContext context) {
    print("http://jd.itying.com/pcontent?id=${widget._item.sId}");
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: WebviewScaffold(url:"http://jd.itying.com/pcontent?id=${widget._item.sId}"))
        ],
      ),
    );
  }
}
