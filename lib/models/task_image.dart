import 'package:flutter_application_1/models/task_image_single.dart';

class TaskImage {
  late int id;

  late int taskId;

  late TaskImageSingle taskImageSingle;

  TaskImage();

  factory TaskImage.fromJson (Map<dynamic, dynamic> data, int taskId) {
    TaskImage taskImage = TaskImage();

    TaskImageSingle taskImageSingle = TaskImageSingle.fromJson(data);

    taskImage.taskId = taskId;
    taskImage.taskImageSingle = taskImageSingle;

    return taskImage;
  }

  factory TaskImage.fromDatabaseJson(Map<dynamic, dynamic> data) {
    TaskImage taskImage = TaskImage();

    TaskImageSingle taskImageSingle = TaskImageSingle();
    taskImageSingle.id = data['task_image_single_id'];
    taskImageSingle.localUrl = data['image'];

    taskImage.id = data['id'];
    taskImage.taskId = data['task_id'];
    taskImage.taskImageSingle = taskImageSingle;

    return taskImage;
  }

  Map<String, dynamic> toDatabaseJson(TaskImage taskImage) {
    var databaseJson = {
      'task_id': taskImage.taskId,
      'task_image_single_id': taskImage.taskImageSingle.id,
    };

    return databaseJson;
  }
}
