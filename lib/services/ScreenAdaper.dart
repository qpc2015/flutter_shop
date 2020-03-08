import 'package:flutter_screenutil/flutter_screenutil.dart';


class ScreenAdaper{
  
  static init(context){
    ScreenUtil.init(context,width:750,height:1334);
  }

  static height(double value){
    return ScreenUtil().setHeight(value);
  }

  static width(double value){
    return ScreenUtil().setWidth(value);
  }

  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }

  static fontSize(double value){
    return ScreenUtil().setSp(value);
  }

}