import 'package:flutter_application_1/database/database_provider.dart';

class SyncDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<void> clearDatabase() async {
    final db = await dbProvider.database;

    await db.rawDelete("delete from main_mine");
    await db.rawDelete("delete from sqlite_sequence where name='main_mine'");
    await db.rawDelete("delete from main_documentation");
    await db.rawDelete("delete from sqlite_sequence where name='main_documentation'");
    await db.rawDelete("delete from main_layer");
    await db.rawDelete("delete from sqlite_sequence where name='main_layer'");
    await db.rawDelete("delete from main_well");
    await db.rawDelete("delete from sqlite_sequence where name='main_well'");
    await db.rawDelete("delete from main_task");
    await db.rawDelete("delete from sqlite_sequence where name='main_task'");
    await db.rawDelete("delete from sqlite_sequence where name='main_taskimage'");
    await db.rawDelete("delete from main_taskimage");
    await db.rawDelete("delete from sqlite_sequence where name='main_taskimagesingle'");
    await db.rawDelete("delete from main_taskimagesingle");
    await db.rawDelete("delete from main_welltask");
    await db.rawDelete("delete from sqlite_sequence where name='main_welltask'");
    await db.rawDelete("delete from main_layermaterial");
    await db.rawDelete("delete from sqlite_sequence where name='main_layermaterial'");
    await db.rawDelete("delete from main_license");
    await db.rawDelete("delete from sqlite_sequence where name='main_license'");
    await db.rawDelete("delete from main_linelicensewatercourse");
    await db.rawDelete("delete from sqlite_sequence where name='main_linelicensewatercourse'");
    await db.rawDelete("delete from main_line");
    await db.rawDelete("delete from sqlite_sequence where name='main_line'");
    await db.rawDelete("delete from main_licensewatercourse");
    await db.rawDelete("delete from sqlite_sequence where name='main_licensewatercourse'");
    await db.rawDelete("delete from main_customuser");
    await db.rawDelete("delete from sqlite_sequence where name='main_customuser'");
    await db.rawDelete("delete from main_watercourse");
    await db.rawDelete("delete from sqlite_sequence where name='main_watercourse'");
    await db.rawDelete("delete from main_team");
    await db.rawDelete("delete from sqlite_sequence where name='main_team'");
    await db.rawDelete("delete from main_taskstatus");
    await db.rawDelete("delete from sqlite_sequence where name='main_taskstatus'");
    await db.rawDelete("delete from main_role");
    await db.rawDelete("delete from sqlite_sequence where name='main_role'");
    await db.rawDelete("delete from main_licensestatus");
    await db.rawDelete("delete from sqlite_sequence where name='main_licensestatus'");

    print('CLEARED!');
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
      SELECT name, description, comment, line_id, pillar_photo, '' as pillar_photo_file, created_at, updated_at
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
