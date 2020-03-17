import 'dart:convert';
import '../services/Storage.dart';

class OrderService {
  static getAllPrice(checkOutListData) {
    var tempAllPrice = 0.0;
    for (var i = 0; i < checkOutListData.length; i++) {
      if (checkOutListData[i]["checked"] == true) {
        tempAllPrice +=
            checkOutListData[i]["price"] * checkOutListData[i]["count"];
      }
    }
    return tempAllPrice;
  }

  static removeUnSeletedCartItem() async {
    List _cartList = json.decode(await Storage.getString('cartList') ?? '');
    List _tempList = [];
    for (var i = 0; i < _cartList.length; i++) {
      if (_cartList[i]["checked"] == false) {
        _tempList.add(_cartList[i]);
      }
    }
    Storage.setString("cartList", json.encode(_tempList));
  }
}
