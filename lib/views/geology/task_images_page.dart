import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/dialogs/errorDialog.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/dialogs/messageBoxFunctionDialog.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/task_image.dart';
import 'package:flutter_application_1/models/task_image_single.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/views/detail_pages/detail_screen.dart';
import 'package:flutter_application_1/views/geology/home_page.dart';
import 'package:flutter_application_1/views/layers/layer_list_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';
import 'package:flutter_application_1/views/wells/well_index_page.dart';


class TaskImagesPage extends StatefulWidget {
  final int taskID;
  final String short_name;
  final TaskController _tasksController = TaskController();

  TaskImagesPage({required this.taskID, required this.short_name});
  @override
  TaskImagesPageState createState() => TaskImagesPageState();
}

class TaskImagesPageState extends State<TaskImagesPage> {
  Task? _task;
  late List<Well> _wells = [];
  late List<TaskImage> _images = [];

  @override
  void initState() {
    super.initState();

    getTaskImages();
  }

  Future<List<TaskImage>> getTaskImages() async {
    _images = await widget._tasksController.getTaskImages(widget.taskID);

    return _images;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.short_name),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Фотографии к заданию"
              ),
            ),
          ),
          SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FutureBuilder<List<TaskImage>>(
                future: getTaskImages(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: GestureDetector(
                          child: Image.file(File(_images[index].taskImageSingle.localUrl)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(imagePath: _images[index].taskImageSingle.localUrl);
                            }));
                          },
                        )
                      );
                    }
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
