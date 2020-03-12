import 'package:flutter/material.dart';
import '../../model/ProductContentMode.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProductSecondPage extends StatefulWidget {
  final ProductContentItem _item;
  ProductSecondPage(this._item,{Key key}) : super(key: key);

  @override
  _ProductSecondPageState createState() => _ProductSecondPageState();
}

class _ProductSecondPageState extends State<ProductSecondPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           Expanded(
             child: InAppBrowser(
               initialUrl:"http://jd.itying.com/pcontent?id=${widget._item.sId}",
               onProgressChanged: (InAppWebViewController controller, int progress) {
                    print(progress);
                  }
           )
           )
         ],
       ),
    );
  }
}