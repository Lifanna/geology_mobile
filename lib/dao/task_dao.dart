import 'dart:io';

import 'package:flutter_application_1/dao/license_dao.dart';
import 'package:flutter_application_1/dao/line_dao.dart';
import 'package:flutter_application_1/dao/watercourse_dao.dart';
import 'package:flutter_application_1/dao/well_dao.dart';
import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/task_image.dart';
import 'package:flutter_application_1/models/well.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class TaskDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> addTaskToDb(Task task) async {
    final db = await dbProvider.database;

    final userTable = 'main_task';
    
    var taskExists = await getTaskByShortName(task.short_name);

    var wellDao = WellDao();

    var lineDao = LineDao();

    var licenseDao = LicenseDao();

    var watercourseDao = WatercourseDao();

    // if (task.wells != []) {
    //   task.wells.forEach((well) {
    //     wellDao.addWellToDb(well);
    //     wellDao.addWellTask(task.id, well.id);
    //   });
    // }

    var lineExists = await lineDao.getLineById(task.line.id);

    int line_id = task.line.id;
    int license_id = task.license.id;
    int watercourse_id = task.watercourse.id;

    if (lineExists == null){
      line_id = await lineDao.addLineToDb(task.line);
    }

    var licenseExists = await licenseDao.getLicenseById(task.line.id);

    if (licenseExists == null){
      license_id = await licenseDao.addLicenseToDb(task.license);
    }

    // var watercourseExists = await watercourseDao.getLicenseById(task.line.id);

    // if (watercourseExists == null){
    //   watercourse_id = await licenseDao.addLicenseToDb(task.license);
    // }

    task.line.id = line_id;
    task.license.id = license_id;

    var taskStatusIsEmpty = await getTaskStatusById(task.status.id);

    var taskStatusDatabaseJson = task.status.toDatabaseJson(task.status);

    if (taskStatusIsEmpty){
      // int lastId = await db.insert("main_taskstatus", taskStatusDatabaseJson);
      int lastId = await db.insert("main_taskstatus", {'name': 'выполнено'});
      lastId = await db.insert("main_taskstatus", {'name': 'на выполнении'});
    }

    if (taskExists == null){
      var taskDatabaseJson = task.toDatabaseJson(task);

      int lastId = await db.insert("main_task", taskDatabaseJson);
    }
    else {
      // await db.update("main_task", taskDatabaseJson, where: 'id = ?', whereArgs: [task.id]); 
    }
  }

  Future<Task?> getTaskById(int id) async {
    final db = await dbProvider.database;

    Task? task;

    List<Map<String, dynamic>> result;

    final String tasksTable = 'main_task';
    result = await db.rawQuery("""
      SELECT 
        mt.id, mt.short_name, mt.description, mt.line_id, mt.license_id, 
        mt.created_at, mt.updated_at, mt.watercourse_id,
        mls.name as license_name, mt.watercourse_name, ml.name as line_name FROM main_task mt
      JOIN main_license mls ON
      mls.id = mt.license_id
      JOIN main_line ml ON
      ml.id = mt.line_id
      WHERE mt.id = ${id}
    """);
    var result2 = await db.query(tasksTable);

    if (result.isNotEmpty) {
      task = Task.fromDatabaseJson(result.first);
    }

    return task;
  }

  Future<Task?> getTaskByShortName(String shortName) async {
    final db = await dbProvider.database;

    Task? task;

    List<Map<String, dynamic>> result;

    final String tasksTable = 'main_task';
    result = await db.query(tasksTable, where: 'short_name=?', whereArgs: [shortName]);
    var result2 = await db.query(tasksTable);

    if (result.isNotEmpty) {
      task = Task.fromDatabaseJson(result.first);
    }

    return task;
  }

  Future<List<Well>> getTaskWells(int taskId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.rawQuery("""
      SELECT 
        mw.id as well_id, mw.description as well_description, 
        mw.name as well_name 
      FROM main_welltask mwt
      JOIN main_well mw ON
      mw.id = mwt.well_id
      JOIN main_task mt ON
      mt.id = mwt.task_id
      WHERE mwt.task_id = ${taskId}
    """);

    List<Well> wells = [];

    for (var wellJson in result) {
      wells.add(Well.fromDatabaseJson(wellJson));
    }

    return wells;
  }

  Future<List<Task>> getAllTasksFromDb() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.rawQuery("""
      SELECT 
        mt.id as task_id,
        mt.short_name,
        description as task_description,
        mt.created_at as task_created_at,
        mt.updated_at as task_updated_at,
        mt.license_id as license_id,
        ml.id as line_id,
        ml.name as line_name,
        ms.id as status_id,
        ms.name as status_name
      FROM main_task mt
      JOIN main_line ml ON
      ml.id = mt.line_id
      JOIN main_taskstatus ms ON
      ms.id = mt.status_id
    """);

    List<Task> tasks = [];
    for (var taskJson in result) {
      tasks.add(Task.fromDatabaseJsonCompleted(taskJson));
    }

    return tasks;
  }

  Future<bool> getTaskStatusById(int taskStatusId) async {
    final db = await dbProvider.database;
    var taskStatus = await db.query("main_taskstatus", where: "id=?", whereArgs: [taskStatusId]);
    return taskStatus.isEmpty;
  }

  Future<bool> checkWellPillarPhoto(int taskId) async {
    final db = await dbProvider.database;
    bool pillarPhotoExists = false;

    var wellsExists = await db.rawQuery("""
      SELECT mw.id FROM main_well mw
      JOIN main_welltask mwt ON
      mwt.well_id = mw.id
      WHERE mwt.task_id = ${taskId}
    """);

    var wellWithPillar = await db.rawQuery("""
      SELECT mw.id FROM main_well mw
      JOIN main_welltask mwt ON
      mwt.well_id = mw.id
      WHERE mwt.task_id = ${taskId} AND pillar_photo IS NULL
    """);

    if (wellsExists.isEmpty){
      pillarPhotoExists = true;
    }

    if (wellWithPillar.isNotEmpty) {
      pillarPhotoExists = true;
    }

    return pillarPhotoExists;
  }

  Future<void> completeTask(int taskId) async {
    final db = await dbProvider.database;
    var completed = false;

    var result = await db.rawQuery("""
      UPDATE main_task SET status_id = (SELECT id FROM main_taskstatus WHERE name = 'выполнено') 
      WHERE id = ${taskId}
    """);
  }

  Future<List<Task>> getSavedTasks() async {
    final db = await dbProvider.database;

    var result = await db.query("main_task");

    List<Task> tasks = [];

    for (var taskJson in result) {
      tasks.add(
        Task.fromSavedDatabaseJson(taskJson)
      );
    }

    return tasks;
  }

  Future<List<TaskImage>> getTaskImages(int taskID) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    result = await db.rawQuery("""
      SELECT 
        mti.id as task_image_id, 
        mtis.id as task_image_single_id, 
        mtis.image
      FROM main_taskimage mti
      JOIN main_task mt ON
      mt.id = mti.task_id
      JOIN main_taskimagesingle mtis ON
      mtis.id = mti.task_image_single_id
      WHERE mti.task_id = ${taskID}
    """);

    List<TaskImage> images = [];

    for (var taskImageJson in result) {
      images.add(TaskImage.fromDatabaseJson(taskImageJson));
    }

    return images;
  }

  Future<void> addTaskImagesToDb(TaskImage taskImage) async {
    final db = await dbProvider.database;

    var taskImagesExists = await db.query("main_taskimage", where: 'task_id=?', whereArgs: [taskImage.taskId]);
    if (taskImagesExists.isNotEmpty){
      return;
    }

    var splitedUrl = taskImage.taskImageSingle.remoteUrl.split("/");
    taskImage.taskImageSingle.remoteUrl = taskImage.taskImageSingle.remoteUrl.replaceAll('api/tasks/', 'media/');

    Uri url = Uri.parse(taskImage.taskImageSingle.remoteUrl);
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var localUrl = documentDirectory.path + '/images/${splitedUrl.last}'; 

    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet

    await Directory(firstPath).create(recursive: true);
    File file2 = File(localUrl);
    file2.writeAsBytesSync(response.bodyBytes);

    taskImage.taskImageSingle.localUrl = localUrl;

    var taskImageSingleDatabaseJson = taskImage.taskImageSingle.toDatabaseJson(taskImage.taskImageSingle);

    int lastId = await db.insert("main_taskimagesingle", taskImageSingleDatabaseJson);

    taskImage.taskImageSingle.id = lastId;

    var taskImageDatabaseJson = taskImage.toDatabaseJson(taskImage);

    int lastIdSingle = await db.insert("main_taskimage", taskImageDatabaseJson);
  }
}
