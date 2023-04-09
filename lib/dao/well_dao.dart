import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/well.dart';

class WellDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> addWellToDb(Well well) async {
    final db = await dbProvider.database;

    var wellDatabaseJson = well.toDatabaseJson(well);

    int lastId = await db.insert("main_well", wellDatabaseJson);
  }

  Future<void> addWellByTask(Well well, int taskId) async {
    final db = await dbProvider.database;

    var wellDatabaseJson = well.toDatabaseJson(well);

    int wellId = await db.insert("main_well", wellDatabaseJson);
    var wellTaskDatabaseJson = well.toWellTaskDatabaseJson(wellId, taskId);

    int lastWellTaskId = await db.insert("main_welltask", wellTaskDatabaseJson);
  }

  Future<Well?> getWellById(int wellId, int taskId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    final String wellsTable = 'main_well';
    result = await db.rawQuery("""
      SELECT well_id, mw.name as well_name, mw.description as well_description, comment, 
      mw.line_id as line_id, ml.name as line_name, mw.created_at, mw.updated_at 
      FROM main_well mw
      JOIN main_welltask mwt ON 
      mwt.well_id = mw.id
      JOIN main_line ml ON 
      mw.line_id = ml.id
      WHERE mwt.task_id = ${taskId} AND mw.id = ${wellId}
    """);

    Well? well;

    if (result.isNotEmpty) {
      well = Well.fromDatabaseJson(result.first);
    }

    return well;
  }

  Future<List<Map<String, dynamic>>> getWellTask(int wellId, int taskId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    final String wellTaskTable = 'main_welltask';

    result = await db.query(wellTaskTable, where: 'well_id=? AND task_id=?', whereArgs: [wellId, taskId]);

    return result;
  }

  Future<void> addWellTask(int wellId, int taskId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    final String wellsTable = 'main_welltask';

    var wellTasks = await getWellTask(wellId, taskId);

    var wellTaskDatabaseJson = {
      'well_id': wellId,
      'task_id': taskId,
    };

    if (wellTasks.isEmpty){
      int lastId = await db.insert("main_welltask", wellTaskDatabaseJson);
    }
  }
}
