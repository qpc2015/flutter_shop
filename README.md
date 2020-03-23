# 易简商城 Flutter 版

##  screen shot for iOS

![IMG_0703](https://github.com/qpc2015/flutter_shop/blob/master/screenshot/001.png)

![IMG_0704](https://github.com/qpc2015/flutter_shop/blob/master/screenshot/002.png)

![IMG_0705](https://github.com/qpc2015/flutter_shop/blob/master/screenshot/003.png)


## Setup

1. **Clone the repo**

```
$ git clone https://github.com/qpc2015/flutter_shop.git
$ cd flutter_shop
```

2. **Running:**

```
$ flutter run
```




## 简介

这是一个用Flutter写的简易商城APP。

主要实现的功能有：
* 框架：App常用的Tab框架，UI根据screenutil按750*1334等比例适配；
* 首页：轮播图,滑动列表；
* 分类：两级列表；
* 购物车：购物车列表和结算订单；
* 我的：未登录/登录状态切换，用户注销,全部订单；
* 登录：获取验证码、用户登录、用户状态缓存；
* 其他：引入极光推送,后面会加入bug统计,因为后台接口使用的别人的,有不少问题,所以数据请求这一块未使用请求封装类HttpUtil。



## 第三方依赖

| 名称及版本                   |        作用        |
| ---------------------------- | :----------------: |
| flutter_swiper: ^1.1.6       |       轮播图       |
| flutter_screenutil: ^1.0.2   |      屏幕适配      |
| dio: ^3.0.9                  |      网络请求      |
| shared_preferences: ^0.5.6+3 |      本地储存      |
| webview_flutter: ^0.3.19+9   |  内置webview加载   |
| event_bus: ^1.1.1            |      事件传递      |
| provider: ^4.0.4             |      状态管理      |
| fluttertoast: ^3.1.3         |       提示框       |
| city_pickers: ^0.1.30        | 三级城市联动选择器 |
| crypto: ^2.1.3               |       加密库       |
| jpush_flutter: ^0.5.3        |        推送        |



## Contact

If you have any suggestions, leave a message here
[简书](https://www.jianshu.com/p/d3f6f3659362)



## License

MIT

## 最后

如果你喜欢这个项目，欢迎给我一个star。里面可能还有许多需要修改的bug,欢迎大家提出来,我将持续更新这个项目)
