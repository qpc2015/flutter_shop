import 'package:flutter/material.dart';
import 'package:shop/model/ProductModel.dart';
import '../services/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import '../Widget/LoadingWidget.dart';
import '../services/SearchServices.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //用户上拉分页
  ScrollController _scrollController = ScrollController();
  //数据
  List _productList = [];
  //分页
  int _page = 1;
  //每页数据
  int _pageSize = 8;
  /*
  排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  */
  String _sort = "";

  //解决重复请求的问题
  bool _flag = true;
  //是否有数据
  bool _hasMore = true;
  //选中分类id
  int _selectHeaderId=1;
    /*二级导航数据*/
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
          -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];
 //是否有搜索的数据
  bool _hasData = true;
  var _initKeyWordsController = new TextEditingController();
  String _keywords;

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._keywords = widget.arguments["keywords"];
    this._initKeyWordsController.text = this._keywords;

    _getProductListData();
    //监听滚动条滚动事件
    _scrollController.addListener(() {
      //_scrollController.position.pixels //获取滚动条滚动的高度
      //_scrollController.position.maxScrollExtent  //获取页面高度
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (this._flag && this._hasMore) {
          _getProductListData();
        }
      }
    });
  }

  

  _getProductListData() async {
    try {
      setState(() {
        this._flag = false;
      });
      var api;
      if(this._keywords == null){
        api =
          '${Config.domain}api/plist?cid=${widget.arguments["cid"]}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
      }else{
        api ='${Config.domain}api/plist?search=${this._keywords}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
      }
      
      Response result = await Dio().get(api);
      var productList = ProductModel.fromJson(result.data);
       //判断是否有搜索数据
      if(productList.result.length==0 && this._page==1){
        setState(() {
          this._hasData = false;
        });
      }else{
        this._hasData = true;
      }
      print("reslut:$result");
      if (productList.result.length < this._pageSize) {
        print("最后一页数据");
        setState(() {
          this._productList.addAll(productList.result);
          this._flag = true;
          this._hasMore = false;
        });
      } else {
        setState(() {
          this._productList.addAll(productList.result);
          this._page++;
          this._flag = true;
          this._hasMore = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _productListView() {
    if (this._productList.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          controller: this._scrollController,
          itemBuilder: (context, index) {
            ProductItemModel model = _productList[index];
            //处理图片链接
            String pic = model.pic;
            pic = Config.domain + pic.replaceAll('\\', '/');

            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenAdaper.width(180),
                      height: ScreenAdaper.height(180),
                      child: Image.network('$pic', fit: BoxFit.cover),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenAdaper.height(180),
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${model.title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: ScreenAdaper.height(36),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                    //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),

                                    child: Text("4g"),
                                  ),
                                  Container(
                                    height: ScreenAdaper.height(36),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),
                                    child: Text("126"),
                                  ),
                                ],
                              ),
                              Text(
                                "¥${model.price}",
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                Divider(height: 20),
                _showMore(index)
              ],
            );
          },
          itemCount: this._productList.length,
        ),
      );
    } else {
      return LoadingWidget();
    }
  }

  _subHeaderChange(id){
    if(id == 4){
      _scaffoldKey.currentState.openEndDrawer();
      setState(() {
        this._selectHeaderId = id;
      });
    }else{
      setState(() {
        this._selectHeaderId = id;
        this._sort = "${this._subHeaderList[id - 1]["fileds"]}_${this._subHeaderList[id - 1]["sort"]}";
        //重置分页
        this._page = 1;
        //重置数据
        this._productList = [];
        //改变排序数据
        this._subHeaderList[id-1]['sort'] = this._subHeaderList[id-1]['sort'] * -1;
        //回到顶部
        if(this._productList.length>0){
          _scrollController.jumpTo(0);
        }
        this._hasMore = true;
        this._getProductListData();
      });
    }
  }

  Widget _showIcon(id){
    if(id == 2 || id == 3){
      if(this._subHeaderList[id-1]['sort']==1){
        return Icon(Icons.arrow_drop_down);
      }else{
        return Icon(Icons.arrow_drop_up);
      }
    }
    return Text("");
  }

  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      height: ScreenAdaper.height(80),
      width: ScreenAdaper.width(750),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Color.fromRGBO(233, 233, 233, 0.9),
              ),
            ),
            color: Colors.white),
        child: Row(children: this._subHeaderList.map((value){
          return Expanded(
            flex: 1,
            child: InkWell(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("${value["title"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (this._selectHeaderId == value["id"])?Colors.red:Colors.black54
                      ),
                      ),
                      _showIcon(value['id']),
                    ],
                  )
                    ),
              onTap: () {
                _subHeaderChange(value['id']);
              },
            ),
          );
        }).toList()), 
        ),
    );
  }

//是否还有更多数据
  Widget _showMore(index) {
    if(this._hasMore){
      return (index==this._productList.length-1)?LoadingWidget():Text("");
    }else{
      return (index==this._productList.length-1)?Text("--我是有底线的--"):Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
          height: ScreenAdaper.height(68),
          color: Colors.grey,
          child: TextField(
            autofocus:false,
            controller: this._initKeyWordsController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none
              )
            ), 
            onChanged: (value){
              setState(() {
                this._keywords = value;
              });
            },
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              height: ScreenAdaper.height(68),
              width: ScreenAdaper.width(80),
              alignment: Alignment.center,
              child: Text("搜索"),
            ),
            onTap: (){
              this._subHeaderChange(1);
              SearchServices.setHistoryData(this._keywords);
            },
          )
        ],
        ),
        endDrawer: Drawer(
          child: Text("筛选功能"),
        ),
        body: _hasData ? Stack(children: <Widget>[
          _productListView(),
          _subHeaderWidget(),
        ]) : Center(child: Text("没有您要浏览的数据"),)
        );
  }
}
