import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/license.dart';
import 'package:flutter_application_1/models/line.dart';
import 'package:flutter_application_1/models/watercourse.dart';

class WatercourseDao {
  final dbProvider = DatabaseProvider.dbProvider;


  Future<int> addWatercourseToDb(WaterCourse waterCourse) async {
    final db = await dbProvider.database;

    var watercourseDatabaseJson = waterCourse.toDatabaseJson(waterCourse);

    int lastId = await db.insert("main_watercourse", watercourseDatabaseJson);

    return lastId;
  }

  Future<License?> getLicenseById(int id) async {
    final db = await dbProvider.database;

    License? license;

    List<Map<String, dynamic>> result;

    final String licensesTable = 'main_license';
    result = await db.query(licensesTable, where: 'id=?', whereArgs: [id]);

    if (result.isNotEmpty) {
      license = License.fromDatabaseJson(result.first);
    }

    return license;
  }
}
