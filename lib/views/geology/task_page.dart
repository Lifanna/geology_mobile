import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/views/layers/layer_list_page.dart';
import 'package:flutter_application_1/views/wells/well_create_page.dart';


class TaskPage extends StatefulWidget {
  final int taskID;
  final TaskController _tasksController = TaskController();

  TaskPage({required this.taskID});
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late String _task = "не найдено";
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
        _task = task.description;
    });
  }

  Future<List<Well>> getTaskWells() async {
    _wells = await widget._tasksController.getTaskWells(widget.taskID);

    return _wells;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Бурение"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () { 
            
          }, ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Text(
              _task
            ),
          ),

          Flexible(
            flex: 2,
            child: FutureBuilder<List<Well>>(
              future: getTaskWells(), // Here you run the check for all queryRows items and assign the fromContact property of each item
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
                            context, MaterialPageRoute(builder: (_) => LayerListPage(
                              wellID: _wells[index].id,
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
            flex: 1,
            child: ElevatedButton(
              child: Text('Добавить скважину'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WellCreatePage()));
              },
            ),
          )
        ],
      ),
    );
  }
}
