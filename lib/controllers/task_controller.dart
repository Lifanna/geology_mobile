import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/task_repository.dart';
import 'package:flutter_application_1/repository/user_repository.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/views/syncronize/connectivity.dart';

class TaskController {
  TaskRepository _taskRepo = TaskRepository();

  Future<Task?> getTaskById(int id) async {
    return await _taskRepo.getTaskById(id);
  }

  Future<List<Task>> getTasks(ConnectivityResult result) async {
    Map _source = {ConnectivityResult.none: false};
    final MyConnectivity _connectivity = MyConnectivity.instance;

    print("NGNGNGNGG: ${result}");

    if (result != ConnectivityResult.wifi) {
      return await _taskRepo.getSavedTasks();
    }
    else {
      print("TNTNTNNTTNNTNTNTNTNT");
      return await _taskRepo.getTasks();
    }
  }

  Future<List<Well>> getTaskWells(int id) async {
    return await _taskRepo.getTaskWells(id);
  }

  Future<List<Task>> getAllTasksFromDb() async {
    return await _taskRepo.getAllTasksFromDb();
  }

  Future<void> completeTask(int taskId) async {
    return await _taskRepo.completeTask(taskId);
  }
}
