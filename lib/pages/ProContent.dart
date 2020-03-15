import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Widget/LoadingWidget.dart';
import '../provider/CartProvider.dart';
import 'package:shop/services/ScreenAdaper.dart';
import '../pages/Product/ProductFirst.dart';
import '../pages/Product/ProductSecond.dart';
import '../pages/Product/ProductThree.dart';
import '../Widget/QButton.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/ProductContentMode.dart';
import '../services/EventBus.dart';
import '../services/CarService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProContentPage extends StatefulWidget {
  final Map arguments;
  ProContentPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProContentPageState createState() => _ProContentPageState();
}

class _ProContentPageState extends State<ProContentPage> {
  ProductContentItem _productContent;

  _getContentData() async {
    var api = '${Config.domain}api/pcontent?id=${widget.arguments['id']}';
    print('api:$api');
    var result = await Dio().get(api);
    var productContent = ProductContentModel.fromJson(result.data);
    print(productContent);
    setState(() {
      this._productContent = productContent.result;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getContentData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenAdaper.width(400),
                  child: TabBar(
                    indicatorColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: <Widget>[
                      Tab(
                        child: Text("商品"),
                      ),
                      Tab(
                        child: Text("详情"),
                      ),
                      Tab(
                        child: Text("评价"),
                      ),
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            ScreenAdaper.width(600), 76, 10, 0),
                        items: [
                          PopupMenuItem(
                              child: Row(
                            children: <Widget>[Icon(Icons.home), Text("首页")],
                          )),
                          PopupMenuItem(
                              child: Row(
                            children: <Widget>[Icon(Icons.search), Text("搜索")],
                          ))
                        ]);
                  }),
            ],
          ),
          body: this._productContent != null
              ? Stack(
                  children: <Widget>[
                    TabBarView(
                        physics:
                            NeverScrollableScrollPhysics(), //禁止TabBarView滑动
                        children: <Widget>[
                          ProductFirstPage(this._productContent),
                          ProductSecondPage(this._productContent),
                          ProductThreePage()
                        ]),
                    _getBottomToolBar()
                  ],
                )
              : LoadingWidget(),
        ));
  }

  Widget _getBottomToolBar() {
    var cartProvider = Provider.of<CartProvider>(context);
    return Positioned(
      width: ScreenAdaper.width(750),
      height: ScreenAdaper.height(88),
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Colors.black26, width: ScreenAdaper.height(1))),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: ScreenAdaper.height(86),
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/shopcart');
                },
                child: Column(
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: ScreenAdaper.fontSize(40),
                  ),
                  Text("购物车",
                      style: TextStyle(fontSize: ScreenAdaper.fontSize(28)))
                ],
              ),
              )
            ),
            Expanded(
              child: QButton(
                text: '加入购物车',
                color: Colors.red,
                cb: () async {
                  if (this._productContent.attr.length > 0) {
                    eventBus.fire(new ProductContentEvent("购物车"));
                  } else {
                    await CartService.addCart(this._productContent);
                    cartProvider.updateCarList();
                    Fluttertoast.showToast(
                        msg: '加入购物车成功',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                  }
                },
              ),
              flex: 1,
            ),
            Expanded(
              child: QButton(
                  text: '立即购买',
                  color: Colors.orange,
                  cb: () {
                    if (this._productContent.attr.length > 0) {
                      eventBus.fire(new ProductContentEvent("购物车"));
                    } else {
                      print("立即购买");
                    }
                  }),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
