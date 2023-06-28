import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/license.dart';
import 'package:flutter_application_1/models/line.dart';

class LicenseDao {
  final dbProvider = DatabaseProvider.dbProvider;


  Future<int> addLicenseToDb(License license) async {
    final db = await dbProvider.database;

    var licenseDatabaseJson = license.toDatabaseJson(license);

    int lastId = await db.insert("main_license", licenseDatabaseJson);

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
