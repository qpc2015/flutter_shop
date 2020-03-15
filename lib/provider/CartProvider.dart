import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/services/Storage.dart';

class CartProvider with ChangeNotifier {
  List _cartList = []; //状态
  bool _isCheckedAll = false; //状态
  double _allPrice = 0; //总价

  List get cartList => this._cartList;
  bool get isCheckAll => this._isCheckedAll;
  double get totalPrice => this._allPrice;

  CartProvider() {
    this.init();
  }

  init() async {
    String result = await Storage.getString('cartList') ?? '';
    if (result.length > 0) {
      this._cartList = json.decode(result);
      // print('pro:$result');
    } else {
      this._cartList = [];
    }
    //获取全选的状态
    this._isCheckedAll = this.isCheckAllData();
    //计算总价
    this.computeAllPrice();
  }

  updateCarList() {
    this.init();
  }

  itemCountChange() {
    Storage.setString('cartList', json.encode(this._cartList));
    //计算总价
    this.computeAllPrice();
    notifyListeners();
  }

  checkAll(value) {
    for (var i = 0; i < this._cartList.length; i++) {
      this._cartList[i]['checked'] = value;
    }
    this._isCheckedAll = value;
    //计算总价
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  bool isCheckAllData() {
    if (this._cartList.length > 0) {
      for (var i = 0; i < this._cartList.length; i++) {
        if (this._cartList[i]['checked'] == false) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  itemChange() {
    if (this.isCheckAllData() == true) {
      this._isCheckedAll = true;
    } else {
      this._isCheckedAll = false;
    }
    //计算总价
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  removeItem() {
    List tempList = [];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList = tempList;
    //计算总价
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]['checked'] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    notifyListeners();
  }
}
