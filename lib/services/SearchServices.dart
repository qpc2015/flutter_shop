import 'Storage.dart';
import 'dart:convert';

class SearchServices {

  static setHistoryData(keywords) async{
    try{
      List searchList = json.decode(await Storage.getString('searchList'));
      print(searchList);
      var hasData = searchList.any((v){
        return v == keywords;
      });
      if(!hasData){
        searchList.add(keywords);
        await Storage.setString('searchList', json.encode(searchList));
      }
    }catch(e){
      List temp = List();
      temp.add(keywords);
      await Storage.setString('searchList', json.encode(temp));
    }
  }

  static getHistoryList() async{
    try {
      List historyData = json.decode(await Storage.getString('searchList'));
      return historyData;
    }catch(e){
      return [];
    }
  }

  static Future<void> clearHistoryList() async{
    await Storage.remove('searchList');
  }

  static Future<void> removeHistoryData(keywords) async{    
      List searchListData = json.decode(await Storage.getString('searchList'));
      searchListData.remove(keywords);
      await Storage.setString('searchList', json.encode(searchListData));
  }

}