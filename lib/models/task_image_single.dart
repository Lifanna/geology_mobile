import 'dart:io';
import 'package:flutter_application_1/models/task_image.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';


class TaskImageSingle {
  late int id;
  late String remoteUrl;
  late String localUrl;

  TaskImageSingle();

  factory TaskImageSingle.fromJson(Map<dynamic, dynamic> data) {
    TaskImageSingle taskImageSingle = TaskImageSingle();
    taskImageSingle.remoteUrl = data['image']['image'];

    return taskImageSingle;
  }

  factory TaskImageSingle.fromDatabaseJson(Map<String, dynamic> dbJson) {
    TaskImageSingle taskImageSingle = TaskImageSingle();

    taskImageSingle.id = dbJson['id'];

    return taskImageSingle;
  }

  Map<String, dynamic> toDatabaseJson(TaskImageSingle taskImageSingle) {
    var databaseJson = {
      'image': taskImageSingle.localUrl,
    };

    return databaseJson;
  }
}
