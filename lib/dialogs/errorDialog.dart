import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';

class ErrorDialog extends StatelessWidget {

  String title;
  String content;

  ErrorDialog(this.title, this.content);
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
      title: new Text(title,style: textStyle,),
      content: new Text(content, style: textStyle,),
      actions: <Widget>[
        new TextButton(
          child: Text("Закрыть", style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      ));
  }
}