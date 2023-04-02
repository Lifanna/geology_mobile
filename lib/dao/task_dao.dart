import 'package:flutter_application_1/dao/well_dao.dart';
import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/well.dart';

class TaskDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> addTaskToDb(Task task) async {
    final db = await dbProvider.database;

    var taskDatabaseJson = task.toDatabaseJson(task);

    final userTable = 'main_task';
    
    var taskExists = await getTaskById(task.id);

    var wellDao = WellDao();

    if (task.wells != []) {
      task.wells.forEach((well) {
        wellDao.addWellToDb(well);
        wellDao.addWellTask(task.id, well.id);
      });
    }

    if (taskExists == null){
      int lastId = await db.insert("main_task", taskDatabaseJson);
    }
    else {
      await db.update("main_task", taskDatabaseJson, where: 'id = ?', whereArgs: [task.id]); 
    }
  }

  Future<Task?> getTaskById(int id) async {
    final db = await dbProvider.database;

    Task? task;

    List<Map<String, dynamic>> result;

    final String tasksTable = 'main_task';
    result = await db.query(tasksTable, where: 'id=?', whereArgs: [id]);

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
}
