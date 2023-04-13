import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/views/geology/home_page.dart';
import 'package:flutter_application_1/views/layers/layer_list_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';
import 'package:flutter_application_1/views/wells/well_index_page.dart';


class TaskPage extends StatefulWidget {
  final int taskID;
  final TaskController _tasksController = TaskController();

  TaskPage({required this.taskID});
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  Task? _task;
  late List<Well> _wells = [];

  @override
  void initState() {
    super.initState();

    getTask();
  }

  Future<void> getTask() async {
    Task? task = await widget._tasksController.getTaskById(widget.taskID);
    // task.description = "AZAZA";
    setState(() {
      if (task != null)
        _task = task;
    });
  }

  Future<List<Well>> getTaskWells() async {
    _wells = await widget._tasksController.getTaskWells(widget.taskID);

    return _wells;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var addWellBtn = SizedBox(
      width: width,
      child: Text(
        "Добавить скважину",
        textAlign: TextAlign.center,
      )
    );
    var completeBtn = SizedBox(
      width: width,
      child: Text(
        "Завершить задание",
        textAlign: TextAlign.center,
      )
    );

    var backBtn = SizedBox(
      width: width,
      child: Text(
        "Назад",
        textAlign: TextAlign.center,
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Бурение"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            
          }, ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                _task?.description ?? ""
              ),
            ),
          ),
          Flexible(
            child: Text(
              "Список скважин"
            ),
          ),
          Flexible(
            flex: 2,
            child: FutureBuilder<List<Well>>(
              future: getTaskWells(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: _wells.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(_wells[index].name),
                        subtitle: Text(_wells[index].description),
                        onTap: () {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (_) => WellIndexPage(
                              wellID: _wells[index].id, taskID: widget.taskID,
                          )));
                        },
                      )
                    );
                  }
                );
              }
            )
          ),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: addWellBtn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (_) => WellCreatePage(lineID: _task?.line.id ?? 0, taskID: _task?.id ?? 0,)));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: backBtn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => HomePage()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: completeBtn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
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
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
