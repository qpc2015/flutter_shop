import 'dart:convert';
import 'package:crypto/crypto.dart';


class SignServices{
  static getSign(json){
    List jsonKeys = json.keys.toList();
    jsonKeys.sort();//按照 ASCII 字符顺序进行升序排列
    var str = "";
    for(var i=0;i<jsonKeys.length;i++){
      str += '${jsonKeys[i]}${json[jsonKeys[i]]}';
    }
    return md5.convert(utf8.encode(str)).toString();
  }
}