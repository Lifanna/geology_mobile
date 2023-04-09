import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/sync_controller.dart';
import 'package:flutter_application_1/controllers/task_controller.dart';
import 'package:flutter_application_1/dialogs/errorDialog.dart';
import 'package:flutter_application_1/dialogs/messageBoxDialog.dart';
import 'package:flutter_application_1/dialogs/successDialog.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/views/geology/home_page.dart';
import 'package:flutter_application_1/views/login/login_page.dart';
import 'package:flutter_application_1/views/syncronize/connectivity.dart';

class SyncPage extends StatefulWidget {
  SyncPage({super.key, required this.title});

  final String title;

  final TaskController _taskController = TaskController();
  final SyncController _syncController = SyncController();

  @override
  SyncPageState createState() => SyncPageState();
}

class SyncPageState extends State<SyncPage> {
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  late List<Task> _tasks = [];
  bool qwe = false;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    // hasNetwork();
  }

  @override
  void dispose() {
    // _connectivity.disposeStream();
    super.dispose();
  }

  // Future<void> hasNetwork() async {
  //   try {
  //     final result = await InternetAddress.lookup('http://192.168.188.102:8000');
  //     // final result = await InternetAddress.lookup('http://192.168.1.62:8000');
  //     setState(() {
  //       qwe = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //     });
  //   } on SocketException catch (_) {
  //     setState(() {
  //       qwe = false;
  //     });
  //   }
  // }

  Future<List<Task>> getAllTasksFromDb() async {
    _tasks = await widget._taskController.getAllTasksFromDb();

    return _tasks;
  }

  Future<void> executeSynchronize() async {
    String syncronized = await widget._syncController.synchronize();

    if (syncronized.contains("Произошла ошибка!")) {
      ErrorDialog alert = ErrorDialog("Ошибка", syncronized);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else {
      var tasks = await getAllTasksFromDb();
      setState(() => _tasks = tasks);
      continueCallBack() => {
        Navigator.pop(context),
        Navigator.push(
          context, MaterialPageRoute(builder: (_) => HomePage())),
      };
      SuccessDialog alert = SuccessDialog("Сообщение", syncronized, continueCallBack);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        string = 'Mobile: Online';
        break;
      case ConnectivityResult.wifi:
        string = 'WiFi: Online';
        break;
      case ConnectivityResult.none:
      default:
        string = 'Offline';
    }

    double width = MediaQuery.of(context).size.width;
    var syncBtn = SizedBox(
      width: width,
      child: Text(
        "Подтвердить",
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
        title: Text(widget.title),
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
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SizedBox(
                  height: 80,
                  child: Text(
                    "Загружаемые задания"
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: SizedBox(
                  height: 150,
                  child: FutureBuilder<List<Task>>(
                    future: getAllTasksFromDb(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          var color = Colors.redAccent; 
                          if (_tasks[index].status.name == "выполнено") {
                            color = Colors.greenAccent;
                          }
                          return Card(
                            child: ListTile(
                              title: Text(_tasks[index].short_name),
                              subtitle: Text(_tasks[index].description),
                              onTap: () {

                              },
                              tileColor: color,
                            )
                          );
                        }
                      );
                    }
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: syncBtn,
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (string == "WiFi: Online"){
                            continueCallBack() async => {
                              Navigator.of(context).pop(),
                              await executeSynchronize(),
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
                          }
                          else {
                            ErrorDialog alert = ErrorDialog("Ошибка", "Интернет-соединение недоступно");
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
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}