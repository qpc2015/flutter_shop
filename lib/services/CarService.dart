import 'dart:convert';
import '../config/Config.dart';
import '../services/Storage.dart';

class CartService {
  static addCart(item) async {
    Map itemDict = CartService.formatCarData(item);
    String result = await Storage.getString('cartList') ?? '';
    List cartListData = [];
    if (result.length > 0) {
      cartListData = json.decode(result);
      bool hasData = cartListData.any((value) {
        return value['_id'] == itemDict['_id'] &&
            value['selectedAttr'] == itemDict['selectedAttr'];
      });
      if (hasData) {
        for (var i = 0; i < cartListData.length; i++) {
          if (cartListData[i]['_id'] == itemDict['_id'] &&
              cartListData[i]['selectedAttr'] == itemDict['selectedAttr']) {
            cartListData[i]["count"] = cartListData[i]["count"] + 1;
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      } else {
        cartListData.add(itemDict);
        await Storage.setString('cartList', json.encode(cartListData));
      }
    } else {
      cartListData.add(itemDict);
      if(cartListData.length > 0){
        await Storage.setString('cartList', json.encode(cartListData));
      }else{
        print('cartlist0000');
      }
    }
  }

  //过滤数据
  static formatCarData(item) {
    String pic = item.pic;
    pic = Config.domain + pic.replaceAll('\\', '/');
    final Map data = new Map<String, dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;
    //处理 string 和int数据类型不一致
    if(item.price is int || item.price is double){
        data['price'] = item.price;
    }else{
        data['price'] = double.parse(item.price);
    } 
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = pic;
    //是否选中
    data['checked'] = true;
    return data;
  }
}
