import 'package:flutter_application_1/database/database_provider.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/api_connection/api_connection.dart';
import 'package:flutter_application_1/models/api_models.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Map>> getUserToken() async {
    final db = await dbProvider.database;
      var res = await db.query("users");
      return res;
    
  }

  //добавляет наш токен в базу
  Future<int> addTokenToDb(String token, String refreshToken) async {
    final db = await dbProvider.database;

    final data = {'access': token, 'refresh': refreshToken};
    final userTable = 'users';
    int lastId = await db.insert(userTable, data);

    return lastId;
  }
}
