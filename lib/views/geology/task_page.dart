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
import 'package:flutter_application_1/views/geology/task_images_page.dart';
import 'package:flutter_application_1/views/layers/layer_list_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';
import 'package:flutter_application_1/views/wells/well_index_page.dart';


class TaskPage extends StatefulWidget {
  final int taskID;
  final String short_name;
  final TaskController _tasksController = TaskController();

  TaskPage({required this.taskID, required this.short_name});
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  Task? _task;
  late List<Well> _wells = [];
  late List<TaskImage> _images = [];

  @override
  void initState() {
    super.initState();

    getTask();
    getTaskImages();
  }

  Future<void> getTask() async {
    Task? task = await widget._tasksController.getTaskById(widget.taskID);
    setState(() {
      if (task != null){
        _task = task;
      }
        
    });
  }

  Future<List<Well>> getTaskWells() async {
    _wells = await widget._tasksController.getTaskWells(widget.taskID);

    return _wells;
  }

  Future<List<TaskImage>> getTaskImages() async {
    _images = await widget._tasksController.getTaskImages(widget.taskID);

    return _images;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var addWellBtn = SizedBox(
      width: width,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Icon(Icons.add),
          Text(
            " скважину",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    var completeBtn = SizedBox(
      width: width,
      child: Text(
        "Завершить задание",
        textAlign: TextAlign.center,
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.short_name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            // Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomePage()));
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 110,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Лицензия: " + (_task?.license.name ?? "") + "\nЛиния: " + (_task?.line.name ?? "") + "\nВодоток: " + (_task?.watercourse.name ?? ""),
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Описание задания"
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                _task?.description ?? "",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Image.asset('assets/map.jpg'),
                iconSize: 50,
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (_) => TaskImagesPage(
                      taskID: widget.taskID, short_name: widget.short_name,
                  )));
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Список скважин"
              ),
            ),
          ),
          SizedBox(
            height: _wells.length > 0 ? 200 : 0,
            child: FutureBuilder<List<Well>>(
              future: getTaskWells(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: _wells.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(_wells[index].name),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(_wells[index].description),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: _wells[index].layer_comment.replaceAll(" ", "") != "" ? Icon(Icons.comment) : Text(""),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (_) => WellIndexPage(
                              wellID: _wells[index].id, taskID: widget.taskID, short_name: widget.short_name, line_name: _task!.line.name,
                          )));
                        },
                      )
                    );
                  }
                );
              }
            )
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: addWellBtn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (_) => WellCreatePage(lineID: _task?.line.id ?? 0, taskID: _task?.id ?? 0, short_name: widget.short_name,)));
                },
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: completeBtn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  bool pillarPhotoNotExist = await widget._tasksController.checkTaskCompleteness(widget.taskID);
                  if (pillarPhotoNotExist == true){
                    ErrorDialog alert = ErrorDialog("Ошибка", "Не все скважины закрыты (отсутствует фотография штаги)");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );

                    return;
                  }
                  else {
                    continueCallBack() => {
                      Navigator.pop(context),
                      widget._tasksController.completeTask(widget.taskID),
                      Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage())),
                    };
                    BlurryDialog alert = BlurryDialog("Предупреждение", "Вы действительно хотите завершить данное задание?", continueCallBack);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
