import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/CartProvider.dart';
import '../../services/ScreenAdaper.dart';
import 'CartNum.dart';


class CartItem extends StatefulWidget {
  CartItem(this._itemData,{Key key}) : super(key: key);
  Map _itemData;
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
    Map _itemData;

  @override
  Widget build(BuildContext context) {

     var cartProvider = Provider.of<CartProvider>(context);
    this._itemData = widget._itemData;

    return Container(
      height: ScreenAdaper.height(200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Colors.black12)),
      ),
       child: Row(
         children: <Widget>[
           Container(
             width: ScreenAdaper.width(60),
             child: Checkbox(
               value: _itemData["checked"], 
               onChanged: (value){
                 _itemData["checked"]=!_itemData["checked"];
                 cartProvider.itemChange();
             }),
           ),
           Container(
             width: ScreenAdaper.width(160),
             child: Image.network("${_itemData["pic"]}",fit: BoxFit.cover,),
           ),
           Expanded(child: Container(
             padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Text("${_itemData["title"]}",maxLines: 2,textAlign: TextAlign.left,style: TextStyle(
                 fontSize: ScreenAdaper.fontSize(28)
               ),),
               Text('${_itemData["selectedAttr"]}',maxLines: 2,textAlign: TextAlign.left,style: TextStyle(
                 fontSize: ScreenAdaper.fontSize(26),
                 color: Colors.grey
               )),
               Stack(
                 
                 children: <Widget>[
                 Align(
                   alignment: Alignment.centerLeft,
                   child: Text("￥${_itemData["price"]}",
                   style: TextStyle(
                     color: Colors.red
                   ),),
                 ),
                 Positioned(child: CartNum(_itemData),
                 right: 0,
                 )
               ],)

             ],
           )),
           )
         ],
       ),
    );
  }
}