import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import 'package:shop/services/ScreenAdaper.dart';


class CartNum extends StatefulWidget {
  Map _productItem;
  CartNum(this._productItem,{Key key}) : super(key: key);

  @override
  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  Map _model;
  var cartProvider;

  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    this.cartProvider = Provider.of<CartProvider>(context);
    this._model = widget._productItem;
    
    return Container(
       child: Row(
         children: <Widget>[
           _leftBtn(),
           _centerArea(),
           _rightBtn()
         ],
       ),
    );
  }

  Widget _leftBtn(){
    return GestureDetector(
      onTap: (){
        if(_model['count']>1){
          _model['count']--;
          this.cartProvider.itemCountChange();
        }
      },
      child: Container(
        alignment: Alignment.topCenter,
        width: ScreenAdaper.width(45),
        height: ScreenAdaper.height(45),
        child: Text("-"),
      ),
    );
  }


    Widget _rightBtn(){
    return GestureDetector(
      onTap: (){
          _model['count']++;
          this.cartProvider.itemCountChange();
      },
      child: Container(
        alignment: Alignment.topCenter,
        width: ScreenAdaper.width(45),
        height: ScreenAdaper.height(45),
        child: Text("+"),
      ),
    );
  }

  Widget _centerArea(){
    return Container(
      alignment: Alignment.topCenter,
      width: ScreenAdaper.width(70),
      height: ScreenAdaper.height(45),
      child: Text('${this._model["count"] ?? ''}'),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 1,color: Colors.black12),right: BorderSide(width: 1,color: Colors.black12))
      ),
    );
  }


}

