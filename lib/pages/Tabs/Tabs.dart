import 'package:flutter/material.dart';
import 'package:shop/services/ScreenAdaper.dart';
import './Home.dart';
import './Category.dart';
import './ShopCar.dart';
import './User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {



  List<Widget>  _pageList = [
    HomePage(),
    CategoryPage(),
    ShopCarPage(),
    UserPage()
  ];

  int _currentIndex=0;
  PageController _pageController;

    @override
  void initState() { 
    super.initState();
    this._pageController = new PageController(initialPage:this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
      appBar: _currentIndex !=3 ? AppBar(
        leading: IconButton(icon: Icon(Icons.center_focus_weak, size:28,color: Colors.black87),
          onPressed: null,
        ),
        title: InkWell(
          child:Container(
            height:ScreenAdaper.height(68),
            decoration:BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.9),
              borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.only(left:10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                Text("笔记本",style:TextStyle(
                  fontSize: ScreenAdaper.fontSize(28)
                ))
              ],
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, '/search');
          },
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.message), onPressed: null),
        ],
      ) : AppBar(
        title: Text("用户中心"),
      ),
      body: PageView(
        controller:this._pageController,
        children:this._pageList
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
            this._pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('分类')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('购物车')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('我的')
          )
        ]
      ),
    );
  }
}