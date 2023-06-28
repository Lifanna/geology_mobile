import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/line.dart';

class LineDao {
  final dbProvider = DatabaseProvider.dbProvider;


  Future<int> addLineToDb(Line line) async {
    final db = await dbProvider.database;

    var lineDatabaseJson = line.toDatabaseJson(line);

    int lastId = await db.insert("main_line", lineDatabaseJson);

    return lastId;
  }

  Future<Line?> getLineById(int id) async {
    final db = await dbProvider.database;

    Line? line;

    List<Map<String, dynamic>> result;

    final String linesTable = 'main_line';
    result = await db.query(linesTable, where: 'id=?', whereArgs: [id]);

    if (result.isNotEmpty) {
      line = Line.fromDatabaseJson(result.first);
    }

    return line;
  }
}
