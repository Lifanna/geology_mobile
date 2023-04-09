import 'dart:ui';
import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {

  String title;
  String content;
  final Function(bool) accept;

  WarningDialog(this.title, this.content, this.accept);

  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
      title: new Text(title, style: textStyle,),
      content: new Text(content, style: textStyle,),
      actions: <Widget>[
        new TextButton(
          child: new Text("Продолжить", style: TextStyle(color: Colors.green)),
           onPressed: () {
            accept(true);
            Navigator.of(context).pop();
          },
        ),
        new TextButton(
          child: Text("Отмена", style: TextStyle(color: Colors.red),),
          onPressed: () {
            accept(false);
            Navigator.of(context).pop();
          },
        ),
      ],
      ));
  }
}