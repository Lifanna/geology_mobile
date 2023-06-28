import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/layer_controller.dart';
import 'package:flutter_application_1/controllers/storage_controller.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/views/geology/task_page.dart';
import 'package:flutter_application_1/views/login/login_page.dart';
import 'package:flutter_application_1/views/syncronize/connectivity.dart';
import 'package:flutter_application_1/views/syncronize/sync_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final TaskController _taskController = TaskController();
  final LayerController _layerController = LayerController();
  final StorageController _storageController = StorageController();

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String? _userID = "";
  late List<Task> _tasks = [];
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    super.initState();

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    getUserTasks();
    getLayerMaterials();
  }

  Future<String?> getUserID() async {
    _userID = await StorageService().readSecureData("userID");
    return _userID;
  }

  Future<List<Task>> getUserTasks() async {
    _tasks = await widget._taskController.getTasks(_source.keys.toList()[0]);
    return _tasks;
  }

  Future<void> getLayerMaterials() async {
    await widget._layerController.getLayerMaterialsFromApi();
  }

  Future<void> refreshTasksListView() async {
    var tasks = await widget._taskController.getTasks(_source.keys.toList()[0]);
    getLayerMaterials();
    setState(() {
      _tasks = tasks;
    });
  }
  
  final icons = [Icons.access_time, Icons.access_time, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Интернет доступен';
        break;
      case ConnectivityResult.wifi:
        string = 'Интернет доступен';
        break;
      case ConnectivityResult.none:
      default:
        string = 'Оффлайн';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${string}'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton (
          icon: Icon(Icons.remove_circle_outlined), 
          onPressed: () { 
            continueCallBack() => {
              widget._storageController.clearDatabase(),
              Navigator.of(context).pop(),
              setState(() {
                _tasks = [];
              }),
            };
            BlurryDialog alert = BlurryDialog("Внимание!", "После подтверждения данного действия, " +
            "база данных очистится и добавленные данные невозможно будет вернуть!"+
            "\n\nВы действительно хотите очистить базу?", continueCallBack);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sync_alt, color: Colors.white),
            onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(builder: (_) => SyncPage(title: "Синхронизация")));
            }
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: (){
              StorageService().deleteAllSecureData();

              Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage(title: "Авторизация")));
            }
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
                            Navigator.push(
                              context, MaterialPageRoute(builder: (_) => TaskPage(
                                taskID: _tasks[index].id,
                                short_name: _tasks[index].short_name,
                            )));
                          },
                          // leading: CircleAvatar(
                          //     backgroundImage: NetworkImage(
                          //         "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                          // trailing: Icon(icons[index])
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