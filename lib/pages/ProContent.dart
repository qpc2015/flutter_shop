import 'package:flutter/material.dart';
import 'package:shop/Widget/LoadingWidget.dart';
import 'package:shop/services/ScreenAdaper.dart';
import '../pages/Product/ProductFirst.dart';
import '../pages/Product/ProductSecond.dart';
import '../pages/Product/ProductThree.dart';
import '../Widget/QButton.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../model/ProductContentMode.dart';

class ProContentPage extends StatefulWidget {
  final Map arguments;
  ProContentPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProContentPageState createState() => _ProContentPageState();
}

class _ProContentPageState extends State<ProContentPage> {

  ProductContentItem _productContent;

  _getContentData() async{

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
          body: this._productContent != null ? Stack(
            children: <Widget>[
              TabBarView(children: <Widget>[
                ProductFirstPage(this._productContent),
                ProductSecondPage(this._productContent),
                ProductThreePage()
              ]),
              Positioned(child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black26,
                      width: 1
                    )
                    ),
                    color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: ScreenAdaper.height(88),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Text("购物车")
                        ],
                      ),
                    ),
                    Expanded(child: QButton(text: '加入购物车',color: Colors.red,cb: (){

                    },),
                    flex: 1,),
                    Expanded(child: QButton(text:'立即购买',color: Colors.orange,cb:(){

                    }),
                    flex: 1,),
                  ],
                ),
              ),
              width: ScreenAdaper.width(750),
              height: ScreenAdaper.height(88),
              bottom: 0,)
            ],
          ) : LoadingWidget(),
        ));
  }
}
