import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';

class FunctionalBlurryDialog extends StatelessWidget {

  String title;
  String content;
  Function()? continueCallBackBool;

  FunctionalBlurryDialog(this.title, this.content, this.continueCallBackBool);
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
        title: Text(title,style: textStyle,),
        content: Text(content, style: textStyle,),
        actions: <Widget>[
          TextButton(
            child: Text("Продолжить", style: TextStyle(color: Colors.green)),
            onPressed: () {
              continueCallBackBool!();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Отмена", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
    );
  }
}