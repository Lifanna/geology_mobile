import 'package:flutter_application_1/dao/line_dao.dart';
import 'package:flutter_application_1/dao/well_dao.dart';
import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/well.dart';

class TaskDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> addTaskToDb(Task task) async {
    final db = await dbProvider.database;

    var taskDatabaseJson = task.toDatabaseJson(task);

    final userTable = 'main_task';
    
    var taskExists = await getTaskById(task.id);

    var wellDao = WellDao();

    var lineDao = LineDao();

    // if (task.wells != []) {
    //   task.wells.forEach((well) {
    //     wellDao.addWellToDb(well);
    //     wellDao.addWellTask(task.id, well.id);
    //   });
    // }

    var lineExists = await lineDao.getLineById(task.line.id);

    if (lineExists == null){
      lineDao.addLineToDb(task.line);
    }

    var taskStatusIsEmpty = await getTaskStatusById(task.status.id);

    var taskStatusDatabaseJson = task.status.toDatabaseJson(task.status);

    if (taskStatusIsEmpty){
      int lastId = await db.insert("main_taskstatus", taskStatusDatabaseJson);
      lastId = await db.insert("main_taskstatus", {'name': 'выполнено'});
      lastId = await db.insert("main_taskstatus", {'name': 'на выполнении'});
    }

    if (taskExists == null){
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
    result = await db.query(tasksTable, where: 'id=?', whereArgs: [id]);
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

  Future<void> completeTask(int taskId) async {
    final db = await dbProvider.database;
    int taskStatus = 2;
    var result = await db.rawQuery("""
      UPDATE main_task SET status_id = (SELECT id FROM main_taskstatus WHERE name = 'выполнено') 
      WHERE id = ${taskId}
    """);

    print("YYYYYYYYY: ${result}");
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
}
