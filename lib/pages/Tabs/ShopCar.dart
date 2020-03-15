import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import '../../pages/Cart/CartItem.dart';
import '../../services/ScreenAdaper.dart';

class ShopCarPage extends StatefulWidget {
  ShopCarPage({Key key}) : super(key: key);

  @override
  _ShopCarPageState createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {

  bool _isEdit = false;

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.launch), onPressed: (){
            setState(() {
              this._isEdit = !this._isEdit;
            });
            print('编辑');
          })
        ],
      ),
      body: cartProvider.cartList.length > 0
          ? Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: cartProvider.cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CartItem(cartProvider.cartList[index]);
                  },
                ),
                Positioned(
                  bottom: 0,
                  width: ScreenAdaper.width(750),
                  height: ScreenAdaper.height(78),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 1, color: Colors.black12)),
                        color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  child: Checkbox(
                                      value: cartProvider.isCheckAllData(),
                                      activeColor: Colors.pink,
                                      onChanged: (val) {
                                        print(val);
                                        cartProvider.checkAll(val);
                                      })),
                              Text("全选"),
                              SizedBox(width: 20,),
                              this._isEdit ? Text(''):Text("合计: "),
                              this._isEdit ? Text(''): Text("${cartProvider.totalPrice}",style: TextStyle(
                                fontSize: 20,
                                color: Colors.red
                              ),)
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: RaisedButton(
                                  child: this._isEdit ? Text("删除") : Text("结算"),
                                  color: Colors.red,
                                  onPressed: () {
                                    if(this._isEdit){
                                      cartProvider.removeItem();
                                    }
                                  }),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text("您的购物车空空如也"),
            ),
    );
  }
}
