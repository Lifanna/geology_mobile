import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';
import 'package:flutter_application_1/views/login/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.userID});

  final String? userID;

  final TaskController _taskController = TaskController();
  final LayerController _layerController = LayerController();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String? _userID = "";
  late List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();

    getUserTasks();
    getLayerMaterials();
  }

  Future<String?> getUserID() async {
    _userID = await StorageService().readSecureData("userID");
    return _userID;
  }

  Future<List<Task>> getUserTasks() async {
    _tasks = await widget._taskController.getTasks();
    return _tasks;
  }

  Future<void> getLayerMaterials() async {
    await widget._layerController.getLayerMaterialsFromApi();
  }

  Future<void> refreshTasksListView() async {
    var tasks = await widget._taskController.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }
  
  final icons = [Icons.access_time, Icons.access_time, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задания для ${widget.userID}'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: (){
              StorageService().deleteAllSecureData();

              Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage(title: "Авторизация")));
            }
            // child: new Text( 'Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white
            // ),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: FutureBuilder<List<Task>>(
                future: getUserTasks(), // Here you run the check for all queryRows items and assign the fromContact property of each item
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_tasks[index].short_name),
                          subtitle: Text(_tasks[index].description),
                          onTap: () {
                            continueCallBack() => {
                              Navigator.pop(context),
                              Navigator.push(
                                context, MaterialPageRoute(builder: (_) => TaskPage(
                                  taskID: _tasks[index].id,
                                ))),
                            };
                            BlurryDialog alert = BlurryDialog("Предупреждение", "Вы действительно хотите выполнить данное задание?", continueCallBack);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                          // leading: CircleAvatar(
                          //     backgroundImage: NetworkImage(
                          //         "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                          trailing: Icon(icons[index])
                        )
                      );
                    }
                  );
                }
              )
            ),
            Flexible(
              flex: 1,
              child: TextButton(
                child: Text(
                  "Обновить",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                onPressed: () async => await refreshTasksListView(),
              ) 
            ),
          ]
        )
      )
    );
  }
}