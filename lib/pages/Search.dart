import 'package:flutter/material.dart';
import 'package:shop/services/ScreenAdaper.dart';
import '../services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _keywords;
  List _historyListData = [];

  @override
  void initState() {
    super.initState();
    this._getHistoryData();
  }

  _getHistoryData() async {
    var _historyLsit = await SearchServices.getHistoryList();
    setState(() {
      this._historyListData = _historyLsit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
                hintText: '笔记本',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none)),
            onChanged: (value) {
              setState(() {
                _keywords = value;
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
            onTap: () {
              if (this._keywords.length > 0) {
                SearchServices.setHistoryData(this._keywords);
                Navigator.pushReplacementNamed(context, '/productList',
                    arguments: {'keywords': this._keywords});
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                "热搜",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider(),
            Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("男装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("手机"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("笔记本电脑"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("米"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("化妆品"),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            this._historyListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _historyListWidget() {
    if (this._historyListData.length > 0) {
      return Column(
        children: <Widget>[
          Container(
            child: Text("历史记录", style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
            children: this._historyListData.map((value) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(value),
                    onLongPress: () {
                      this._showAlertDialog(value);
                    },
                  ),
                  Divider()
                ],
              );
            }).toList(),
          ),
          SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: () {
              SearchServices.clearHistoryList();
              this._getHistoryData();
            },
            child: Container(
              width: ScreenAdaper.width(400),
              height: ScreenAdaper.height(64),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Icon(Icons.delete), Text("清空历史记录")],
              ),
            ),
          )
        ],
      );
    } else {
      return Text('');
    }
  }

  _showAlertDialog(keywords) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("提示信息"),
            content: Text("您确定要删除吗?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancle');
                  },
                  child: Text("取消")),
              FlatButton(
                  onPressed: () {
                    SearchServices.removeHistoryData(keywords).then((_){
                      this._getHistoryData();
                      Navigator.pop(context, 'ok');
                    });
                  },
                  child: Text("确定")),
            ],
          );
        });
  }
}
