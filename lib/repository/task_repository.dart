import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/dao/task_dao.dart';
import 'package:flutter_application_1/models/storage_item.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/task_image.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/repository/task_interface.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';

import 'package:flutter_application_1/dao/dao.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';

class TaskRepository implements ITaskRepository {
  final taskDao = TaskDao();

  TaskRepository();

  @override
  Future<List<Task>> getTasks() async {
    String? accessToken = await StorageService().readSecureData("accessToken");
    String? refreshToken = await StorageService().readSecureData("refreshToken");
    Token token = Token(token: accessToken!, refreshToken: refreshToken!);

    List<Task> tasks =  await fetchTasks(token);

    for (var task in tasks) {
      taskDao.addTaskToDb(task);
      if (task.taskImages.length > 0){
        for (var taskImage in task.taskImages) {
          taskDao.addTaskImagesToDb(taskImage);
        }
      }
    }

    return tasks;
  }

  @override
  Future<List<Task>> getSavedTasks() async {
    List<Task> tasks =  await taskDao.getSavedTasks();

    return tasks;
  }

  @override
  Future<Task?> getTaskById(int id) async {
    return await taskDao.getTaskById(id);
  }

  @override
  Future<List<Well>> getTaskWells(int id) async {
    return await taskDao.getTaskWells(id);
  }

  @override
  Future<List<Task>> getAllTasksFromDb() async {
    return await taskDao.getAllTasksFromDb();
  }
  
  @override
  Future<void> completeTask(int taskId) async {
    return await taskDao.completeTask(taskId);
  }

  @override
  Future<bool> checkTaskCompleteness(int taskId) async {
    return await taskDao.checkWellPillarPhoto(taskId);
  }

  @override
  Future<List<TaskImage>> getTaskImages(int taskID) async {
    return await taskDao.getTaskImages(taskID);
  }
}
