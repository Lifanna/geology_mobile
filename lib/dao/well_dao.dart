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

    final userTable = 'main_well';
    
    var wellExists = await getWellById(well.id);

    if (wellExists == null){
      int lastId = await db.insert("main_well", wellDatabaseJson);
    }
    else {
      await db.update("main_well", wellDatabaseJson, where: 'id = ?', whereArgs: [well.id]);
    }
  }

  Future<Well?> getWellById(int id) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    final String wellsTable = 'main_well';
    result = await db.query(wellsTable, where: 'id=?', whereArgs: [id]);

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
