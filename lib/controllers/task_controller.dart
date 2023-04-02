import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/task_repository.dart';
import 'package:flutter_application_1/repository/user_repository.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';

class TaskController {
  TaskRepository _taskRepo = TaskRepository();

  Future<Task?> getTaskById(int id) async {
    return await _taskRepo.getTaskById(id);
  }

  Future<List<Task>> getTasks() async {
    return await _taskRepo.getTasks();
  }

  Future<List<Well>> getTaskWells(int id) async {
    return await _taskRepo.getTaskWells(id);
  }
}
