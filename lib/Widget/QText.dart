import 'package:flutter/material.dart';
import '../services/ScreenAdaper.dart';

class QText extends StatelessWidget {
  final String text;
  final bool password;
  final Object onChanged;
  const QText(
      {Key key,
      this.text = "默认内容",
      this.password = false,
      this.onChanged = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
      ),
      height: ScreenAdaper.height(68),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
    );
  }
}
