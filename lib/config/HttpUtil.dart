import '../services/UserService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/AppKey.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BaseUrl {
  // 配置默认请求地址
  static const String url = 'http://jd.itying.com/';
}

class HttpUtil {
  static void get(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function success,
      Function error}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }
    // 发送get请求
    await _sendRequest(url, 'get', success, headers: headers, error: error);
  }

  static void post(String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function success,
      Function error}) async {
    // 发送post请求
    _sendRequest(url, 'post', success,
        data: data, headers: headers, error: error);
  }

  // 请求处理
  static Future _sendRequest(String url, String method, Function success,
      {Map<String, dynamic> data,
      Map<String, dynamic> headers,
      Function error}) async {
    int _code;
    String _msg;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = BaseUrl.url + url;
    }

    try {
      Map<String, dynamic> dataMap = data == null ? new Map() : data;
      Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

      // 配置dio请求信息
      Response response;
      Dio dio = new Dio();
      dio.options.connectTimeout = 10000; // 服务器链接超时，毫秒
      dio.options.receiveTimeout = 3000; // 响应流上前后两次接受到数据的间隔，毫秒
      dio.options.headers
          .addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

      if (method == 'get') {
        response = await dio.get(url);
      } else {
        response = await dio.post(url, data: dataMap);
      }
      print("data:$data url:$url \n respon:$response");
      if (response.statusCode != 200) {
        _msg = '网络请求错误,状态码:' + response.statusCode.toString();
        _handError(error, _msg);
        return;
      }

      // 返回结果处理
      Map<String, dynamic> resCallbackMap = response.data;
      _code = resCallbackMap['code'];
      _msg = resCallbackMap['message'];
      if (success != null) {
        //等于0，显示message；等于1，拿到正确结果；3目前是重新登录
        if (_code == 1) {
          success(resCallbackMap);
        } else if (_code == 3) {
          Fluttertoast.showToast(
              msg: _msg,
              timeInSecForIos: 2,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
          UserService.loginOut();
          //移除所有界面，保留"/"页面，并且重新跳转到login界面
          AppKey.navigatorKey.currentState
              .pushNamedAndRemoveUntil('/login', ModalRoute.withName('/'));
        } else {
          _handError(error, _msg);
        }
      }
    } catch (exception) {
      _handError(error, '数据请求错误：' + exception.toString());
    }
  }

  // 返回错误信息
  static Future _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }
}
