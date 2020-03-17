import 'package:flutter/material.dart';
import 'package:shop/Widget/QButton.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  List payList = [
    {
      "title": "支付宝支付",
      "chekced": true,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
    {
      "title": "微信支付",
      "chekced": false,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("支付"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: this.payList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                            Image.network("${this.payList[index]["image"]}"),
                        title: Text("${this.payList[index]["title"]}"),
                        trailing: this.payList[index]["chekced"]
                            ? Icon(Icons.check)
                            : Text(""),
                        onTap: () {
                          //让payList里面的checked都等于false
                          setState(() {
                            for (var i = 0; i < this.payList.length; i++) {
                              this.payList[i]['chekced'] = false;
                            }
                            this.payList[index]["chekced"] = true;
                          });
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              )),
          QButton(
            text: "支付",
            color: Colors.red,
            height: 74,
            cb: () {
              print("去支付");
            },
          )
        ],
      ),
    );
  }
}
