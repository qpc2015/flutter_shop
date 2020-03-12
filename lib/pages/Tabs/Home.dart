import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../services/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List _focusData = [];
  List _likeProductData = [];
  List _hotProductData = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getLikeProductData();
    _getHotProductData();
    print("home");
  }

  _getFocusData() async {
    try {
      var api = '${Config.domain}api/focus';
      Response result = await Dio().get(api);
      var focusList = FocusModel.fromJson(result.data);
      setState(() {
        this._focusData = focusList.result;
      });
    } catch (e) {
      print(e);
    }
  }

  _getLikeProductData() async {
    try {
      var api = '${Config.domain}api/plist?is_hot=1';
      var result = await Dio().get(api);
      var productList = ProductModel.fromJson(result.data);
      setState(() {
        this._likeProductData = productList.result;
      });
    } catch (e) {
      print(e);
    }
  }

  _getHotProductData() async {
    try {
      var api = '${Config.domain}api/plist?is_best=1';
      var result = await Dio().get(api);
      var hotProduct = ProductModel.fromJson(result.data);
      setState(() {
        this._hotProductData = hotProduct.result;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemCount: _focusData.length,
            itemBuilder: (BuildContext context, int index) {
              String picStr = _focusData[index].pic;
              picStr = Config.domain + picStr.replaceAll("\\", "/");
              return new Image.network('$picStr', fit: BoxFit.fill);
            },
            autoplay: true,
            pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: Colors.lightBlue,
            )),
          ),
        ),
      );
    } else {
      return Text("加载中...");
    }
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdaper.height(32),
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Colors.red, width: ScreenAdaper.width(10)))),
      child: Text(value, style: TextStyle(color: Colors.black54)),
    );
  }

  //猜你喜欢
  Widget _guessLikeListWidget() {
    if (this._likeProductData.length > 0) {
      return Container(
        height: ScreenAdaper.height(230),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (contxt, index) {
            String spic = this._likeProductData[index].sPic;
            spic = Config.domain + spic.replaceAll("\\", "/");
            return Column(
              children: <Widget>[
                Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                  child: Image.network('$spic', fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  height: ScreenAdaper.height(44),
                  child: Text("¥${this._likeProductData[index].price}"),
                )
              ],
            );
          },
          itemCount: this._hotProductData.length,
        ),
      );
    } else {
      return Text("加载中...");
    }
  }

  //热门推荐
  Widget _hotProdictWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;

    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: this._hotProductData.map((value) {
          String spic = value.sPic;
          spic = Config.domain + spic.replaceAll("\\", "/");

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/productContent",arguments: {
                  'id':value.sId
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: itemWidth,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(233, 233, 233, 0.9), width: 1),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          "$spic",
                          fit: BoxFit.cover,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                    child: Text(
                      "${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                    child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "¥${value.price}",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "¥${value.oldPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          ))
                    ]),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return ListView(children: <Widget>[
      _swiperWidget(),
      SizedBox(height: ScreenAdaper.height(10)),
      _titleWidget("猜你喜欢"),
      _guessLikeListWidget(),
      // SizedBox(height: ScreenAdaper.height(10)),
      _titleWidget("热门推荐"),
      _hotProdictWidget(),
    ]);
  }
}
