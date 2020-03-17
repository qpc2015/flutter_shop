import 'package:flutter/material.dart';
import '../services/ScreenAdaper.dart';

class QText extends StatelessWidget {
  final String text;
  final bool password;
  final Object onChanged;
  final int maxLines;
  final double height;
  final TextEditingController contorller;
  const QText(
      {Key key,
      this.text = "默认内容",
      this.password = false,
      this.onChanged = null,
      this.maxLines=1,
      this.height=68,
      this.contorller= null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: this.contorller,
        maxLines: this.maxLines,
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
      ),
      height: ScreenAdaper.height(this.height),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
    );
  }
}
