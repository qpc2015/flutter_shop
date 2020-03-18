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
      body: PageView(
        controller:this._pageController,
        children:this._pageList,
        onPageChanged: (index){
          setState(() {
            this._currentIndex = index;
          });
        },
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