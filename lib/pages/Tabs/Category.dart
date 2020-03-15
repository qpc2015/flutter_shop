import 'package:flutter/material.dart';
import '../../services/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/CategoryModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int _seletctIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getLeftCateData();
  }

  _getLeftCateData() async {
    var api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    var leftCateList = new CategoryModel.fromJson(result.data);
    setState(() {
      this._leftCateList = leftCateList.result;
    });
    //默认获取第一数据
    _getRightCateData(leftCateList.result[0].sId);
  }

  _getRightCateData(pid) async {
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var cateList = new CategoryModel.fromJson(result.data);
    setState(() {
      this._rightCateList = cateList.result;
    });
  }

  Widget _leftCateWidget(leftWidth) {
    return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
            itemCount: _leftCateList.length,
            itemBuilder: (context, index) {
              return Column(children: <Widget>[
                InkWell(
                  child: Container(
                      width: double.infinity,
                      height: ScreenAdaper.height(84),
                      padding: EdgeInsets.only(top: ScreenAdaper.height(24)),
                      child: Text(
                        "${this._leftCateList[index].title}",
                        textAlign: TextAlign.center,
                      ),
                      color: _seletctIndex == index
                          ? Color.fromRGBO(240, 246, 246, 0.9)
                          : Colors.white),
                  onTap: () {
                    setState(() {
                      _seletctIndex = index;
                      this._getRightCateData(this._leftCateList[index].sId);
                    });
                  },
                ),
                Divider(
                  height: 1,
                )
              ]);
            }));
  }

  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: rightItemWidth / rightItemHeight,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: this._rightCateList.length,
              itemBuilder: (context, index) {
                //处理图片
                String pic = this._rightCateList[index].pic;
                pic = Config.domain + pic.replaceAll('\\', '/');
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/productList',
                        arguments: {"cid": this._rightCateList[index].sId});
                  },
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      AspectRatio(
                        child: Image.network("$pic", fit: BoxFit.fill),
                        aspectRatio: 1,
                      ),
                      Container(
                        height: ScreenAdaper.height(28),
                        child: Text(
                          '${this._rightCateList[index].title}',
                          style: TextStyle(fontSize: ScreenAdaper.fontSize(18)),
                        ),
                      )
                    ],
                  )),
                );
              }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;
    //获取计算后的宽度
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak, size: 28, color: Colors.black87),
          onPressed: null,
        ),
        title: InkWell(
          child: Container(
            height: ScreenAdaper.height(68),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.9),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                Text("笔记本",
                    style: TextStyle(fontSize: ScreenAdaper.fontSize(28)))
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.message), onPressed: null),
        ],
      ),
      body: Row(
        children: <Widget>[
          _leftCateWidget(leftWidth),
          _rightCateWidget(rightItemWidth, rightItemHeight),
        ],
      ),
    );
  }
}
