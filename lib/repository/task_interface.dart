import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/task_image.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:flutter_application_1/services/status_code.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks();

  Future<Task?> getTaskById(int id);

  Future<List<Well>> getTaskWells(int id);

  Future<List<Task>> getAllTasksFromDb();

  Future<void> completeTask(int taskId);

  Future<bool> checkTaskCompleteness(int taskId);

  Future<List<TaskImage>> getTaskImages(int taskID);
}
