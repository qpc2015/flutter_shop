import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ProductContentEvent{
  String str;
  ProductContentEvent(String str){
    this.str = str;
  }
}

//更新用户中心数据
class UserEvent{
  String str;
  UserEvent(String str){
    this.str = str;
  }
}


class AdressAddEvent{
  String str;
  AdressAddEvent(String str){
    this.str = str;
  }
}

class DefaultAdressChangeEvent{
  String str;
  DefaultAdressChangeEvent(String str){
    this.str = str;
  }
}

class AdressEditEvent{
  String str;
  AdressEditEvent(String str){
    this.str = str;
  }
}