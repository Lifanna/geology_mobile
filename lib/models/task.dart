import 'package:flutter_application_1/models/license.dart';
import 'package:flutter_application_1/models/line.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/watercourse.dart';
import 'package:flutter_application_1/models/well.dart';

class TaskStatus {
  late int id;

  late String name;

  TaskStatus();

  factory TaskStatus.fromJson (Map<dynamic, dynamic> data) {
    TaskStatus taskStatus = TaskStatus();
    taskStatus.id = data['id'];
    taskStatus.name = data['name'];

    return taskStatus;
  }

  factory TaskStatus.fromDatabaseJson (Map<dynamic, dynamic> data) {
    TaskStatus taskStatus = TaskStatus();
    taskStatus.id = data['status_id'];

    return taskStatus;
  }

  Map<String, dynamic> toDatabaseJson(TaskStatus taskStatus) {
    var databaseJson = {
      'id': taskStatus.id,
      'name': taskStatus.name,
    };

    return databaseJson;
  }
}

class Task {
  late int id;

  late String short_name;

  late String description;

  late License license;

  late Line line;

  late List<Well> wells;

  late User responsible;

  late TaskStatus status;

  late String comment;

  late String created_at;

  late String updated_at;

  Task();

  factory Task.fromJson(Map<dynamic, dynamic> data) {
    License license = License.fromJson(
      data['license']
    );

    List<Well> wells = [];
    // List<Map<dynamic, dynamic>> wellsJson = ;
    data['wells'].forEach((wellJson) {
      Well well = Well.fromJson(wellJson);
      wells.add(well);
    });

    Task task = Task();
    task.id = data['id'];
    task.short_name = data['short_name'];
    task.description = data['description'];
    task.license = license;
    task.line = Line.fromJson(data['line']);
    task.wells = wells;
    task.responsible = User.fromJson(data['responsible']);
    task.status = TaskStatus.fromJson(data['status']);
    task.comment = data['comment'];
    task.created_at = data['created_at'];
    task.updated_at = data['updated_at'];

    return task;
  }

  Map<String, dynamic> toDatabaseJson(Task task) {
    var databaseJson = {
      'id': task.id,
      'short_name': task.short_name,
      'description': task.description,
      'license_id': task.license.id,
      'line_id': task.line.id,
      'responsible_id': task.responsible.id,
      'status_id': task.status.id,
      'comment': task.comment,
      'created_at': task.created_at,
      'updated_at': task.updated_at,
    };

    return databaseJson;
  }

  factory Task.fromDatabaseJson(Map<String, dynamic> dbJson) {
    Task task = Task();

    task.id = dbJson['id'];
    task.short_name = dbJson['short_name'];
    task.description = dbJson['description'];
    task.license = License.fromTaskJson(dbJson['license_id']);
    task.line = Line.fromDatabaseJson(dbJson);
    // task.wells = wells;
    task.responsible = User.fromJson(dbJson);
    task.status = TaskStatus.fromDatabaseJson(dbJson);
    task.comment = dbJson['comment'];
    task.created_at = dbJson['created_at'];
    task.updated_at = dbJson['updated_at'];

    return task;
  }

  factory Task.fromSavedDatabaseJson(Map<String, dynamic> dbJson) {
    Task task = Task();

    task.id = dbJson['id'];
    task.short_name = dbJson['short_name'];
    task.description = dbJson['description'];

    return task;
  }

  factory Task.fromDatabaseJsonCompleted(Map<String, dynamic> dbJson) {
    Task task = Task();

    Line line = Line();
    line.id = dbJson['line_id'];
    line.name = dbJson['line_name'];

    TaskStatus taskStatus = TaskStatus();
    taskStatus.id = dbJson['status_id'];
    taskStatus.name = dbJson['status_name'];

    task.id = dbJson['task_id'];
    task.short_name = dbJson['short_name'];
    task.description = dbJson['task_description'];
    task.line = line;
    task.status = taskStatus;
    task.created_at = dbJson['task_created_at'];
    task.updated_at = dbJson['task_updated_at'];

    return task;
  }

  factory Task.fromId(int id) {
    Task task = Task();
    task.id = id;
    return task;
  }
}
