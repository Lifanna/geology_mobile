import 'dart:io';

import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  String imagePath;
  DetailScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'image',
            child: Image.file(File(imagePath)),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}