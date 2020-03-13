import 'dart:async';

import 'package:flutter/material.dart';
import '../../model/ProductContentMode.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductSecondPage extends StatefulWidget {
  final ProductContentItem _item;
  ProductSecondPage(this._item, {Key key}) : super(key: key);

  @override
  _ProductSecondPageState createState() => _ProductSecondPageState();
}

class _ProductSecondPageState extends State<ProductSecondPage> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    print("http://jd.itying.com/pcontent?id=${widget._item.sId}");
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: WebView(
            initialUrl: "http://jd.itying.com/pcontent?id=${widget._item.sId}",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              _toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          ))
        ],
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
