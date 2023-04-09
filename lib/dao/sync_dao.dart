import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/layer.dart';
import 'package:flutter_application_1/models/task.dart';
import 'package:flutter_application_1/models/well.dart';

class SyncDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> clearDatabase() async {
    final db = await dbProvider.database;

    var qwe = await db.rawDelete("delete from main_mine");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_mine'");
    qwe = await db.rawDelete("delete from main_documentation");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_documentation'");
    qwe = await db.rawDelete("delete from main_layer");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_layer'");
    qwe = await db.rawDelete("delete from main_well");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_well'");
    qwe = await db.rawDelete("delete from main_task");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_task'");
    qwe = await db.rawDelete("delete from main_welltask");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_welltask'");
    qwe = await db.rawDelete("delete from main_layermaterial");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_layermaterial'");
    qwe = await db.rawDelete("delete from main_license");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_license'");
    qwe = await db.rawDelete("delete from main_linelicensewatercourse");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_linelicensewatercourse'");
    qwe = await db.rawDelete("delete from main_line");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_line'");
    qwe = await db.rawDelete("delete from main_licensewatercourse");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_licensewatercourse'");
    qwe = await db.rawDelete("delete from main_customuser");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_customuser'");
    qwe = await db.rawDelete("delete from main_watercourse");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_watercourse'");
    qwe = await db.rawDelete("delete from main_team");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_team'");
    qwe = await db.rawDelete("delete from main_taskstatus");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_taskstatus'");
    qwe = await db.rawDelete("delete from main_role");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_role'");
    qwe = await db.rawDelete("delete from main_licensestatus");
    qwe = await db.rawDelete("delete from sqlite_sequence where name='main_licensestatus'");
  }

  Future<List<Map<String, dynamic>>> buildTasks() async {
    final db = await dbProvider.database;

    return await db.rawQuery("""
      SELECT mt.id, mts.name as status_name FROM main_task mt
      JOIN main_taskstatus mts ON
      mt.status_id = mts.id
    """);
  }

  Future<List<Map<String, dynamic>>> buildWells() async {
    final db = await dbProvider.database;

    return await db.rawQuery("""
      SELECT name, description, comment, line_id, created_at, updated_at
      FROM main_well
    """);
  }

  Future<List<Map<String, dynamic>>> buildLayers() async {
    final db = await dbProvider.database;

    return await db.rawQuery("""
      SELECT 
        ml.name, mw.name as well_name, ml.description, ml.comment, ml.layer_material_id, 
        ml.sample_obtained, ml.drilling_stopped, ml.aquifer, 
        mw.line_id, ml.created_at, ml.updated_at
      FROM main_layer ml
      JOIN main_well mw ON
      mw.id = ml.well_id
    """);
  }

  Future<List<Map<String, dynamic>>> buildWellTasks() async {
    final db = await dbProvider.database;

    return await db.rawQuery("""
      SELECT 
        mw.name as well_name, mwt.task_id, 
        mw.line_id
      FROM main_welltask mwt
      JOIN main_task mt ON
      mt.id = mwt.task_id
      JOIN main_well mw ON
      mw.id = mwt.well_id
    """);
  }
}
