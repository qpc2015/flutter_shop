import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/Storage.dart';
import '../../provider/CartProvider.dart';
import '../../Widget/QButton.dart';
import '../../services/ScreenAdaper.dart';
import '../../model/ProductContentMode.dart';
import '../../config/Config.dart';
import '../../services/EventBus.dart';
import '../../services/CarService.dart';

class ProductFirstPage extends StatefulWidget {
  final ProductContentItem _item;
  ProductFirstPage(this._item, {Key key}) : super(key: key);

  @override
  _ProductFirstPageState createState() => _ProductFirstPageState();
}

class _ProductFirstPageState extends State<ProductFirstPage>
    with AutomaticKeepAliveClientMixin {
  ProductContentItem _model;
  List _attr = [];
  String _selectedValue;
  var cartProvider;

  @override
  bool get wantKeepAlive => true;
  var bottomSheetEventBus;

  @override
  void initState() {
    super.initState();
    this._model = widget._item;
    this._attr = widget._item.attr;
    _initAttr();
    //监听广播
    this.bottomSheetEventBus =
        eventBus.on<ProductContentEvent>().listen((event) {
      print(event);
      this._showBottomSeltedSheet();
    });
  }

  @override
  void dispose() {
    this.bottomSheetEventBus.cancel();
    super.dispose();
  }

  _initAttr() {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      for (var j = 0; j < attr[i].list.length; j++) {
        if (j == 0) {
          attr[i]
              .attrSeleteList
              .add({'title': attr[i].list[j], "checked": true});
        } else {
          attr[i]
              .attrSeleteList
              .add({'title': attr[i].list[j], "checked": false});
        }
      }
    }
    _getSelectedAttrValue();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    this.cartProvider = Provider.of<CartProvider>(context);
    //处理图片
    String pic = Config.domain + _model.pic;
    pic = pic.replaceAll('\\', '/');

    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              "$pic",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "${_model.title}",
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenAdaper.fontSize(36)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "${_model.subTitle}",
              style: TextStyle(
                  color: Colors.black54, fontSize: ScreenAdaper.fontSize(28)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text("特价:"),
                      Text(
                        "¥${_model.price}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenAdaper.fontSize(46)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("原价:"),
                      Text(
                        "¥${_model.oldPrice}",
                        style: TextStyle(
                            fontSize: ScreenAdaper.fontSize(28),
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: ScreenAdaper.height(80),
            child: InkWell(
              onTap: () {
                this._showBottomSeltedSheet();
              },
              child: Row(children: <Widget>[
                Text(
                  "已选:   ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${this._selectedValue}")
              ]),
            ),
          ),
          Divider(),
          Container(
            height: ScreenAdaper.height(80),
            child: Row(
              children: <Widget>[
                Text("运费: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费")
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _getAttrWidget(setBottomState) {
    List<Widget> attrList = [];
    this._attr.forEach((attritem) {
      attrList.add(Wrap(children: <Widget>[
        Container(
          width: ScreenAdaper.width(100),
          child: Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.height(32)),
            child: Text(
              "${attritem.cate}: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: ScreenAdaper.width(610),
          child: Wrap(children: _getAttrItemWidget(attritem, setBottomState)),
        ),
      ]));
    });
    return attrList;
  }

  List<Widget> _getAttrItemWidget(arrtitem, setbottomState) {
    // print("173:${arrtitem.attrSeleteList}");
    List<Widget> attritemLsit = [];
    arrtitem.attrSeleteList.forEach((item) {
      attritemLsit.add(Container(
          margin: EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              print(item["title"]);
              this._changeAttr(arrtitem.cate, item["title"], setbottomState);
            },
            child: Chip(
              label: Text("${item["title"]}"),
              padding: EdgeInsets.all(10),
              backgroundColor: item['checked'] ? Colors.red : Colors.black26,
            ),
          )));
    });
    return attritemLsit;
  }

  _changeAttr(cate, title, setBottomState) {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        for (var j = 0; j < attr[i].attrSeleteList.length; j++) {
          attr[i].attrSeleteList[j]["checked"] = false;
          if (title == attr[i].attrSeleteList[j]["title"]) {
            attr[i].attrSeleteList[j]["checked"] = true;
          }
        }
      }
    }
    setBottomState(() {
      this._attr = attr;
    });
    _getSelectedAttrValue();
  }

  //获取选中的值
  _getSelectedAttrValue() {
    // print('214:${this._attr}---${this._attr[0].attrSeleteList}');
    var _list = this._attr;
    List tempArr = [];
    for (var i = 0; i < _list.length; i++) {
      for (var j = 0; j < _list[i].attrSeleteList.length; j++) {
        if (_list[i].attrSeleteList[j]['checked'] == true) {
          tempArr.add(_list[i].attrSeleteList[j]["title"]);
        }
      }
    }
    print('result:${tempArr.join(',')}');
    setState(() {
      this._selectedValue = tempArr.join(',');
      //更新本地选中属性
      this._model.selectedAttr = this._selectedValue;
    });
  }

  _showBottomSeltedSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setBottomState) {
              return Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(ScreenAdaper.width(20)),
                    child: ListView(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _getAttrWidget(setBottomState),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: ScreenAdaper.width(750),
                    height: ScreenAdaper.height(76),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: QButton(
                              color: Color.fromRGBO(253, 1, 0, 0.9),
                              text: "加入购物车",
                              cb: () async {
                                await CartService.addCart(this._model);
                                Fluttertoast.showToast(
                                    msg: '加入购物车成功',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER);
                                Navigator.of(context).pop();
                                this.cartProvider.updateCarList();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: QButton(
                                color: Color.fromRGBO(255, 165, 0, 0.9),
                                text: "立即购买",
                                cb: () {
                                  print('立即购买');
                                },
                              )),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });
  }
}
